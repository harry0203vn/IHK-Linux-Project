# 🖥️ IHK Linux Sysadmin Lab — Unternehmensserver-Verwaltung

[![Status](https://img.shields.io/badge/Status-Abgeschlossen-brightgreen.svg)]()
[![Linux](https://img.shields.io/badge/Linux-Ubuntu-orange.svg)](https://ubuntu.com/)
[![Bash](https://img.shields.io/badge/Bash-Automatisierung-brightgreen.svg)](https://www.gnu.org/software/bash/)
[![Python](https://img.shields.io/badge/Python-Testing-blue.svg)](https://www.python.org/)
[![Certification](https://img.shields.io/badge/Zertifizierung-IHK-gold.svg)]()
[![Version](https://img.shields.io/badge/Version-v1.0-blue.svg)]()

> 🚀 Ein **umfassendes Linux-Systemadministrations-Projekt** zur praktischen Umsetzung realistischer Serveraufgaben: CSV-gesteuerte Benutzerverwaltung, POSIX-ACL-Rechtekonzepte, SSH-Härtung, automatisierte Backups, Cron-Jobs, strukturiertes Logging und Fehlerdiagnose. Entwickelt und zertifiziert im Rahmen einer **IHK-Weiterbildung (Fachinformatik)**.

---

## 📚 Inhaltsverzeichnis

- [🎯 Projektübersicht](#-projektübersicht)
- [✨ Highlights & Features](#-highlights--features)
- [🛠️ Technologie-Stack](#️-technologie-stack)
- [📁 Repository-Struktur](#-repository-struktur)
- [💡 Demonstrierte Skills](#-demonstrierte-skills)
- [📋 Hauptfunktionen & Module](#-hauptfunktionen--module)
- [🔐 Sicherheitskonzepte](#-sicherheitskonzepte)
- [🚀 Quick Start](#-quick-start)
- [🧪 Testing & Qualitätssicherung](#-testing--qualitätssicherung)
- [📊 Dokumentation](#-dokumentation)
- [🐛 Fehlerszenarien & Troubleshooting](#-fehlerszenarien--troubleshooting)
- [📦 Deployment & Nutzung](#-deployment--nutzung)
- [✅ Projekt-Checkliste](#-projekt-checkliste)
- [🎓 Lernziele & Takeaways](#-lernziele--takeaways)

---

## 🎯 Projektübersicht

### Was ist dieses Projekt?

Dieses Lab simuliert den **Aufbau und Betrieb eines realistischen Firmenservers** unter Ubuntu. Im Gegensatz zu theoretischen Schulungsszenarien arbeitet dieses Projekt mit **echten Systemänderungen, dokumentierten Fehlern und nachprüfbaren Nachweisen** — nicht mit Annahmen oder Screenshots von dritter Hand.

Das Projekt wurde **eigenständig im Rahmen einer IHK-Weiterbildung umgesetzt** und später als öffentliches Portfolio bereinigt und veröffentlicht.

### 🎯 Kernziele

✅ **Praktische Systemadministration** — Reale Aufgaben in sicherer Laborumgebung automatisieren  
✅ **Automatisierung statt Manuelles** — Repetitive Aufgaben durch Bash/Python-Skripte ersetzen  
✅ **Nachvollziehbare Verifikation** — Jeder Test erzeugt echte, prüfbare Artefakte (nicht nur angenommene Ergebnisse)  
✅ **Fehleranalyse & Lernprozess** — Reale Fehler dokumentieren, Root-Causes verstehen und beheben  

---

## ✨ Highlights & Features

| Feature | Details |
|---------|---------|
| 📊 **Benutzerverwaltung** | CSV-gesteuert, validiert, idempotent, Abteilungsbasiertes Rechtesystem |
| 🔐 **SSH & Sicherheit** | Public-Key-Only-Auth (ED25519), `PermitRootLogin no`, UFW-Firewall-Integration |
| 🔑 **Dateisystemrechte** | Unix-Standardrechte, `setgid`-Vererbung, POSIX-ACLs mit Isolationstests |
| 💾 **Backup & Restore** | `tar.gz` mit SHA-256-Integrität, 7-Tage-Retention, atomare Veröffentlichung |
| ⏰ **Automatisierung (Cron)** | 5 dokumentierte Jobs, strukturiertes Logging, Probe-Modus zur Verifikation |
| 📊 **Monitoring** | Disk-Status, Service-Health-Checks, SSH-Audit, Tagesbericht für nicht-technische Leser |
| 🧪 **Testing** | 24 automatisierte Tests + 10 Praxis-Admin-Szenarien + 8 kontrollierte Fehlerszenarien |
| 📦 **Deployment** | Reproduzierbares ZIP-Paket mit `MANIFEST.json`-Checksummen-Verifikation (Python) |
| 📸 **Evidence** | 12+ reale Terminal-Screenshots + Sample-Reports zur Nachvollziehbarkeit |

---

## 🛠️ Technologie-Stack

```
Betriebssystem:    Ubuntu (LTS)
Automatisierung:   Bash 4.x+, Python 3.x
Versionskontrolle: Git, GitHub
Testing:           Python unittest, Bash-basierte Tests
Monitoring:        systemctl, journalctl, Cron, df, du, UFW
Sicherheit:        SSH (ED25519), POSIX-ACLs, UFW Firewall
```

---

## 📁 Repository-Struktur

```
IHK-Linux-Project/
│
├── 📄 README.md                           # Diese Datei
├── 📄 .gitignore
│
├── 📂 skripte/                            # Bash- & Python-Administrationsskripte
│   ├── 00-init-system.sh                 # Systemvorbereitung
│   ├── 01-users-groups-setup.sh          # CSV-gesteuerte Benutzer/Gruppen
│   ├── 02-filesystem-permissions.sh      # Unix-Rechte & POSIX-ACLs
│   ├── 03-ssh-security.sh                # SSH-Härtung & Key-Management
│   ├── 04-backup-management.sh           # Backup/Restore mit Retention
│   ├── 05-cron-automation.sh             # Cronjob-Installation & Monitoring
│   ├── 06-logging-setup.sh               # Strukturiertes Logging
│   ├── 07-testing-framework.sh           # Test-Automatisierung
│   ├── verify_deployment.py              # ZIP-Paket-Verifikation
│   └── [weitere Hilfsskripte]
│
├── 📂 daten/                              # CSV-Testdaten & Konfiguration
│   ├── users.csv                         # Fiktive Benutzerdaten
│   ├── groups.csv                        # Abteilungsgruppen
│   └── [weitere Testdaten]
│
├── 📂 konfiguration/                      # Konfigurationsreferenz
│   ├── sshd_config_notizen.txt           # SSH-Härtungs-Notizen
│   ├── crontab_referenz.txt              # Cron-Job-Definition
│   └── [weitere Konfigurationen]
│
├── 📂 tests/                              # Python unittest & Test-Suites
│   ├── test_csv_validation.py            # CSV-Format-Validierung
│   ├── test_console_guard.py             # Konsolen-Ausgabe-Validierung
│   └── [weitere Tests]
│
├── 📂 tools/                              # Deployment-Paketierung & Verifikation
│   └── create_deployment_package.py      # ZIP + MANIFEST.json-Generator
│
├── 📂 dokumentation/                      # Ausführliche Dokumentation
│   ├── architecture.md                   # Systementwurf & Netzwerkmodell
│   ├── users-and-permissions.md          # Benutzerverwaltung & ACL-Konzepte
│   ├── ssh-and-security.md               # SSH-Härtung & Sicherheitsdetails
│   ├── backup-and-restore.md             # Backup-Strategie & Wiederherstellung
│   ├── monitoring-and-cron.md            # Cron & Automatisierung
│   ├── testing.md                        # 24 dokumentierte Tests
│   ├── ADMIN_CASES.md                    # 10 praxisnahe Admin-Szenarien
│   ├── troubleshooting.md                # 3 reale Fehlerfälle mit Root-Cause
│   └── DEPLOYMENT.md                     # Firstrun-Runbook (Batches 0–7)
│
└── 📂 evidence/                           # Nachweise & Screenshots
    ├── README.md                         # Evidence-Übersicht
    ├── AP03_03_ssh_login_success.png    # SSH-Login-Beweis
    ├── AP04_01_deploy_users_folders.png # Benutzer/Gruppen-Verwaltung
    ├── [weitere Screenshots]
    └── sample-reports/
        └── daily-admin-report-sample.txt # Beispiel-Tagesbericht
```

---

## 💡 Demonstrierte Skills

### Linux & Systemadministration
- ✅ **Benutzer-/Gruppenverwaltung** — `useradd`, `usermod`, `groupadd`, idempotente Skripte
- ✅ **Dateisystemrechte** — Unix-Rechte (`chmod`, `chown`), `setgid`-Vererbung, POSIX-ACLs (`setfacl`, `getfacl`)
- ✅ **SSH-Härtung** — Public-Key-Auth (ED25519), `sshd`-Drop-in-Konfiguration, Key-Management
- ✅ **Firewall-Verwaltung** — UFW-Regeln, Port-Freigaben vor Firewall-Aktivierung
- ✅ **Backup-Strategien** — `tar.gz`-Komprimierung, SHA-256-Checksummen, Retention-Policy

### Automatisierung & Scripting
- ✅ **Bash-Scripting** — Modulare, produktionsreife Skripte mit Error-Handling
- ✅ **Python-Integration** — Deployment-Verifikation, Unit-Tests, CSV-Validierung
- ✅ **Cron-Automatisierung** — 5 Jobs mit strukturiertem Logging und Verifikation
- ✅ **Konfigurationsmanagement** — Zentrale Konfigurationsdatei, Drop-in-Verzeichnisse

### Testing & Qualitätssicherung
- ✅ **Automatisierte Tests** — 24 Testfälle, Fehlerinjection, Nachverfizierung
- ✅ **Fehlerszenarien** — 8 kontrollierte Fehlerfälle mit Diagnose & Behebung
- ✅ **Root-Cause-Analyse** — 3 dokumentierte reale Fehlerfälle mit Lernprozess
- ✅ **Verifikations-Prozesse** — Probe-Modus, Live-Logs, Artefakt-Prüfung

### Sicherheit & Best Practices
- ✅ **Kein Hartcoding** — Zentrale Konfiguration, Parameter-Validierung
- ✅ **Root-Guard** — Privilegien-Checks am Script-Anfang
- ✅ **Sichere Pfade** — Absolute Pfade, festgelegtes `PATH`, keine Injection-Anfälligkeit
- ✅ **Reversibilität** — `trap ... EXIT`, Snapshots vor riskanten Operationen
- ✅ **Zugriffsschutz** — Keine privaten Keys, Passwörter oder realen Zugangsdaten im Repo

---

## 📋 Hauptfunktionen & Module

### 1️⃣ Benutzer- & Gruppenverwaltung (`01-users-groups-setup.sh`)

**Ziel:** CSV-gesteuerte, idempotente Verwaltung von Benutzern und Gruppen

**Features:**
- 📋 Einlesen von `users.csv` und `groups.csv`
- ✅ Validierung (Duplikate, ungültige Zeichen)
- 🔄 Idempotenz — Reruns erzeugen keine Fehler
- 📂 Automatische Verzeichnis-Erstellung pro Abteilung
- 🔐 Keine Standard-Passwörter, kein `sudo` für reguläre Mitarbeiter

**Siehe:** [dokumentation/users-and-permissions.md](dokumentation/users-and-permissions.md)

---

### 2️⃣ Dateisystemrechte & ACLs (`02-filesystem-permissions.sh`)

**Ziel:** Abteilungsbasierte Isolation mit POSIX-ACLs

**Features:**
- 🔐 Unix-Standardrechte für Verzeichnisse
- 🏢 `setgid`-Vererbung für Abteilungsordner
- ✅ POSIX-ACL-Setzung für granulare Zugriffskontrolle
- 🧪 Automatisierte Isolationstests (Dateien zwischen Abteilungen prüfen)
- 🐛 Root-Cause-Analyse eines real aufgetretenen ACL-Testfehlers

**Siehe:** [dokumentation/users-and-permissions.md](dokumentation/users-and-permissions.md)

---

### 3️⃣ SSH-Sicherheit & Firewall (`03-ssh-security.sh`)

**Ziel:** Härtung des SSH-Zugangs für sichere Administration

**Features:**
- 🔑 ED25519-Public-Key-Installation für administrative Zugänge
- 🚫 `PermitRootLogin no` — Root-Direktlogin deaktiviert
- 🔒 Passwort-Login für nicht-administrative Benutzer (optional)
- 🛡️ UFW-Firewall mit SSH-Port-Freigabe
- 🔧 Drop-in-Konfiguration (`/etc/ssh/sshd_config.d/`) statt Hauptkonfiguration-Editieren

**Siehe:** [konfiguration/sshd_config_notizen.txt](konfiguration/sshd_config_notizen.txt)

---

### 4️⃣ Backup & Restore (`04-backup-management.sh`)

**Ziel:** Zuverlässige, verifizierbare Backup-Strategie

**Features:**
- 📦 `tar.gz`-Komprimierung mit SHA-256-Checksumme
- 🔄 Atomare Veröffentlichung (Staging → Live)
- 📅 7-Tage-Retention mit automatischer Bereinigung
- ✅ Restore-Test nach jedem Backup
- 🚨 Fehlerbehandlung bei fehlenden Zielordnern

**Siehe:** [dokumentation/backup-and-restore.md](dokumentation/backup-and-restore.md)

---

### 5️⃣ Cron-Automatisierung & Monitoring (`05-cron-automation.sh`, `daily-admin-report.sh`)

**Ziel:** Automatisierung von Routine-Aufgaben mit strukturiertem Reporting

**5 Cronjobs:**
1. **Stündliches Backup** — regelmäßige Datensicherung
2. **Tägliche Retention-Bereinigung** — alte Backups entfernen
3. **Täglicher Sicherheitsbericht** — SSH-Audit, Disk-Status, Service-Health
4. **Stündliche Systemüberwachung** — Resource-Check, Log-Rotation
5. **Probe-Modus** (optional) — minütliche Verifikation aller Skripte

**Features:**
- 📝 Strukturiertes Logging unter `/var/log/company-admin/`
- 📊 Tagesbericht für nicht-technische Leser (CFO, IT-Manager)
- 🔍 Real-time Cron-Journal-Verifikation (`journalctl`)
- 🧪 Probe-Modus zur kontrollierten Verifikation

**Siehe:** [dokumentation/monitoring-and-cron.md](dokumentation/monitoring-and-cron.md)

---

### 6️⃣ Testing & Fehlerszenarien (`07-testing-framework.sh`)

**Ziel:** Umfassende Qualitätssicherung mit echten Fehlerfällen

**24 Tests + 10 Admin-Szenarien + 8 Fehlerfälle:**
- ✅ **Benutzer-Tests** — Erstellung, Änderung, Löschung
- ✅ **Permissions-Tests** — ACL-Isolation, Datei-Zugriff
- ✅ **SSH-Tests** — Key-Auth, Firewall, Dienst-Status
- ✅ **Backup-Tests** — Erstellung, Restore, Integrität
- ✅ **Fehlerszenarien** — Kontrollierte Fehlerinjektion mit Nachtest

**Siehe:** [dokumentation/testing.md](dokumentation/testing.md), [dokumentation/troubleshooting.md](dokumentation/troubleshooting.md)

---

## 🔐 Sicherheitskonzepte

### Was dieses Projekt berücksichtigt

✅ **Root-Guard** — Alle Skripte prüfen zu Anfang auf Privileges  
✅ **Absolute Pfade** — Keine Injection-Anfälligkeit durch relative Pfade  
✅ **Festes PATH** — Verhindert Man-in-the-Middle durch manipulierte `$PATH`  
✅ **Input-Validierung** — CSV-Spalten geprüft, Sonderzeichen gefiltert  
✅ **Reversibilität** — `trap ... EXIT` setzt alle Fehler-Injektionen zurück  
✅ **VM-Snapshots** — Gefährliche Tests nur nach Snapshot-Sicherung  
✅ **SSH ED25519** — Moderne Schlüsselverschlüsselung (kein RSA/DSA)  
✅ **PermitRootLogin no** — Root-Direktlogin deaktiviert  

### Was dieses Projekt NICHT ist

⚠️ **Nicht produktionsreif** — Lab-Demonstrator, nicht für Liveumgebung  
⚠️ **Backup auf gleicher VM** — Vereinfachung (produktiv: externe Speicherung)  
⚠️ **Keine Enterprise-Security-Baseline** — Zeigt Konzepte und Techniken, nicht vollständig gehärtet  
⚠️ **Passwort-Login aktiv** — Für Kompatibilität, wird aber für Admin nicht genutzt  

**Sicherheits-Details:** [dokumentation/ssh-and-security.md](dokumentation/ssh-and-security.md)

---

## 🚀 Quick Start

### Voraussetzungen

- Ubuntu LTS (20.04+) in VM oder WSL
- `sudo`-Zugriff
- Git
- Bash 4.x+, Python 3.x

### 1. Repository klonen

```bash
git clone https://github.com/harry0203vn/IHK-Linux-Project.git
cd IHK-Linux-Project
```

### 2. Ausführrechte setzen

```bash
chmod +x skripte/*.sh
chmod +x skripte/*.py
```

### 3. CSV-Testdaten prüfen

```bash
cat daten/users.csv
cat daten/groups.csv
```

### 4. Einzelne Skripte testen

```bash
# Nur "dry-run" prüfen, keine Änderungen
bash skripte/01-users-groups-setup.sh --check

# Oder auf Syntax prüfen
bash -n skripte/01-users-groups-setup.sh
```

### 5. Komplette Deployment-Sequenz (mit VM-Snapshot!)

Siehe [dokumentation/DEPLOYMENT.md](dokumentation/DEPLOYMENT.md) für das **Batch-System** (Batches 0–7):

```bash
bash dokumentation/DEPLOYMENT.md
```

---

## 🧪 Testing & Qualitätssicherung

### Automatisierte Test-Suite

```bash
# Alle Tests ausführen (21 Tests)
bash skripte/07-testing-framework.sh --run-all

# Nur spezifische Test-Kategorie
bash skripte/07-testing-framework.sh --tests users
bash skripte/07-testing-framework.sh --tests permissions
bash skripte/07-testing-framework.sh --tests backup
```

### Fehlerszenarien & Fehlerinjection

```bash
# Kontrollierte Fehlerfälle (F01–F08) mit Nachtest
bash skripte/07-testing-framework.sh --faults

# Spezifischen Fehlerfall testen
bash skripte/07-testing-framework.sh --fault F01
```

### Admin-Szenarien

```bash
# 10 praxisnahe Admin-Fälle (z.B. Benutzer hinzufügen, Backup restoren)
bash skripte/07-testing-framework.sh --admin-cases
```

### Cron-Verifikation (Probe-Modus)

```bash
# Minütliche Verifikation aller 5 Jobs installieren
bash skripte/05-cron-automation.sh --install-probe

# Live-Logs prüfen
journalctl -u company-admin-probe.service -f
```

---

## 📊 Dokumentation

| Dokument | Inhalt |
|----------|--------|
| [architecture.md](dokumentation/architecture.md) | Systementwurf, Verzeichnisstruktur, Netzwerkmodell |
| [users-and-permissions.md](dokumentation/users-and-permissions.md) | Benutzerverwaltung, ACL-Konzepte, real aufgetretener Fehler & Root-Cause |
| [ssh-and-security.md](dokumentation/ssh-and-security.md) | SSH-Härtung, Public-Key-Auth, Firewall |
| [backup-and-restore.md](dokumentation/backup-and-restore.md) | Backup-Strategie, Restore-Prozess, Retention-Policy |
| [monitoring-and-cron.md](dokumentation/monitoring-and-cron.md) | 5 Cronjobs, Logging, Tagesbericht |
| [testing.md](dokumentation/testing.md) | 24 automatisierte Tests mit Ergebnissen |
| [ADMIN_CASES.md](dokumentation/ADMIN_CASES.md) | 10 praxisnahe Admin-Szenarien |
| [troubleshooting.md](dokumentation/troubleshooting.md) | 3 reale Fehlerfälle mit Diagnose & Behebung |
| [DEPLOYMENT.md](dokumentation/DEPLOYMENT.md) | Firstrun-Runbook (Batches 0–7) mit Snapshot-Absicherung |

---

## 🐛 Fehlerszenarien & Troubleshooting

Dieses Projekt dokumentiert **real aufgetretene Fehler** — nicht nur Idealfälle:

### Beispiel: ACL-Testfehler (T18)

**Problem:** `test -w /path` meldete "schreibbar", aber `touch` schlug fehl (echte Schreibberechtigung fehlte).

**Root-Cause:** `test -w` prüft nur Linux-Sicherheitsmodell, nicht POSIX-ACLs.

**Lösung:** Auf echter Schreibversuch umstellen (`touch` → Rückgabewert prüfen).

**Screenshot:** [evidence/AP11_03_t18_diagnostic_acl_root_cause.png](evidence/AP11_03_t18_diagnostic_acl_root_cause.png)

---

### 8 Kontrollierte Fehlerszenarien (F01–F08)

| Code | Fehler | Prüfung |
|------|--------|---------|
| **F01** | Fehlende Ordnerrechte | Abteilungsordner ohne `setgid` |
| **F02** | SSH-Dienst-Ausfall | `sshd` wird gestoppt, Key-Login schlägt fehl |
| **F03** | Cronjob-Fehler | Falscher Skriptpfad in crontab |
| **F04** | Backup-Zielordner fehlt | Backup-Skript stoppt ohne Zielordner |
| **F05** | Fehlende Gruppe | Benutzer kann nicht zu Gruppe hinzugefügt werden |
| **F06** | ACL-Fehler | ACL-Regeln nicht anwendbar |
| **F07** | SSH-Key-Fehler | Public-Key nicht installiert |
| **F08** | Log-Rotation-Fehler | Logs werden nicht rotiert |

Alle Fehler werden nach dem Test automatisch zurückgesetzt (`trap ... EXIT`).

**Siehe:** [dokumentation/troubleshooting.md](dokumentation/troubleshooting.md)

---

## 📦 Deployment & Nutzung

### Reproduzierbares ZIP-Paket

```bash
# ZIP-Paket mit MANIFEST.json-Checksummen erstellen
python3 tools/create_deployment_package.py

# ZIP wird unter `deployment/` erstellt
ls -lh deployment/*.zip
```

### Verifikation

```bash
# Checksummen-Verifikation vor Einsatz
python3 skripte/verify_deployment.py deployment/ihk-linux-project-*.zip
```

### Komplette Deployment-Sequenz

Für produktiven Einsatz:

1. **Batch 0–2:** Systemeigenschaften prüfen, SSH vorbereiten
2. **Batch 3:** SSH-Sicherheit aktivieren
3. **Batch 4:** Benutzer & Gruppen erstellen
4. **Batch 5:** Dateisystemrechte & ACLs setzen
5. **Batch 6:** Backup-Infrastruktur aufbauen
6. **Batch 7:** Cron-Jobs installieren

Siehe: [dokumentation/DEPLOYMENT.md](dokumentation/DEPLOYMENT.md)

---

## ✅ Projekt-Checkliste

| Element | Status | Beweis |
|---------|--------|--------|
| 🎯 Benutzer-/Gruppenverwaltung | ✅ | `01-users-groups-setup.sh` |
| 🔐 Dateisystemrechte & ACLs | ✅ | `02-filesystem-permissions.sh` |
| 🔑 SSH-Sicherheit | ✅ | `03-ssh-security.sh` + Konfiguration |
| 💾 Backup/Restore | ✅ | `04-backup-management.sh` |
| ⏰ Cron-Automatisierung | ✅ | `05-cron-automation.sh` + 5 Jobs |
| 📝 Strukturiertes Logging | ✅ | `/var/log/company-admin/` |
| 🧪 24 automatisierte Tests | ✅ | `07-testing-framework.sh` |
| 🐛 8 Fehlerszenarien | ✅ | F01–F08 mit Diagnosetests |
| 📋 10 Admin-Szenarien | ✅ | [ADMIN_CASES.md](dokumentation/ADMIN_CASES.md) |
| 📸 12+ Evidence-Screenshots | ✅ | [evidence/](evidence/) |
| 📦 Reproduzierbares ZIP-Paket | ✅ | `tools/create_deployment_package.py` |
| ✅ Umfassende Dokumentation | ✅ | 8 Markdown-Dateien in `dokumentation/` |

---

## 🎓 Lernziele & Takeaways

Mit diesem Projekt wurden praktisch folgende Kompetenzen demonstriert:

### Linux-Systemadministration
✅ Benutzer-, Gruppen- und Rechteverwaltung  
✅ POSIX-ACLs für granulare Zugriffskontrolle  
✅ SSH-Härtung und Public-Key-Management  
✅ Firewall-Konfiguration (UFW)  
✅ Backup-, Restore- und Retention-Strategien  

### Automatisierung & Scripting
✅ Bash-Skripting (modulare, produktionsreife Skripte)  
✅ Python-Integration (Unit-Tests, Verifikation)  
✅ CSV-Datenverarbeitung & Validierung  
✅ Cron-basierte Automation mit Logging  
✅ Konfigurationsmanagement (zentrale Konfiguration, Drop-ins)  

### Qualitätssicherung & Fehlerbehandlung
✅ Automatisierte Test-Suites (24 Tests)  
✅ Kontrollierte Fehlerinjektion  
✅ Root-Cause-Analyse realer Probleme  
✅ Fehlerszenarien & Troubleshooting-Dokumentation  
✅ Verifikation & Nachprüfung (Artefakt-basiert, nicht angenommen)  

### Best Practices & Sicherheit
✅ Sichere Bash-Programmierung (Root-Guard, Paths, Input-Validierung)  
✅ Keine hartcodierten Passwörter/Keys  
✅ Reversible Operationen & Snapshot-Absicherung  
✅ Strukturiertes Logging & Monitoring  
✅ Dokumentation für verschiedene Zielgruppen (Techniker, Manager)  

---

<div align="center">

### ⭐ IHK Linux Sysadmin Lab

**📅 Entwickelt:** 2025–2026 (IHK-Weiterbildung)  
**✅ Status:** Abgeschlossen & Zertifiziert  
**🏷️ Version:** v1.0  
**🎓 Projekt-Typ:** Eigenständige IHK-Systemadministrations-Abschlussprüfung  
**📚 Dokumentation:** Umfassend (8 Markdown-Dateien + 12+ Screenshots)  

**Entwickler:** Huy Ha Hoang ([@harry0203vn](https://github.com/harry0203vn))

---

### 🔗 Weitere Links

- 📖 [Vollständige Architektur-Dokumentation](dokumentation/architecture.md)
- 🧪 [Test-Ergebnisse & Fehlerszenarien](dokumentation/testing.md)
- 📸 [Evidence & Real-World Screenshots](evidence/README.md)
- 🚀 [Deployment-Runbook](dokumentation/DEPLOYMENT.md)
- 🐛 [Troubleshooting & Root-Cause-Analyse](dokumentation/troubleshooting.md)

---

> **Hinweis:** Dieses Projekt ist ein **Lab & Portfolio-Demonstrator**, nicht für Produktiveinsatz gedacht. Alle Benutzer- und Firmendaten sind fiktiv. Keine privaten Schlüssel, Passwörter oder produktiven Zugangsdaten sind enthalten.

**[⬆ Nach oben](#-ikh-linux-sysadmin-lab--unternehmensserver-verwaltung)**

</div>
