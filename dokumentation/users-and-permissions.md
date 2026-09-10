# Benutzer-, Gruppen- und Rechteverwaltung

## Gruppenmodell

| Gruppe | Beschreibung |
|---|---|
| `it` | IT-Abteilung |
| `sales` | Vertrieb |
| `accounting` | Buchhaltung |
| `management` | Geschäftsführung |
| `employees` | Alle Mitarbeiter |

Quelle: [`daten/groups.csv`](../daten/groups.csv), [`daten/users.csv`](../daten/users.csv) (fiktive Testdaten).

## CSV-gesteuerte Verwaltung

`setup-users.sh` liest die CSV-Dateien, validiert sie zuerst mit `validate-csv.py` (Regex-geprüfte Namen, keine Duplikate, keine reservierten Namen, keine Shell-Metazeichen in Feldern) und verwaltet ausschließlich die dort registrierten Accounts:

- Wiederholtes Ausführen ist sicher (idempotent): bestehende IDs bleiben erhalten, fehlende Gruppen werden ergänzt.
- Keine automatische Löschung ausgeschiedener Mitarbeiter und keine Entfernung fremder, zusätzlicher Gruppen — das schützt bestehende Accounts außerhalb der Projektregistrierung.
- Mitarbeiter-Accounts erhalten kein Standardpasswort und kein `sudo`.
- Der separate Remote-Administrator `admin` wird nicht über die CSV verwaltet.

## Rechtekonzept (Verzeichnisse und ACL)

| Ordner | Owner:Gruppe | Rechte | Begründung |
|---|---|---|---|
| `/company` | `root:root` | `755` | Durchgang zu geschützten Abteilungsordnern |
| `/company/it` | `root:it` | `2770` + ACL | Technische Daten nur für IT |
| `/company/sales` | `root:sales` | `2770` + IT-ACL | Vertrieb schreibt, IT verwaltet |
| `/company/accounting` | `root:accounting` | `2770` + IT-ACL | Finanzdaten nicht für Vertrieb lesbar |
| `/company/management` | `root:management` | `2770` + IT-ACL | Interne Leitungsdaten geschützt |
| `/company/public` | `root:employees` | `2770` | Gemeinsame Daten, keine anonymen Leser |
| `/backup/company` | `root:root` | `700`, Archive `600` | Backups enthalten Daten aller Abteilungen |

`2770` = `770` + `setgid` (neue Dateien erben die Gruppenzugehörigkeit des Ordners). Default-ACLs sorgen dafür, dass diese Vererbung auch für neu angelegte Unterobjekte gilt. Der IT-Abteilung wird zusätzlicher Zugriff über POSIX-ACL-Einträge (`group:it:rwx`, Default-ACL) gewährt, ohne eine systemweite `sudo`-Berechtigung zu erteilen.

## Bekannte Falle: Shell-Tests und ACL

Ein real aufgetretener Fehler zeigt eine wichtige Lektion für POSIX-ACL-Setups:

> `test -w <pfad>` (Bash/Coreutils, `access()`/`euidaccess()`) wertet ausschließlich die traditionellen Unix-Rechtebits aus. Erhält ein Benutzer sein Schreibrecht **ausschließlich** über einen POSIX-ACL-Eintrag (nicht über die traditionelle Gruppenzugehörigkeit), liefert `test -w` ein **False-Negative** — obwohl ein echter Schreibvorgang (`touch`, `os.access()` in Python) korrekt gelingt.

Konsequenz für die eigene Testautomatisierung: ACL-abhängige Berechtigungsprüfungen sollten mit einem echten Dateivorgang (z. B. `mktemp` + `rm` im Zielverzeichnis) statt mit `test -w` geprüft werden. Details siehe [troubleshooting.md](troubleshooting.md).

## Isolation zwischen Abteilungen

Verifiziert wurde u. a.:

- Vertrieb kann in den eigenen Ordner schreiben, aber nicht in Buchhaltung lesen/schreiben.
- Ein zweiter, fachfremder Mitarbeiter kann keine fremden Abteilungsordner lesen.
- `/company/public` ist für alle Mitarbeiter zugänglich, aber nicht anonym.
- `/backup/company` ist für normale Mitarbeiter vollständig unzugänglich (`700`, `root:root`).

Details zu den zugehörigen Testfällen: [testing.md](testing.md).
