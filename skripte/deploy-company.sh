#!/bin/bash
source "$(dirname -- "$0")/lib.sh"
start_log deploy-company
"$SELF/setup-users.sh"
"$SELF/setup-folders.sh"
"$SELF/backup-company.sh"
"$SELF/check-disk.sh"
"$SELF/log-report.sh"
printf 'DEPLOYED core. SSH key, security, cron and real tests remain separate batches.\n'
