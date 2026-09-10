#!/bin/bash
source "$(dirname -- "$0")/lib.sh"
start_log log-report
out=$(report_path log-report)
{
    printf 'Admin Logbericht %s\n' "$(date -Is)"
    printf '\nAktive Benutzer\n'; who
    printf '\nWichtige Dienste\n'; systemctl --no-pager --full status ssh cron ufw || true
    printf '\nSystemwarnungen der letzten 24 Stunden (max. 80 Eintraege)\n'
    journalctl --since '24 hours ago' -p warning --no-pager -n 80
    printf '\nSSH-Ereignisse der letzten 24 Stunden (max. 80 Eintraege)\n'
    journalctl --since '24 hours ago' _COMM=sshd --no-pager -n 80
    printf '\nBewertung: Wiederholte Loginfehler auf Herkunft und Zeitraum pruefen; Warnungen sind Hinweise, kein automatischer Angriffsnachweis.\n'
} > "$out"
cat "$out"; printf 'REPORT %s\n' "$out"
