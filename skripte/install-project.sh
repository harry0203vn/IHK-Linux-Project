#!/bin/bash
# Run only from the VMware console after a snapshot and preflight review.
source "$(dirname -- "$0")/lib.sh"
root_only
[[ ${1:-} = --apply && ${2:-} = --snapshot-confirmed ]] || die 'Usage: sudo bash skripte/install-project.sh --apply --snapshot-confirmed'
console_only
[[ $(. /etc/os-release; echo "$ID") = ubuntu ]] || die 'Ubuntu required'
PACKAGE=$(cd "$SELF/.." && pwd)
python3 "$SELF/validate-csv.py" "$PACKAGE/daten/groups.csv" "$PACKAGE/daten/users.csv"
[[ ! -L /etc/hosts ]] || die 'Symlink /etc/hosts requires manual review'
if [[ -f $STATE/managed ]]; then
    for csv in groups.csv users.csv; do
        [[ ! -e $DATA/$csv ]] || cmp -s "$PACKAGE/daten/$csv" "$DATA/$csv" || die "Different installed $csv: reconcile VM changes before reinstalling; no overwrite"
    done
fi
for p in "$STATE" "$BASE" /company "$LOG" "$BACKUP"; do safe_dir "$p"; done
if [[ ! -f $STATE/managed ]]; then
    # Never silently adopt data/accounts from earlier coursework.
    for p in "$STATE" "$BASE" /company "$LOG" "$BACKUP"; do [[ ! -e $p ]] || die "Existing path requires review: $p"; done
    for u in admin it.admin support01 sales01 sales02 accounting01 management01 intern01; do
        if getent passwd "$u" >/dev/null; then die "Existing account requires review: $u"; fi
        [[ ! -e /home/$u && ! -L /home/$u ]] || die "Existing home requires review: $u"
    done
    for g in admin it sales accounting management employees; do
        if getent group "$g" >/dev/null; then die "Existing group requires review: $g"; fi
    done
    install -d -m 700 "$STATE" "$STATE/rollback"
    printf 'company-admin-v1\n' > "$STATE/managed"
    hostname > "$STATE/rollback/hostname"
    cp -a /etc/hosts "$STATE/rollback/hosts"
    crontab -l > "$STATE/rollback/root-crontab" 2>/dev/null || :
fi
managed
install -d -m 755 "$BASE" "$BASE/scripts"
install -d -m 750 "$BASE/data" "$LOG" "$LOG/reports"
install -d -m 700 "$BACKUP"
for f in "$SELF"/*.sh "$SELF"/*.py; do install -m 755 "$f" "$BASE/scripts/"; done
install -m 640 "$PACKAGE/daten/"*.csv "$DATA/"
start_log install-project
exec 9>"$STATE/install.lock"; flock -n 9 || die 'Another installation is running'
apt-get update
apt-get upgrade -y --no-remove
apt-get install -y openssh-server curl wget tree nano vim htop net-tools ufw cron git tar gzip python3 acl
if ! getent passwd admin >/dev/null; then
    useradd -m -U -s /bin/bash -c 'IHK project administrator' admin
    touch "$STATE/admin-created"
fi
[[ -f $STATE/admin-created ]] || die 'Unmanaged admin account'
usermod -aG sudo admin
hostnamectl set-hostname server01
# Replace only local host-name mapping, preserve unrelated hosts lines.
python3 - <<'PY'
from pathlib import Path
p = Path('/etc/hosts')
rows = p.read_text().splitlines()
out = []
found = False
for row in rows:
    fields = row.split('#', 1)[0].split()
    if fields and fields[0] == '127.0.1.1':
        # Preserve old aliases and inline comments; add the new hostname.
        if 'server01' not in fields[1:]:
            row = row.replace('127.0.1.1', '127.0.1.1\tserver01', 1)
        found = True
    out.append(row)
if not found:
    out.append('127.0.1.1\tserver01')
p.write_text('\n'.join(out) + '\n')
PY
systemctl enable --now ssh cron
printf '\nSet a local password for admin (not logged; type only at the VM prompt).\n'
if [[ $(passwd -S admin | awk '{print $2}') != P ]]; then passwd admin; fi
printf 'PREPARED. Next: sudo bash /opt/company/scripts/deploy-company.sh\n'
[[ ! -f /var/run/reboot-required ]] || printf 'REBOOT REQUIRED: reboot from console before next batch.\n'
