# Linux Sysadmin Lab

Ubuntu-Firmenserver-Lab mit Bash-Automatisierung, CSV-gesteuerter Benutzerverwaltung, SSH-Härtung, POSIX-ACL-Rechtekonzept, Backup/Restore mit Retention, Cronjob-Automatisierung, Logging und kontrollierten Fehlerszenarien.

> **Hinweis:** Dies ist ein persönliches Lab-/Lernprojekt in einer virtuellen Maschine, ursprünglich im Rahmen einer IHK-Weiterbildung (Fachinformatik) umgesetzt. Es handelt sich **nicht** um ein produktives Deployment und **nicht** um reale Unternehmensdaten — das simulierte Unternehmen "XYZ GmbH" sowie alle Benutzerdaten sind fiktiv.

## 1. Projektüberblick

Das Lab simuliert den Aufbau und Betrieb eines kleinen Firmenservers: von der Erstinbetriebnahme über CSV-gesteuerte Benutzer-/Gruppenverwaltung mit einem abteilungsbasierten Rechtekonzept bis hin zu automatisiertem Backup, geplanten Wartungsaufgaben (Cron) und einer eigenen Testsuite inklusive kontrollierter Fehlerinjektion. Alle beschriebenen Ergebnisse wurden real auf einer Ubuntu-VM ausgeführt und mit Terminal-Nachweisen belegt (siehe [evidence/](evidence/)).

## 2. Ziele

- Praktische Umsetzung zentraler Aufgaben der Linux-Systemadministration in einer realistischen, aber sicheren Laborumgebung
- Automatisierung wiederkehrender Administrationsaufgaben statt manueller Einzelschritte
- Nachvollziehbare, reale Verifikation statt angenommener Ergebnisse (jeder Test erzeugt echte, prüfbare Artefakte)
- Bewusstes Dokumentieren auch von real aufgetretenen Fehlern und deren Root-Cause-Analyse

## 3. Skills Demonstrated

- Linux-Systemadministration (Ubuntu, Bash)
- Benutzer-/Gruppenverwaltung, datengetriebene Automatisierung (CSV + Validierung)
- Dateisystemrechte: klassische Unix-Rechte, `setgid`, POSIX-ACLs
- SSH-Härtung (Public-Key-Auth, `sshd`-Drop-in-Konfiguration, UFW)
- Backup-/Restore-Strategien mit Integritätsprüfung (SHA-256) und Retention
- Cron-basierte Automatisierung mit strukturiertem Logging
- Testautomatisierung inkl. kontrollierter Fehlerinjektion (Fault Injection)
- Root-Cause-Analyse realer Fehler (nicht nur Implementierung, auch Diagnose)
- Reproduzierbare Deployment-Pakete mit Checksummen-Verifikation (Python)

## 4. Architektur

Siehe [dokumentation/architecture.md](dokumentation/architecture.md) für Systementwurf, Verzeichnisstruktur und Netzwerkmodell.

## 5. Hauptfunktionen

| Bereich | Beschreibung |
|---|---|
| Benutzerverwaltung | CSV-gesteuert, validiert, idempotent, kein Standardpasswort/sudo für Mitarbeiter |
| Rechtekonzept | Abteilungsordner mit `setgid` + POSIX-ACL, geprüfte Isolation zwischen Abteilungen |
| SSH | Public-Key-only für Administration, `PermitRootLogin no`, UFW-Integration |
| Backup/Restore | `tar.gz` + SHA-256, atomare Veröffentlichung, 7-Tage-Retention, geprüfter Restore |
| Automatisierung | 5 Cronjobs, strukturiertes Logging, reversibler Probe-Modus zur Verifikation |
| Monitoring | Disk-/Service-/SSH-Checks, Tagesbericht |
| Testing | 24 dokumentierte Tests + 10 Admin-Fälle + 8 kontrollierte Fehlerszenarien |
| Deployment-Paket | Reproduzierbares ZIP mit `MANIFEST.json`-Checksummen-Verifikation |

## 6. Repository-Struktur

```
linux-sysadmin-lab/
├── README.md
├── skripte/              # Bash-/Python-Administrationsskripte (10 Pflichtskripte + Hilfsskripte)
├── daten/                 # CSV-Testdaten (Benutzer, Gruppen — fiktiv)
├── konfiguration/          # SSH-Konfigurationsnotizen, Crontab-Referenz
├── tests/                  # Python-Unittests (CSV-Validierung, Konsolen-Guard)
├── tools/                  # Paketierung/Verifikation des Deployment-Pakets
├── dokumentation/           # Architektur, Rechte, Backup, Monitoring, Testing, Troubleshooting
└── evidence/                # Ausgewählte Screenshots und Beispiel-Reports
```

