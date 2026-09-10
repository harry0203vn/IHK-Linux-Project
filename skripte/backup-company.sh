#!/bin/bash
source "$(dirname -- "$0")/lib.sh"
start_log backup-company
[[ $# = 0 || ( $# = 1 && $1 = --fault-test-missing-target ) ]] || die 'Unknown argument'
safe_dir /company; safe_dir "$BACKUP"
exec 9>"$STATE/backup.lock"; flock -n 9 || die 'Backup/cleanup already running'
[[ -d /company && -d $BACKUP ]] || die 'Missing source or destination'
file="$BACKUP/company-$(date +%Y%m%dT%H%M%S)-$$.tar.gz"
partial="$file.partial"
trap 'rm -f -- "$partial"' EXIT
if [[ ${1:-} = --fault-test-missing-target ]]; then
    [[ ! -e $BACKUP/.ihk-deliberately-missing-target && ! -L $BACKUP/.ihk-deliberately-missing-target ]] || die 'Fault fixture path exists; refuse test'
    printf 'CONTROLLED FAULT: missing target directory; normal backup directory remains intact\n'
    tar -czpf "$BACKUP/.ihk-deliberately-missing-target/archive.tar.gz" -C / company
else
    tar --acls --xattrs --numeric-owner -czpf "$partial" -C / company
fi
gzip -t "$partial"
tar -tzf "$partial" >/dev/null
mv -- "$partial" "$file"; chmod 600 "$file"
sha256sum "$file" > "$file.sha256"
printf 'BACKUP_OK %s\n' "$file"
# Exact project naming only; no recursion; strictly older than 7*24 hours.
find "$BACKUP" -maxdepth 1 -type f -name 'company-????????T??????-*.tar.gz' -mmin +10080 -print -delete
find "$BACKUP" -maxdepth 1 -type f -name 'company-????????T??????-*.tar.gz.sha256' -mmin +10080 -print -delete
