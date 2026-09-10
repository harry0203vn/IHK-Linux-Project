#!/bin/bash
source "$(dirname -- "$0")/lib.sh"
start_log configure-cron
mode=${1:-install}
case $mode in install|probe|remove-probe) ;; *) die 'Use install, probe or remove-probe';; esac
tmp=$(mktemp "$STATE/crontab-XXXXXX")
trap 'rm -f -- "$tmp"' EXIT
crontab -l > "$tmp" 2>/dev/null || :
cp "$tmp" "$STATE/rollback/crontab-$(date +%Y%m%dT%H%M%S)-$$"
python3 - "$tmp" "$mode" <<'PY'
import sys
from pathlib import Path
p, mode = Path(sys.argv[1]), sys.argv[2]
text = p.read_text()
tag = 'IHK-COMPANY' if mode == 'install' else 'IHK-PROBE'
start, end = f'# BEGIN {tag}', f'# END {tag}'
if text.count(start) != text.count(end) or text.count(start) > 1:
    raise SystemExit('Malformed existing project cron block; review needed')
if start in text:
    a, b = text.index(start), text.index(end) + len(end)
    text = text[:a] + text[b:].lstrip('\n')
jobs = [('0 17 * * *','backup-company'), ('30 16 * * *','daily-admin-report'),
        ('0 * * * *','check-disk'), ('0 18 * * 5','log-report'),
        ('0 19 * * 5','cleanup-old-files')]
# No global PATH/SHELL settings: preserve semantics of unrelated cron entries.
if mode != 'remove-probe':
    text = text.rstrip() + '\n' + start + '\n'
    for schedule, job in jobs:
        schedule = '* * * * *' if mode == 'probe' else schedule
        text += f'{schedule} /opt/company/scripts/cron-runner.sh {job}\n'
    text += end + '\n'
p.write_text(text)
PY
crontab "$tmp"; systemctl enable --now cron
crontab -l
[[ $mode != probe ]] || printf 'TEMPORARY probe: real cron every minute. Wait 2-3 minutes, then remove-probe. This is not proof of the weekly production schedule.\n'