## 7. Benutzer- und Rechteverwaltung

Siehe [dokumentation/users-and-permissions.md](dokumentation/users-and-permissions.md) — inkl. eines real aufgetretenen ACL-Testfehlers und dessen Analyse.

## 8. SSH und Sicherheit

- Administrativer Zugriff ausschließlich per Public-Key (ED25519); Passwort-Login bleibt für nicht-administrative Zugänge serverseitig verfügbar, wird für die Administration aber nicht genutzt.
- `PermitRootLogin no`, Konfiguration über eine separate `sshd`-Drop-in-Datei (kein Editieren der Hauptkonfiguration).
- UFW gibt den effektiv konfigurierten SSH-Port frei, **bevor** die Firewall aktiviert wird.

Details: [konfiguration/sshd_config_notizen.txt](konfiguration/sshd_config_notizen.txt).

## 9. Backup und Restore

Siehe [dokumentation/backup-and-restore.md](dokumentation/backup-and-restore.md).

## 10. Automatisierung / Cron

Siehe [dokumentation/monitoring-and-cron.md](dokumentation/monitoring-and-cron.md).

## 11. Logging

Strukturierte Logs pro Skript unter `/var/log/company-admin/`; der Tagesbericht (`daily-admin-report.sh`) fasst Status, Warnungen und den letzten Backupzeitpunkt für eine nicht-technische Zielgruppe (Teamleitung) zusammen.

## 12. Testing und Fehlerszenarien

24 dokumentierte Tests (Minimum 16 übertroffen), 10 praxisnahe Admin-Fälle und 8 kontrollierte Fehlerszenarien — jeweils mit realem Nachtest nach jeder Korrektur:

- [dokumentation/testing.md](dokumentation/testing.md)
- [dokumentation/ADMIN_CASES.md](dokumentation/ADMIN_CASES.md)
- [dokumentation/troubleshooting.md](dokumentation/troubleshooting.md) — drei ausführlich dokumentierte reale Fehlerfälle mit Root-Cause-Analyse

## 13. Deployment / Nutzung

Das Runbook für die Erstinbetriebnahme (Batches 0–7, mit Snapshot-Absicherung vor riskanten Schritten) steht in [dokumentation/DEPLOYMENT.md](dokumentation/DEPLOYMENT.md). Das reproduzierbare Deployment-Paket wird mit `tools/build-package.py` erzeugt und mit `tools/check-package.py` bzw. `skripte/verify-package.py` gegen eine `MANIFEST.json`-Checksumme geprüft.

## 14. Ausgewählte Nachweise

Eine kuratierte Auswahl realer Terminal-Screenshots (SSH-Zugriff, Benutzer-/Rechteverwaltung, ACL, Backup/Restore, Cron-Ausführung, Testergebnisse, Fehlerszenarien) liegt in [evidence/](evidence/) — siehe dort für die vollständige Übersicht.

## 15. Sicherheitsaspekte

- Keine privaten Schlüssel, Passwörter, Tokens oder produktiven Zugangsdaten in diesem Repository — alle SSH-Schlüssel wurden projektspezifisch erzeugt und verbleiben außerhalb von Git.
- Alle Benutzer-/Firmendaten sind fiktiv (Testdaten für ein Lab-Szenario).
- Skripte verwenden durchgängig einen Root-Guard, absolute Pfade und ein festes `PATH`, um typische Bash-Automatisierungsfehler zu vermeiden.
- Kontrollierte Fehlerszenarien greifen nur nach expliziter Bestätigung und mit VM-Snapshot in den Systemzustand ein und setzen alle Änderungen per `trap ... EXIT` zurück.

## 16. Grenzen des Labs

- Backup liegt auf derselben VM wie die Quelldaten (Lab-Vereinfachung, siehe [dokumentation/backup-and-restore.md](dokumentation/backup-and-restore.md)).
- Passwort-Login bleibt serverseitig aus Kompatibilitätsgründen aktiv, wird für die Administration aber nicht genutzt.
- Dies ist kein produktiv gehärtetes System; es demonstriert Konzepte und Arbeitsweise, nicht eine vollständige Enterprise-Security-Baseline.

## 17. Projekthintergrund

Dieses Lab wurde im Rahmen einer IHK-Weiterbildung im Bereich Fachinformatik/Systemadministration eigenständig umgesetzt und anschließend als eigenständiges, bereinigtes öffentliches Portfolio-Repository aufbereitet (kuratierte technische Inhalte, keine internen Projektmanagement- oder Sitzungsdaten).
