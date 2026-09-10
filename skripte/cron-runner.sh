#!/bin/bash
source "$(dirname -- "$0")/lib.sh"
root_only; managed
case ${1:-} in backup-company|daily-admin-report|check-disk|log-report|cleanup-old-files) job=$1;; *) die 'Unknown job';; esac
safe_dir "$LOG"
[[ ! -L $LOG/cron-execution.log ]] || die 'Log symlink refused'
exec >> "$LOG/cron-execution.log" 2>&1
printf '[%s] START job=%s pid=%s ppid=%s\n' "$(date -Is)" "$job" "$$" "$PPID"
rc=0
"$SELF/$job.sh" || rc=$?
printf '[%s] END job=%s rc=%s\n' "$(date -Is)" "$job" "$rc"
exit "$rc"
