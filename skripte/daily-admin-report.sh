#!/bin/bash
source "$(dirname -- "$0")/lib.sh"
start_log daily-admin-report
out=$(report_path daily-report)
rc=0
{
    printf 'Tagesbericht %s — %s\n' "$(date -Is)" "$(hostname)"
    for script in check-disk check-services ssh-audit log-report; do
        printf '\n=== %s ===\n' "$script"
        if "$SELF/$script.sh"; then printf 'RESULT OK\n'; else code=$?; printf 'RESULT ATTENTION rc=%s\n' "$code"; rc=1; fi
    done
    printf '\n=== Letztes Backup ===\n'
    latest=$(backup_files | sed -n '1s/^[^ ]* //p')
    if [[ -n $latest ]]; then
        age=$(( $(date +%s) - $(stat -c %Y "$latest") ))
        printf '%s; age=%s seconds\n' "$latest" "$age"
        if (( age > 93600 )); then printf 'WARN: backup older than 26 hours\n'; rc=1; fi
    else printf 'WARN: no backup found\n'; rc=1; fi
    printf '\nTeamleitung: RESULT ATTENTION und WARN pruefen. Bericht 16:30, Backup 17:00: letzter verfuegbarer Stand wird bewertet.\n'
    printf 'Overall exit status: %s\n' "$rc"
} > "$out"
cat "$out"; printf 'REPORT %s\n' "$out"
exit "$rc"
