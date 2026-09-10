# Troubleshooting — ausgewählte reale Fehlerfälle

Dieses Lab enthält bewusst nicht nur "alles funktioniert"-Ergebnisse, sondern dokumentiert reale, während der Umsetzung aufgetretene Fehler mitsamt Root-Cause-Analyse und Korrektur. Die folgenden drei Fälle sind exemplarisch ausgewählt.

## 1. ACL-Rechte werden von `test -w` nicht erkannt (False-Negative)

**Symptom:** Ein automatisierter Test prüfte, ob der Benutzer `it.admin` (nur über eine POSIX-ACL, nicht über die traditionelle Gruppenzugehörigkeit) in `/company/accounting` schreiben darf. Die Prüfzeile `runuser -u it.admin -- test -w /company/accounting` lieferte reproduzierbar `FAIL`, obwohl ein echter Schreibvorgang (`touch`) klaglos gelang.

**Analyse:**
```bash
id it.admin                      # Benutzer korrekt in Gruppe "it"
getfacl /company/accounting      # ACL korrekt: group:it:rwx, mask::rwx
sudo runuser -u it.admin -- test -w /company/accounting; echo $?   # -> 1 (FAIL)
sudo runuser -u it.admin -- touch /company/accounting/it-test.tmp  # -> gelingt real
python3 -c "import os; print(os.access('/company/accounting', os.W_OK))"  # -> True
```

**Root Cause:** Das Kommando `test -w` (Systemaufruf `access()`/`euidaccess()`) wertet in diesem Fall ausschließlich die klassischen Unix-Rechtebits aus, nicht die POSIX-ACL. Da `it.admin` sein Schreibrecht *ausschließlich* über den ACL-Eintrag erhält (nicht über die traditionelle Gruppenzugehörigkeit), liefert `test -w` ein False-Negative. Der Fehler lag also im **Testwerkzeug**, nicht in der ACL-Konfiguration selbst.

**Korrektur:** Die Testzeile wurde von `test -w` auf einen echten, ACL-bewussten Dateivorgang umgestellt:
```bash
runuser -u it.admin -- bash -c 'f=$(mktemp /company/accounting/.it-acl-probe-XXXXXX) && rm -f "$f"'
```

**Erkenntnis:** Shell-Testkommandos wie `test -w` prüfen zuverlässig nur traditionelle Unix-Rechtebits. Für ACL-abhängige Berechtigungsprüfungen ist ein echter Schreibversuch (oder `os.access()` in Python) erforderlich.

## 2. `journalctl`-Filter erkennt modernen OpenSSH-Prozessnamen nicht

**Symptom:** Ein Testlauf erzeugte absichtlich einen fehlgeschlagenen lokalen SSH-Login, um die Auswertung fehlgeschlagener Logins zu verifizieren. Der reale Log-Eintrag existierte in `/var/log/auth.log`, wurde aber vom `journalctl`-Filter nicht gefunden.

**Analyse:**
```bash
sudo journalctl _COMM=sshd             # -> "No entries"
sudo journalctl _COMM=sshd-session     # -> Eintrag gefunden
```

**Root Cause:** Moderne OpenSSH-Versionen unter Ubuntu trennen den lauschenden Prozess (`sshd`) vom Verbindungs-Handler (`sshd-session`, re-exec pro Verbindung). "Invalid user"-Meldungen stammen vom Kindprozess, nicht vom Elternprozess.

**Korrektur:**
```bash
# vorher
journalctl --since "$since" _COMM=sshd --no-pager
# nachher (journalctl verknüpft mehrere Werte desselben Feldes mit ODER)
journalctl --since "$since" _COMM=sshd _COMM=sshd-session --no-pager
```

**Erkenntnis:** `journalctl`-Feldfilter müssen gegen den tatsächlichen Prozessnamen der installierten OpenSSH-Version geprüft werden. `auth.log` bleibt eine nützliche zweite Quelle zur Bestätigung.

## 3. Kontrollierter Cronjob-Fehler: falscher Skriptpfad

**Szenario (absichtlich herbeigeführt):** Ein isolierter, vom produktiven Cron-Block getrennter Testeintrag zeigte auf ein nicht existierendes Skript.

**Beobachtung:** Nach realer Wartezeit auf die nächste Cron-Ausführung enthielt die Ausgabedatei den echten, vom System erzeugten Fehler:
```
/bin/sh: 1: /opt/company/scripts/ihk-nonexistent.sh: not found
```

**Korrektur:** Cron-Eintrag auf das korrekte Skript (`check-disk.sh`) korrigiert.

**Nachtest:** Nach erneuter realer Wartezeit führte der korrigierte Eintrag erfolgreich aus (`OK disk=51% threshold=80%`). Der temporäre Test-Cron-Eintrag wurde per `trap ... EXIT` automatisch wieder entfernt.

**Erkenntnis:** Ein manuell gestarteter Testlauf ersetzt keinen echten Cron-Nachweis — nur die tatsächlich vom Scheduler ausgelöste Ausführung zählt als Beleg.

---

Weitere kontrollierte Fehler- und Admin-Fälle (Ordnerrechte, fehlendes Backup-Ziel, fehlende Gruppenmitgliedschaft, Skriptausführung ohne `sudo`, fehlerhafte CSV-Zeilen, zu offene Backup-Rechte) siehe [ADMIN_CASES.md](ADMIN_CASES.md).
