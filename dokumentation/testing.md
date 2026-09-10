# Testprotokoll

Alle Tests wurden real auf der Ubuntu-VM (`server01`) ausgeführt. T02–T09a und T11–T23 laufen automatisiert über `skripte/run-tests.sh --apply`; T01, T10 und T24 wurden gesondert real durchgeführt (externer SSH-Login, Cron-Probe, Retention-Lauf). Geforderte Mindestanzahl: 16 Tests — hier 24/24 real dokumentiert.

| Test-ID | Bereich | Testfall | Erwartetes Ergebnis | Status |
|---|---|---|---|---|
| T01 | SSH | Key-Login vom externen Windows-Client (publickey-only) | Login ohne Passwort-Prompt, korrekter `whoami`/Hostname | PASS |
| T02 | System | Hostname korrekt gesetzt | `server01` | PASS |
| T03 | Benutzer | Gruppen aus `groups.csv` angelegt | 5/5 Gruppen vorhanden | PASS |
| T04 | Rechte | Vertrieb kann in `/company/sales` schreiben | Zugriff erlaubt | PASS |
| T05 | Rechte | Vertrieb kann **nicht** in `/company/accounting` schreiben | Zugriff verweigert | PASS |
| T06 | Benutzer | `setup-users.sh` idempotent (zweiter Lauf) | Keine unerwarteten Änderungen | PASS |
| T07 | Rechte | `setup-folders.sh` legt Ordner mit korrekten Rechten an | `2770` + korrekte ACL | PASS |
| T08 | Backup | Backup wird real erstellt | `tar.gz`-Archiv im Backup-Verzeichnis | PASS |
| T09/T09a | Restore | Restore nach Löschung, SHA-256-Vergleich | Wiederhergestellte Datei hashgleich | PASS |
| T10 | Cron | Alle 5 Cronjobs feuern real zur erwarteten Zeit | 5 reale Ausführungen in Log + Journal | PASS |
| T11 | Monitoring | `check-disk.sh` meldet Auslastung korrekt | OK unterhalb der Schwelle | PASS |
| T12 | Monitoring | `check-services.sh` prüft relevante Dienste | Alle erwarteten Dienste aktiv gemeldet | PASS |
| T13 | Sicherheit | `ssh-audit.sh` prüft SSH-Härtung | `PermitRootLogin no`, `PubkeyAuthentication yes` erkannt | PASS |
| T14 | Logging | `log-report.sh` erzeugt lesbaren Bericht | Report mit SSH-/Cron-/UFW-Status | PASS |
| T15 | Reporting | `daily-admin-report.sh` erzeugt Tagesbericht | Verständlicher Statusbericht | PASS |
| T16 | Firewall | UFW aktiv, SSH-Port erlaubt | `active`, `22/tcp ALLOW` | PASS |
| T17 | Rechte | Zweiter, fachfremder Benutzer sieht fremde Abteilung nicht | Zugriff verweigert | PASS |
| T18 | Rechte/ACL | `it.admin` kann via ACL in `/company/accounting` schreiben | Schreibzugriff erlaubt (ACL-basiert) | PASS (nach Korrektur der Testmethode) |
| T19 | Rechte | `/company/public` für alle Mitarbeiter zugänglich | Zugriff erlaubt | PASS |
| T20 | Rechte | `/backup/company` für normale Mitarbeiter unzugänglich | Zugriff verweigert (`700`, `root:root`) | PASS |
| T21 | Cleanup | Preview-Modus zeigt Löschkandidaten ohne zu löschen | Keine echte Löschung im Preview | PASS |
| T22 | Benutzer | `admin`-Account in `sudo`-Gruppe | Mitgliedschaft bestätigt | PASS |
| T23 | Validierung | `validate-csv.py` akzeptiert korrekte CSV | Keine Fehler bei gültigen Dateien | PASS |
| T24 | Retention | Retention entfernt abgelaufene, behält frische Dateien | Alte Fixtures entfernt, frische behalten | PASS |

## Zusammenfassung

24/24 Tests real durchgeführt und bestanden. Automatisierter Kernlauf (T02–T09a, T11–T23): 0 Fehler. Gesondert real durchgeführt: T01 (externer SSH-Login), T10 (Cron-Probe), T24 (Retention-Lauf).

## Kontrollierte Fehlerfälle (Fault Injection)

Zusätzlich zu den Funktionstests existiert eine separate Reihe kontrollierter Fehlerszenarien (`run-fault-tests.sh`, `test-ssh-outage.sh`, `test-cron-failure.sh`, `test-disk-threshold.sh`, `run-business-cases.sh`), die absichtlich Fehlerzustände herbeiführen und die Recovery/Fehlerbehandlung verifizieren — siehe [../dokumentation/ADMIN_CASES.md](ADMIN_CASES.md) und [troubleshooting.md](troubleshooting.md).
