# Admin-Fälle und kontrollierte Fehlerszenarien

Zehn praxisnahe Admin-Fälle und acht kontrollierte Fehlerszenarien wurden mit echten Nachweisen auf der VM durchgeführt. Alle Fault-Skripte greifen absichtlich und reversibel in den Systemzustand ein: vorherige Rechte/Gruppen werden per `trap ... EXIT` zurückgesetzt, ein VM-Snapshot ist vor der Ausführung vorausgesetzt.

## Admin-Fälle

| Fall | Szenario | Umsetzung | Ergebnis |
|---|---|---|---|
| AF01 | Vertrieb kann nicht schreiben | ACL/Rechte-Diagnose, Zugriff verweigert, ACL-Restore, erfolgreicher Nachtest | PASS |
| AF02 | Vertrieb liest Buchhaltung | Temporäre ACL gesetzt, Zugriff nachgewiesen, Original-ACL zurückgespielt, Zugriff wieder verweigert | PASS |
| AF03 | Neuer Mitarbeiter | Neuer Account real angelegt (Gruppe `sales`, `employees`), `id`/`getent` geprüft | PASS |
| AF04 | Backup fehlt | Simuliertes fehlendes Backup-Ziel, realer `tar`-Fehler, normaler Nachtest | PASS |
| AF05 | SSH nicht erreichbar | Echter Dienststopp (Konsole), lokaler `Connection refused`, echter Wiederanlauf | PASS |
| AF06 | Manuell ja, Cron nein | Echter geplanter Fehlaufruf (falscher Pfad), echte Korrektur, beide real per Cron ausgeführt | PASS |
| AF07 | Datei gelöscht | Real gelöscht und SHA-256-gleich wiederhergestellt | PASS |
| AF08 | Teamleiter benötigt Status | Vollständiger Tagesbericht (Disk/Services/SSH-Audit/Log-Report/letzter Backupstand) real geprüft | PASS |
| AF09 | Fehlgeschlagene SSH-Logins | Kontrollierter lokaler Loginversuch mit nicht vorhandenem Benutzer, Journal-Auswertung korrigiert (siehe troubleshooting.md) | PASS |
| AF10 | Backup-Verzeichnis zu offen | Temporäre `755`-Rechte, Zugriff nachgewiesen, Restore auf `700`, Nachtest | PASS |

## Kontrollierte Fehlerfälle

| ID | Fehler | Umsetzung | Ergebnis |
|---|---|---|---|
| F01 | Falsche Ordnerrechte | Fault-Test-Skript | PASS |
| F02 | SSH schlägt fehl | Echter Dienststopp/-neustart | PASS |
| F03 | Cronjob falscher Pfad | Echte geplante Fehlausführung + Korrektur | PASS |
| F04 | Backup-Ziel fehlt | Simuliertes fehlendes Ziel, normaler Nachtest | PASS |
| F05 | Benutzer fehlt Gruppe | Fault-Test-Skript | PASS |
| F06 | Skript ohne `sudo` | Root-Guard greift | PASS |
| F07 | Fehlerhafte CSV-Zeile | Validierung schlägt kontrolliert fehl | PASS |
| F08 | Backup-Rechte zu offen | Fault-Test-Skript, Restore auf `700` | PASS |

Zusätzlich real durchgeführt: ein Plattenschwellenwert-Test mit klar gekennzeichneter Fixture (kein echtes Volllaufen des Datenträgers) und eine ACL-Testmethodik-Korrektur (siehe [troubleshooting.md](troubleshooting.md)) als Bonus-Fehlerfall über dem geforderten Minimum.

Die Fault-Skripte sind bewusst **nicht** Teil des normalen Installationsablaufs und laufen nur nach expliziter Bestätigung an der VM-Konsole.
