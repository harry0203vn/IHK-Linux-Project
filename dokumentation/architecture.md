# Architektur und Systementwurf

## Szenario

Das Lab simuliert den Aufbau eines kleinen Firmenservers für die fiktive **XYZ GmbH**. Das Unternehmen hat mehrere Abteilungen (IT, Vertrieb, Buchhaltung, Management) ohne zentrale, saubere Serverstruktur: Dateien liegen unübersichtlich verteilt, Berechtigungen sind nicht konsequent geregelt, Backups werden nicht zuverlässig geprüft, tägliche Admin-Berichte fehlen. Aufgabe: Aufbau eines Ubuntu-Firmenservers, auf dem zentrale Administrationsaufgaben nachvollziehbar, wiederholbar und teilweise automatisiert ablaufen.

## Systemumgebung

- Ziel-Hostname: `server01`
- Administrationskonto: `admin` (eigenes sudo-Passwort, kein root-SSH-Login)
- Virtualisierung: VMware Workstation, Ubuntu (Desktop-Variante)
- Ressourcen: mind. 2 GB RAM / 25 GB Disk gefordert; in der ausgeführten Umgebung real verfügbar: ca. 7–8 GB RAM, 25 GB Disk
- Verwaltung: per SSH von einem Windows-Administrationsclient aus

## Server-Verzeichnisstruktur

| Pfad | Zweck |
|---|---|
| `/company` | Wurzel der Abteilungsordner |
| `/opt/company/scripts` | Installierte Administrationsskripte |
| `/opt/company/data` | CSV-Datenquellen (Benutzer/Gruppen) |
| `/var/log/company-admin` | Log-Dateien der Administrationsskripte |
| `/backup/company` | Backup-Archive |

## Netzwerk

Bevorzugt: Netzwerkbrücke (Bridged Networking). Fällt diese in der jeweiligen Umgebung aus, ist NAT mit Portweiterleitung (z. B. Port 2222) als Alternative vorgesehen. Die tatsächliche Variante wird anhand eines Preflight-Checks vor der Konfiguration bestätigt, um bestehende Netzwerkeinstellungen nicht blind zu überschreiben.

## Ablaufmodell

Das Vorgehen folgt durchgängig dem Muster:

```
Planung → Implementierung (Bash/Python) → Ausführung auf der VM
        → Evidence-Sammlung (Logs/Screenshots) → Verifikation → Dokumentation
```

Jedes Administrationsskript ist idempotent bzw. sicher wiederholbar ausgelegt (siehe [testing.md](testing.md)), nutzt absolute Pfade und ein festes `PATH`, und bricht bei unbekannten Argumenten oder Konflikten kontrolliert ab statt unklare Zustände zu erzeugen.

## Komponentenübersicht

```
┌─────────────────────────┐        SSH (Public-Key)       ┌──────────────────────────────┐
│   Windows Admin-Client   │ ─────────────────────────────▶│   Ubuntu-Server (server01)    │
│   (SSH-Client, Git)      │                                │                                │
└─────────────────────────┘                                │  /opt/company/scripts/  *.sh  │
                                                             │  /company/{it,sales,...}      │
                                                             │  /backup/company               │
                                                             │  cron (5 Jobs) → Logs          │
                                                             │  UFW + sshd (Härtung)          │
                                                             └──────────────────────────────┘
```

Details zu den einzelnen Bereichen: [users-and-permissions.md](users-and-permissions.md), [backup-and-restore.md](backup-and-restore.md), [monitoring-and-cron.md](monitoring-and-cron.md), [DEPLOYMENT.md](DEPLOYMENT.md).
