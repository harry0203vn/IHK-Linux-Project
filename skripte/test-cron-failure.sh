#!/bin/bash
# ~3 minutes. A temporary isolated /etc/cron.d entry is removed by EXIT trap.
source "$(dirname -- "$0")/lib.sh"
start_log test-cron-failure
[[ ${1:-} = --apply ]] || die 'Use --apply to run a real scheduled fault/retest'
systemctl is-active --quiet cron || die 'cron not active'
entry=/etc/cron.d/ihk-company-fault
[[ ! -e $entry && ! -L $entry ]] || die 'Existing fault cron entry requires review'
mkdir -p "$STATE/faults"
run=$(mktemp -d "$STATE/faults/cron-$(date +%Y%m%dT%H%M%S)-XXXXXX")
trap 'rm -f -- "$entry"' EXIT
printf '* * * * * root /opt/company/scripts/ihk-nonexistent.sh >> %s/wrong-path.txt 2>&1\n' "$run" > "$entry"
chmod 644 "$entry"
printf 'CONTROLLED FAULT: cron points to missing script. Waiting 75 seconds.\n'
sleep 75
[[ -s $run/wrong-path.txt ]] || die 'No real cron error captured; inspect cron service/journal'
cat "$run/wrong-path.txt"
grep -Eq 'not found|No such file' "$run/wrong-path.txt" || die 'Unexpected cron error'
printf '* * * * * root /opt/company/scripts/check-disk.sh >> %s/corrected.txt 2>&1\n' "$run" > "$entry"
printf 'Corrected script path. Waiting 75 seconds for real cron.\n'
sleep 75
[[ -s $run/corrected.txt ]] || die 'Corrected cron did not execute'
cat "$run/corrected.txt"
grep -q 'OK disk=' "$run/corrected.txt" || die 'Corrected diskcheck not OK'
printf 'F03 PASS: scheduled missing-path error and scheduled corrected run; evidence %s\n' "$run"
