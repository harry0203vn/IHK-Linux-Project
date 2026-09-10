#!/bin/bash
source "$(dirname -- "$0")/lib.sh"
start_log ssh-audit
sshd -t
printf 'EFFECTIVE CONFIG (global; Match contexts require separate review)\n'
sshd -T | grep -E '^(port|permitrootlogin|passwordauthentication|pubkeyauthentication|authorizedkeysfile) '
printf '\nSSH journal: last 24 hours\n'
events=$(journalctl --since '24 hours ago' _COMM=sshd --no-pager -o short-iso)
printf '%s\n' "$events" | grep -E 'Accepted |Failed |Invalid user|authentication failure' || true
failures=$(printf '%s\n' "$events" | grep -c 'Failed password\|Failed publickey' || true)
printf 'Failed authentication events (not unique people): %s\n' "$failures"
printf 'Active sessions:\n'; who
rootmode=$(sshd -T | awk '$1=="permitrootlogin" {print $2}')
[[ $rootmode = no ]] || { printf 'WARN: root login setting=%s\n' "$rootmode"; exit 1; }
printf 'OK: root SSH login disabled. Zero events is not evidence of a tested login.\n'
