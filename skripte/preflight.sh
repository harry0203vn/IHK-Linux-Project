#!/bin/bash
# Read-only host inventory. Output may be redirected into a file by the operator.
set -uo pipefail
export PATH=/usr/sbin:/usr/bin:/sbin:/bin LC_ALL=C
HERE=$(cd -- "$(dirname -- "$0")" && pwd)
printf 'IHK PREFLIGHT %s\n' "$(date -Is)"
whoami; id; hostnamectl; free -h; df -h /; lsblk -o NAME,SIZE,TYPE,MOUNTPOINTS
printf '\nOPERATOR / TIME\n'; printf 'SUDO_USER=%s\n' "${SUDO_USER:-unset}"; timedatectl
[[ -z ${SUDO_USER:-} ]] || id "$SUDO_USER"
printf '\nNETWORK\n'; ip -br address; ip route
printf '\nSERVICES / LISTENERS\n'; systemctl is-active ssh ssh.socket cron ufw; ss -lnt
printf '\nACCOUNT COLLISIONS (existing names need review)\n'
for u in admin it.admin support01 sales01 sales02 accounting01 management01 intern01; do getent passwd "$u" || true; done
for g in admin it sales accounting management employees; do getent group "$g" || true; done
printf '\nPATH COLLISIONS\n'
for p in /company /opt/company /var/log/company-admin /backup/company /var/lib/company-admin /etc/ssh/sshd_config.d/00-company-admin.conf /etc/sudoers.d/company-admin; do
    if [[ -e $p || -L $p ]]; then ls -ld "$p"; else printf 'ABSENT %s\n' "$p"; fi
done
printf '\nEXISTING CRON (root needed for root crontab)\n'; crontab -l 2>&1 || true
printf '\nFIREWALL / EFFECTIVE SSH CONFIG\n'
if command -v ufw >/dev/null; then ufw status verbose; else printf 'UFW not installed\n'; fi
if command -v sshd >/dev/null; then
    sshd -t
    sshd -T | grep -E '^(port|permitrootlogin|passwordauthentication|pubkeyauthentication|allowusers|allowgroups|denyusers|denygroups) '
    grep -RniE '^[[:space:]]*Match[[:space:]]' /etc/ssh/sshd_config /etc/ssh/sshd_config.d 2>/dev/null || true
else printf 'sshd not installed\n'; fi
printf '\nCSV VALIDATION\n'
python3 "$HERE/validate-csv.py" "$HERE/../daten/groups.csv" "$HERE/../daten/users.csv" || exit 2
printf '\nPREFLIGHT ONLY. No installation or verification claim.\n'
