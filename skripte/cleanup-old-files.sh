#!/bin/bash
source "$(dirname -- "$0")/lib.sh"
start_log cleanup-old-files
[[ ${1:-} = '' || ${1:-} = --dry-run ]] || die 'Only --dry-run supported'
safe_dir "$BACKUP"; safe_dir "$LOG/reports"
exec 9>"$STATE/backup.lock"; flock -n 9 || die 'Backup/cleanup already running'
for dir in "$BACKUP" "$LOG/reports"; do
    [[ -d $dir ]] || die "Missing directory: $dir"
    printf 'BEFORE %s files=%s\n' "$dir" "$(find "$dir" -maxdepth 1 -type f | wc -l)"
    while IFS= read -r -d '' file; do
        printf 'EXPIRED %s\n' "$file"
        [[ ${1:-} = --dry-run ]] || rm -f -- "$file"
    done < <(if [[ $dir = "$BACKUP" ]]; then
        find "$dir" -maxdepth 1 -type f \( -name 'company-????????T??????-*.tar.gz' -o -name 'company-????????T??????-*.tar.gz.sha256' \) -mmin +10080 -print0
    else
        find "$dir" -maxdepth 1 -type f \( -name 'log-report-*.txt' -o -name 'daily-report-*.txt' \) -mmin +43200 -print0
    fi)
    printf 'AFTER %s files=%s\n' "$dir" "$(find "$dir" -maxdepth 1 -type f | wc -l)"
done
