#!/bin/bash
source "$(dirname -- "$0")/lib.sh"
start_log check-disk
percent=$(df -P / | awk 'NR==2 {gsub(/%/,"",$5); print $5}')
[[ $percent =~ ^[0-9]+$ ]] || die 'Cannot parse disk use'
df -h /
if (( percent >= 80 )); then printf 'WARN disk=%s%% threshold=80%%\n' "$percent"; exit 1; fi
printf 'OK disk=%s%% threshold=80%%\n' "$percent"
