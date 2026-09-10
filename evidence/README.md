# Evidence

Kuratierte Auswahl realer Terminal-Screenshots und eines Beispiel-Reports aus der Ausführung auf der Ubuntu-VM. Dies ist eine bewusste Auswahl (nicht die vollständige Sammlung) — ausgewählt nach Relevanz für Recruiter/technische Leser, nicht chronologisch vollständig.

## Screenshots

| Datei | Zeigt |
|---|---|
| `AP03_03_ssh_login_success.png` | Externer SSH-Login vom Windows-Administrationsclient, ausschließlich Public-Key-Auth |
| `AP04_01_deploy_users_folders.png` | CSV-gesteuerte Benutzer-/Gruppenanlage, idempotente Reruns |
| `AP04_02_deploy_acl_backup.png` | POSIX-ACL-Setzung, erstes Backup, `systemctl status ssh` |
| `AP09_01_security_cron_configured.png` | SSH-Key-Installation, `configure-security.sh`, UFW-Regeln, Cron-Installation |
| `AP09_02_ssh_retest_ufw_active.png` | Externer Nachtest: Key-Login + aktive UFW-Regeln |
| `AP10_01_fault_tests_f01_f04_f05.png` | Kontrollierte Fehlerszenarien F01 (Ordnerrechte), F04 (fehlendes Backup-Ziel), F05 (fehlende Gruppe) |
| `AP10_07_af05_f02_ssh_outage_pass.png` | Kontrollierter SSH-Dienstausfall inkl. Skriptquelltext und realem Wiederanlauf |
| `AP10_08_af06_f03_cron_failure_pass.png` | Kontrollierter Cronjob-Fehler (falscher Pfad) inkl. Skriptquelltext und Korrektur |
| `AP11_03_t18_diagnostic_acl_root_cause.png` | Root-Cause-Diagnose des ACL-Testfehlers (`test -w` vs. echter Schreibversuch) |
| `AP11_05_run_tests_t18_pass_full.png` | Angewendete Korrektur und vollständiger Testlauf (21/21 automatisiert PASS) |
| `AP11_06_cron_probe_install.png` | Installation des minütlichen Cron-Probe-Modus zur realen Verifikation |
| `AP11_07_cron_probe_log_evidence.png` | Realer Cron-Journal-Nachweis aller 5 Jobs |
| `AP11_09_t24_retention_pass.png` | Retention-Test: abgelaufene Dateien entfernt, frische Dateien erhalten |

## Sample Reports

`sample-reports/daily-admin-report-sample.txt` — ein realer, vollständiger Tagesbericht (`daily-admin-report.sh`), der Diskstatus, Dienststatus, SSH-Audit, Log-Report-Verweis und letzten Backupstand für eine nicht-technische Zielgruppe zusammenfasst.

## Hinweis

Alle IP-Adressen sind private Adressen des Lab-eigenen VMware-NAT-Netzwerks. Es sind keine produktiven Zugangsdaten, privaten Schlüssel oder realen Personendaten enthalten. Alle Benutzer-/Firmendaten sind fiktiv.
