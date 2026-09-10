# Inbetriebnahme-Runbook (Batches 0–7)

Dieses Runbook beschreibt die reale Erstinbetriebnahme des Servers in sicheren, einzeln bestätigten Schritten (Batches). Jeder Batch baut auf einem vorherigen VMware-Snapshot auf; riskante Batches (Systemänderung, Sicherheits-/Firewall-Änderung, kontrollierte Fehlerszenarien) erfordern eine explizite Bestätigung, bevor sie ausgeführt werden.

## Batch 0 — Paket übertragen und Read-only-Prüfung

Das Paket `deployment/ihk-linux-deployment.zip` enthält Skripte, Testdaten, Konfiguration, Tests und Anleitung — nicht die vollständige Projektabgabe.

1. ZIP auf die VM übertragen (Shared Folder oder Datei-Transfer) und entpacken.
2. Terminal im entpackten Ordner öffnen.
3. Read-only-Preflight ausführen:

```bash
bash skripte/vm-run.sh preflight
```

Der Befehl prüft zuerst den Hash des Pakets, fragt bei Bedarf nach `sudo` und speichert die Ausgabe automatisch als Bericht (`results/preflight-....txt`). Das Skript führt **kein** `apt` aus und ändert keine Rechte, keinen Benutzer, keinen Hostnamen und keine Firewall.

## Batch 1 — Systemvorbereitung

Vor diesem Batch: VMware-Snapshot aus einem sicheren Zustand erstellen.

```bash
sudo bash skripte/install-project.sh --apply --snapshot-confirmed
```

Prüft auf Namenskonflikte, installiert/aktualisiert Pakete, legt `admin` mit `sudo` an und setzt den Hostnamen `server01`. Der Snapshot ist die Gesamt-Rollback-Option für Paket-/Account-Upgrades.

## Batch 2 — Firmenfunktionen

```bash
sudo bash /opt/company/scripts/deploy-company.sh
```

Legt Gruppen/Benutzer aus den CSV-Dateien an, richtet Ordner/Rechte ein, erstellt ein erstes Backup und einen Log-Report. Mitarbeiter-Accounts erhalten kein Standardpasswort und kein `sudo`.

## Batch 3 — SSH-Zugang vom Administrationsclient

Mit `ssh-keygen` einen projekteigenen ED25519-Schlüssel erzeugen; der private Schlüssel bleibt außerhalb von Git. **Nur** der öffentliche Schlüssel (`.pub`) wird auf die VM übertragen und mit `install-admin-key.sh` installiert:

```bash
ssh -i KEY -o PreferredAuthentications=publickey -o PasswordAuthentication=no admin@HOST
```

Der Host-Fingerprint wird vor der ersten Bestätigung mit der Konsole abgeglichen.

## Batch 4 — Sicherheit und Cron

Erst nachdem der Key-Login erfolgreich war und die Firewall-Änderung freigegeben ist:

```bash
sudo bash /opt/company/scripts/configure-security.sh --apply --snapshot-confirmed --key-login-confirmed
sudo bash /opt/company/scripts/configure-cron.sh install
```

Der aktuell gültige SSH-Port wird freigegeben, **bevor** die Firewall aktiviert wird — so wird ein Aussperren vermieden.

## Batch 5 — Verifizierung und realer Cron-Nachweis

```bash
sudo bash /opt/company/scripts/run-tests.sh --apply
sudo bash /opt/company/scripts/test-retention.sh --apply
sudo bash /opt/company/scripts/configure-cron.sh probe
```

Nach 2–3 Minuten realer Wartezeit auf die Probe-Ausführung:

```bash
sudo bash /opt/company/scripts/configure-cron.sh remove-probe
sudo tail -n 80 /var/log/company-admin/cron-execution.log
sudo crontab -l
```

Die minütliche Probe ist ein Testzeitplan — kein Nachweis, dass der wöchentliche Produktivzeitplan bereits eingetreten ist.

## Batch 6 — Kontrollierte Fehlerszenarien (gesonderte Freigabe erforderlich)

```bash
sudo bash /opt/company/scripts/run-fault-tests.sh --apply --snapshot-confirmed
sudo bash /opt/company/scripts/test-ssh-outage.sh --apply --snapshot-confirmed
sudo bash /opt/company/scripts/test-cron-failure.sh --apply
sudo bash /opt/company/scripts/test-disk-threshold.sh
sudo bash /opt/company/scripts/run-business-cases.sh --apply --snapshot-confirmed
```

Dieser Batch ändert absichtlich vorübergehend Projektrechte, unterbricht SSH kurz und erzeugt einen echten Cron-Fehler — alle Änderungen werden reversibel per `trap ... EXIT` zurückgesetzt. Der Disk-Test simuliert nur den Schwellenwert, ohne die Festplatte real zu füllen. Details siehe [ADMIN_CASES.md](ADMIN_CASES.md) und [troubleshooting.md](troubleshooting.md).

## Batch 7 — Evidence sammeln

```bash
sudo bash /opt/company/scripts/collect-evidence.sh
```

Gibt den Archivpfad unter `/var/lib/company-admin` aus. Private Schlüssel, `/etc/shadow` oder das gesamte Home-Verzeichnis werden nicht mit übertragen.

## Rollback

Bei einem Installer-/Konfigurationsfehler: Vorgang anhalten, Transcript aufbewahren, an der Konsole arbeiten. Eine Sicherung von Hostname, `/etc/hosts`, Cron sowie der SSH-/UFW-Konfiguration vor der Änderung liegt unter `/var/lib/company-admin/rollback` (nur für `root` lesbar). Der VMware-Snapshot bleibt der zuverlässigste Gesamt-Wiederherstellungsweg.
