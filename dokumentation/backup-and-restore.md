# Backup und Restore

## Backup

`backup-company.sh` sichert `/company` nach `/backup/company` als zeitgestempeltes `tar.gz`-Archiv inklusive ACLs und numerischer Eigentümer-IDs:

- Das Archiv wird zunächst als `.partial`-Datei geschrieben, geprüft und **erst danach** unter dem endgültigen Namen veröffentlicht — ein abgebrochener Lauf hinterlässt kein scheinbar gültiges, aber unvollständiges Archiv.
- Ein SHA-256-Hash wird für die spätere Integritätsprüfung erzeugt.
- Retention: Archive älter als 7 Tage werden anhand der `mtime` entfernt — ausschließlich Dateien, die dem festen Projekt-Namensmuster im festen Backup-Ordner entsprechen (kein pauschales Aufräumen fremder Dateien).

## Restore

`restore-company.sh`:

- verlangt ein lokales Projektarchiv und prüft dessen Hash,
- akzeptiert ausschließlich reguläre Einzeldateien als Restore-Ziel,
- lehnt Symlinks, Pfad-Traversal (`../`) und bereits existierende Zielpfade ab, um ein unbeabsichtigtes Überschreiben des gesamten Datenbestands zu verhindern.

## Verifikation

Der zugehörige Testlauf (`run-tests.sh`) erzeugt eine eigene Testdatei, sichert sie per Backup, löscht **ausschließlich diese** Datei und prüft die per Restore wiederhergestellten Bytes mittels SHA-256-Vergleich gegen das Original. Erst ein erfolgreicher Restore-Test belegt die tatsächliche Wiederherstellbarkeit — ein ungetestetes Backup allein vermittelt nur scheinbare Sicherheit.

## Bewusste Lab-Grenze

Backup und Archiv liegen auf derselben VM wie die Quelldaten. Das ist für ein Lab/Lernprojekt eine bewusst einfache Lösung. Für echte, unabhängige Ausfallsicherheit in einem Produktivbetrieb wären zusätzlich externe Kopien (z. B. Offsite-Storage) und regelmäßige, unabhängig durchgeführte Wiederherstellungsübungen erforderlich — das ist hier nicht Teil des Lab-Umfangs.
