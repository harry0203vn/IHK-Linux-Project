#!/bin/bash
source "$(dirname -- "$0")/lib.sh"
start_log test-retention
[[ ${1:-} = --apply ]] || die 'Use --apply: isolated zero-byte fixtures in managed paths'
safe_dir "$BACKUP"; safe_dir "$LOG/reports"
old="$BACKUP/company-20000101T000000-$$.tar.gz"
fresh="$BACKUP/company-20000102T000000-$$.tar.gz"
oldreport="$LOG/reports/log-report-retention-$$.txt"
freshreport="$LOG/reports/daily-report-retention-$$.txt"
for f in "$old" "$fresh" "$oldreport" "$freshreport"; do [[ ! -e $f && ! -L $f ]] || die 'Fixture collision'; done
trap 'rm -f -- "$old" "$fresh" "$oldreport" "$freshreport"' EXIT
touch "$old" "$fresh" "$oldreport" "$freshreport"
touch -d '8 days ago' "$old"
touch -d '31 days ago' "$oldreport"
printf 'CONTROLLED RETENTION FIXTURES (zero-byte files, not real backups)\n'
stat -c '%n %y' "$old" "$fresh" "$oldreport" "$freshreport"
"$SELF/cleanup-old-files.sh"
[[ ! -e $old && ! -e $oldreport && -f $fresh && -f $freshreport ]] || die 'Retention test failed'
printf 'RETENTION PASS: expired files removed; fresh files retained.\n'
