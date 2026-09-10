#!/bin/bash
# Collect actual outputs; never invent expected values as observed results.
source "$(dirname -- "$0")/lib.sh"
start_log collect-evidence
mkdir -p "$STATE/evidence"
run=$(mktemp -d "$STATE/evidence/run-$(date +%Y%m%dT%H%M%S)-XXXXXX")
capture() {
    local name=$1; shift
    local rc=0
    { printf 'TIME %s\nCOMMAND ' "$(date -Is)"; printf '%q ' "$@"; printf '\n'; "$@" || rc=$?; printf '\nEXIT=%s\n' "$rc"; } > "$run/$name.txt" 2>&1
}
capture system bash -c 'hostnamectl; id admin; free -h; df -h /; ip -br address; ip route'
capture accounts bash -c 'getent passwd admin it.admin support01 sales01 sales02 accounting01 management01 intern01; getent group it sales accounting management employees'
capture permissions bash -c 'ls -ld /company /company/* /backup/company; getfacl -p /company/sales /company/accounting'
capture ssh-config bash -c 'sshd -t && sshd -T | grep -E "^(port|permitrootlogin|passwordauthentication|pubkeyauthentication) "'
capture cron crontab -l
capture cron-journal journalctl -u cron --since '24 hours ago' --no-pager
capture firewall ufw status verbose
capture packages dpkg-query -W openssh-server curl wget tree nano vim htop net-tools ufw cron git tar gzip python3 acl
capture services systemctl --no-pager --full status ssh ssh.socket cron ufw
cp -a "$LOG" "$run/logs"
[[ ! -d $STATE/tests ]] || cp -a "$STATE/tests" "$run/tests"
[[ ! -d $STATE/faults ]] || cp -a "$STATE/faults" "$run/faults"
cp -a "$DATA" "$run/data"
bundle="$STATE/evidence-$(date +%Y%m%dT%H%M%S)-$$.tar.gz"
tar -czf "$bundle" -C "$run" .
sha256sum "$bundle"
printf 'EVIDENCE_BUNDLE %s\nCopy this file back; contains logs and usernames, no private SSH keys or shadow database. Review before sharing.\n' "$bundle"
