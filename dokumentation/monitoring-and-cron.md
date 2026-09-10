# Monitoring, Logging und Cronjobs

## Automatisierte Zeitpläne

`configure-cron.sh` verwaltet ausschließlich einen klar markierten Block im `root`-Crontab (`# BEGIN/END IHK-COMPANY`) — bereits vorhandene, projektfremde Cron-Einträge bleiben unangetastet:

| Zeitpunkt | Aufgabe |
|---|---|
| täglich 17:00 | `backup-company` |
| täglich 16:30 | `daily-admin-report` |
| stündlich (volle Stunde) | `check-disk` |
| Freitag 18:00 | `log-report` |
| Freitag 19:00 | `cleanup-old-files` |

Ein Wrapper-Skript (`cron-runner.sh`) setzt für jeden Job ein festes `PATH`, protokolliert Start, Ende und Exitcode strukturiert in `/var/log/company-admin/cron-execution.log`.

Für die Verifikation existiert ein reversibler **Probe-Modus**: Alle fünf Jobs werden vorübergehend auf minütliche Ausführung umgestellt, real per `journalctl`/Log abgeglichen und anschließend sauber entfernt (`remove-probe`). Ein manuell gestarteter Wrapper allein gilt dabei ausdrücklich **nicht** als Cron-Nachweis — nur die real vom Scheduler ausgelöste Ausführung zählt.

## Systemprüfungen

| Skript | Prüfung |
|---|---|
| `check-disk.sh` | Plattenauslastung von `/`, Warnung ab 80 % |
| `check-services.sh` | Status von `ssh`, `cron`, `ufw` (inkl. tatsächlich aktiver Firewall-Regeln, nicht nur Dienststatus) |
| `ssh-audit.sh` | Fehlgeschlagene SSH-Authentifizierungsversuche der letzten 24 h aus dem Journal |
| `log-report.sh` | Zeitlich eingegrenzter, lesbarer Auszug aus System- und SSH-Logs |
| `daily-admin-report.sh` | Zusammenfassender Tagesbericht: Komponentenstatus, Warnungen, letzter Backupzeitpunkt |

`daily-admin-report.sh` läuft bewusst **vor** dem täglichen Backup (16:30 vs. 17:00) und bewertet deshalb den zuletzt verfügbaren Backupstand, statt fälschlich ein bereits abgeschlossenes Backup des laufenden Tages vorauszusetzen. Warnende Prüfungen liefern konsequent einen von Null verschiedenen Exitcode, statt Erfolg zu behaupten.

## SSH-Audit ohne moderne OpenSSH-Prozessnamen-Falle

Ein real aufgetretener Fehlerfall beim Auswerten fehlgeschlagener SSH-Logins zeigte: Moderne OpenSSH-Versionen unter Ubuntu trennen den lauschenden Prozess (`sshd`) vom eigentlichen Verbindungs-Handler (`sshd-session`). Ein `journalctl`-Filter, der ausschließlich `_COMM=sshd` prüft, übersieht dadurch reale Login-Fehlversuche. Die Korrektur filtert auf beide Prozessnamen gleichzeitig (`_COMM=sshd _COMM=sshd-session`), damit die Auswertung unabhängig von der installierten OpenSSH-Version funktioniert. Details siehe [troubleshooting.md](troubleshooting.md).
