#!/bin/bash
source "$(dirname -- "$0")/lib.sh"
start_log services
rc=0
for svc in ssh cron ufw; do
    state=$(systemctl is-active "$svc" || true)
    printf '%s: %s\n' "$svc" "$state"
    [[ $state = active ]] || rc=1
done
ufw status verbose
ufw status | grep -q '^Status: active' || rc=1
exit "$rc"
