# 🖥️ IHK Linux Sysadmin Lab — Unternehmensserver-Verwaltung

[![Status](https://img.shields.io/badge/Status-Abgeschlossen-brightgreen.svg)]()
[![Linux](https://img.shields.io/badge/Linux-Ubuntu-orange.svg)](https://ubuntu.com/)
[![Bash](https://img.shields.io/badge/Bash-Automatisierung-brightgreen.svg)](https://www.gnu.org/software/bash/)
[![Python](https://img.shields.io/badge/Python-Testing-blue.svg)](https://www.python.org/)
[![Certification](https://img.shields.io/badge/Kontext-IHK--Weiterbildung-gold.svg)]()
[![Version](https://img.shields.io/badge/Version-v1.0-blue.svg)]()

> 🚀 Ein **umfassendes Linux-Systemadministrations-Projekt** zur praktischen Umsetzung realistischer Serveraufgaben: CSV-gesteuerte Benutzerverwaltung, POSIX-ACL-Rechtekonzepte, SSH-Härtung, automatisierte Backups, Cron-Jobs, strukturiertes Logging und Fehlerdiagnose. Entwickelt im Rahmen einer **IHK-Weiterbildung (Fachinformatik)**.

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
| 📸 **Evidence** | 13 reale Terminal-Screenshots + Sample-Reports zur Nachvollziehbarkeit |

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
├── 📂 skripte/                            # Bash- & Python-Administrationsskripte (29 Skripte)
│   ├── setup-users.sh                    # CSV-gesteuerte Benutzer/Gruppen
│   ├── setup-folders.sh                  # Verzeichnisse, Unix-Rechte & POSIX-ACLs
│   ├── configure-security.sh             # SSH-Härtung & UFW-Firewall
│   ├── backup-company.sh                 # Backup mit SHA-256-Checksumme
│   ├── restore-company.sh                # Restore mit Integritätsprüfung
│   ├── configure-cron.sh                 # Cronjob-Installation & Probe-Modus
│   ├── daily-admin-report.sh             # Tagesbericht für nicht-technische Leser
│   ├── run-tests.sh                      # Automatisierte Test-Suite (T01–T24)
│   ├── run-fault-tests.sh                # Kontrollierte Fehlerszenarien (F01–F08)
│   ├── validate-csv.py                   # CSV-Validierung
│   └── [weitere Skripte — siehe skripte/]
│
├── 📂 daten/                              # CSV-Testdaten & Konfiguration
│   ├── users.csv                         # Fiktive Benutzerdaten
│   ├── groups.csv                        # Abteilungsgruppen
│   └── [weitere Testdaten]
│
├── 📂 konfiguration/                      # Konfigurationsreferenz
│   ├── sshd_config_notizen.txt           # SSH-Härtungs-Notizen
│   └── company-crontab.conf              # Reale Cron-Job-Definition (5 Jobs)
│
├── 📂 tests/                              # Python unittest & Test-Suites
│   ├── test_csv.py                       # CSV-Format-Validierung
│   ├── test_console_guard.py             # Konsolen-Ausgabe-Validierung
│   └── [weitere Tests]
│
├── 📂 tools/                              # Deployment-Paketierung & Verifikation
│   ├── build-package.py                  # ZIP + MANIFEST.json-Generator
│   └── check-package.py                  # Checksummen-Verifikation
│
├── 📂 dokumentation/                      # Ausführliche Dokumentation
│   ├── architecture.md                   # Systementwurf & Netzwerkmodell
│   ├── users-and-permissions.md          # Benutzerverwaltung & ACL-Konzepte
│   ├── backup-and-restore.md             # Backup-Strategie & Wiederherstellung
│   ├── monitoring-and-cron.md            # Cron & Automatisierung
│   ├── testing.md                        # 24 dokumentierte Tests
│   ├── ADMIN_CASES.md                    # 10 praxisnahe Admin-Szenarien
│   ├── troubleshooting.md                # 3 reale Fehlerfälle mit Root-Cause
│   └── DEPLOYMENT.md                     # Inbetriebnahme-Runbook (Batches 0–7)
│
└── 📂 evidence/                           # Nachweise & Screenshots
    ├── README.md                         # Evidence-Übersicht
    ├── AP03_03_ssh_login_success.png    # SSH-Login-Beweis
    ├── AP04_01_deploy_users_folders.png # Benutzer/Gruppen-Verwaltung
    ├── [weitere Screenshots — 13 insgesamt]
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
- ✅ **Bash-Scripting** — Modulare Skripte mit Error-Handling, Root-Guard und Reversibilität
- ✅ **Python-Integration** — Deployment-Verifikation, Unit-Tests, CSV-Validierung
- ✅ **Cron-Automatisierung** — 5 Jobs mit strukturiertem Logging und Verifikation
- ✅ **Konfigurationsmanagement** — Zentrale Konfigurationsdatei, Drop-in-Verzeichnisse

### Testing & Qualitätssicherung
- ✅ **Automatisierte Tests** — 24 Testfälle, Fehlerinjection, Nachverifizierung
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

### 1️⃣ Benutzer- & Gruppenverwaltung (`setup-users.sh`)

**Ziel:** CSV-gesteuerte, idempotente Verwaltung von Benutzern und Gruppen

**Features:**
- 📋 Einlesen von `users.csv` und `groups.csv`
- ✅ Validierung (Duplikate, ungültige Zeichen)
- 🔄 Idempotenz — Reruns erzeugen keine Fehler
- 📂 Automatische Verzeichnis-Erstellung pro Abteilung
- 🔐 Keine Standard-Passwörter, kein `sudo` für reguläre Mitarbeiter

**Siehe:** [dokumentation/users-and-permissions.md](dokumentation/users-and-permissions.md)

---

### 2️⃣ Dateisystemrechte & ACLs (`setup-folders.sh`)

**Ziel:** Abteilungsbasierte Isolation mit POSIX-ACLs

**Features:**
- 🔐 Unix-Standardrechte für Verzeichnisse
- 🏢 `setgid`-Vererbung für Abteilungsordner
- ✅ POSIX-ACL-Setzung für granulare Zugriffskontrolle
- 🧪 Automatisierte Isolationstests (Dateien zwischen Abteilungen prüfen)
- 🐛 Root-Cause-Analyse eines real aufgetretenen ACL-Testfehlers

**Siehe:** [dokumentation/users-and-permissions.md](dokumentation/users-and-permissions.md)

---

### 3️⃣ SSH-Sicherheit & Firewall (`configure-security.sh`)

**Ziel:** Härtung des SSH-Zugangs für sichere Administration

**Features:**
- 🔑 ED25519-Public-Key-Installation für administrative Zugänge
- 🚫 `PermitRootLogin no` — Root-Direktlogin deaktiviert
- 🔒 Passwort-Login für nicht-administrative Benutzer (optional)
- 🛡️ UFW-Firewall mit SSH-Port-Freigabe
- 🔧 Drop-in-Konfiguration (`/etc/ssh/sshd_config.d/`) statt Hauptkonfiguration-Editieren

**Siehe:** [konfiguration/sshd_config_notizen.txt](konfiguration/sshd_config_notizen.txt)

---

### 4️⃣ Backup & Restore (`backup-company.sh`, `restore-company.sh`)

**Ziel:** Zuverlässige, verifizierbare Backup-Strategie

**Features:**
- 📦 `tar.gz`-Komprimierung mit SHA-256-Checksumme
- 🔄 Atomare Veröffentlichung (Staging → Live)
- 📅 7-Tage-Retention mit automatischer Bereinigung
- ✅ Restore-Test nach jedem Backup
- 🚨 Fehlerbehandlung bei fehlenden Zielordnern

**Siehe:** [dokumentation/backup-and-restore.md](dokumentation/backup-and-restore.md)

---

### 5️⃣ Cron-Automatisierung & Monitoring (`configure-cron.sh`, `daily-admin-report.sh`)

**Ziel:** Automatisierung von Routine-Aufgaben mit strukturiertem Reporting

**5 Cronjobs** (siehe [konfiguration/company-crontab.conf](konfiguration/company-crontab.conf)):
1. **Backup, täglich 17:00 Uhr** — `backup-company.sh`
2. **Tagesbericht, täglich 16:30 Uhr** — `daily-admin-report.sh`
3. **Disk-Check, stündlich** — `check-disk.sh`
4. **Log-Report, wöchentlich (Fr. 18:00 Uhr)** — `log-report.sh`, SSH-/Cron-/UFW-Status
5. **Cleanup alter Dateien, wöchentlich (Fr. 19:00 Uhr)** — `cleanup-old-files.sh`, Retention-Bereinigung

Alle Jobs laufen über den zentralen Wrapper `cron-runner.sh`. Zur Verifikation existiert ein reversibler **Probe-Modus** (`configure-cron.sh probe` / `remove-probe`), der alle 5 Jobs vorübergehend auf minütliche Ausführung umstellt und real per `journalctl` abgleicht.

**Features:**
- 📝 Strukturiertes Logging unter `/var/log/company-admin/`
- 📊 Tagesbericht für nicht-technische Leser (CFO, IT-Manager)
- 🔍 Real-time Cron-Journal-Verifikation (`journalctl`)
- 🧪 Probe-Modus zur kontrollierten Verifikation

**Siehe:** [dokumentation/monitoring-and-cron.md](dokumentation/monitoring-and-cron.md)

---

### 6️⃣ Testing & Fehlerszenarien (`run-tests.sh`, `run-fault-tests.sh`)

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

**Sicherheits-Details:** [dokumentation/users-and-permissions.md](dokumentation/users-and-permissions.md), [konfiguration/sshd_config_notizen.txt](konfiguration/sshd_config_notizen.txt)

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

### 4. Einzelne Skripte prüfen

```bash
# Syntax-Check ohne Ausführung
bash -n skripte/setup-users.sh

# Read-only Preflight (keine Systemänderung)
bash skripte/vm-run.sh preflight
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
# Funktionale Tests (T02–T09a, T11–T23), real auf der VM — Kernlauf von 24 Tests gesamt
bash skripte/run-tests.sh --apply
```

T01, T10 und T24 werden gesondert real durchgeführt (externer SSH-Login, Cron-Probe, Retention-Lauf) — siehe [dokumentation/testing.md](dokumentation/testing.md).

### Fehlerszenarien & Fehlerinjection

```bash
# Kontrollierte Fehlerfälle (F01–F08), nur an der VM-Konsole
bash skripte/run-fault-tests.sh --apply --snapshot-confirmed
```

### Admin-Szenarien

```bash
# Praxisnahe Admin-Fälle (AF01–AF10), z.B. neuer Mitarbeiter, Restore-Test
bash skripte/run-business-cases.sh --apply --snapshot-confirmed
```

### Cron-Verifikation (Probe-Modus)

```bash
# Alle 5 Jobs vorübergehend auf minütliche Ausführung umstellen
sudo bash skripte/configure-cron.sh probe

# Nach 2–3 Minuten realer Wartezeit: Journal prüfen
sudo journalctl | grep company-admin

# Probe wieder entfernen
sudo bash skripte/configure-cron.sh remove-probe
```

---

## 📊 Dokumentation

| Dokument | Inhalt |
|----------|--------|
| [architecture.md](dokumentation/architecture.md) | Systementwurf, Verzeichnisstruktur, Netzwerkmodell |
| [users-and-permissions.md](dokumentation/users-and-permissions.md) | Benutzerverwaltung, ACL-Konzepte, real aufgetretener Fehler & Root-Cause |
| [users-and-permissions.md](dokumentation/users-and-permissions.md) | Benutzerverwaltung, ACL-Konzepte, SSH-Härtung, Public-Key-Auth |
| [backup-and-restore.md](dokumentation/backup-and-restore.md) | Backup-Strategie, Restore-Prozess, Retention-Policy |
| [monitoring-and-cron.md](dokumentation/monitoring-and-cron.md) | 5 Cronjobs, Logging, Tagesbericht |
| [testing.md](dokumentation/testing.md) | 24 automatisierte Tests mit Ergebnissen |
| [ADMIN_CASES.md](dokumentation/ADMIN_CASES.md) | 10 praxisnahe Admin-Szenarien |
| [troubleshooting.md](dokumentation/troubleshooting.md) | 3 reale Fehlerfälle mit Diagnose & Behebung |
| [DEPLOYMENT.md](dokumentation/DEPLOYMENT.md) | Inbetriebnahme-Runbook (Batches 0–7) mit Snapshot-Absicherung |

---

## 🐛 Fehlerszenarien & Troubleshooting

Dieses Projekt dokumentiert **real aufgetretene Fehler** — nicht nur Idealfälle:

### Beispiel: ACL-Testfehler (T18)

**Problem:** `test -w /company/accounting` meldete für den Benutzer `it.admin` **FAIL** ("nicht schreibbar"), obwohl ein echter Schreibvorgang (`touch`) klaglos gelang — ein False-Negative.

**Root-Cause:** `it.admin` erhält sein Schreibrecht ausschließlich über eine POSIX-ACL (nicht über die traditionelle Gruppenzugehörigkeit). Das Kommando `test -w` wertet aber nur die klassischen Unix-Rechtebits aus, nicht die ACL — der Fehler lag im Testwerkzeug, nicht in der ACL-Konfiguration.

**Lösung:** Die Testzeile wurde auf einen echten, ACL-bewussten Schreibversuch umgestellt (`mktemp` im Zielverzeichnis statt `test -w`).

**Screenshot:** [evidence/screenshots/AP11_03_t18_diagnostic_acl_root_cause.png](evidence/screenshots/AP11_03_t18_diagnostic_acl_root_cause.png)

---

### 8 Kontrollierte Fehlerszenarien (F01–F08)

| Code | Fehler | Prüfung |
|------|--------|---------|
| **F01** | Fehlende Ordnerrechte | Abteilungsordner ohne `setgid` |
| **F02** | SSH-Dienst-Ausfall | `sshd` wird gestoppt, Key-Login schlägt fehl |
| **F03** | Cronjob-Fehler | Falscher Skriptpfad in crontab |
| **F04** | Backup-Zielordner fehlt | Backup-Skript stoppt ohne Zielordner |
| **F05** | Fehlende Gruppe | Benutzer kann nicht zu Gruppe hinzugefügt werden |
| **F06** | Skript ohne `sudo` ausgeführt | Root-Guard verhindert Ausführung |
| **F07** | Fehlerhafte CSV-Zeile | Validierung (`validate-csv.py`) schlägt kontrolliert fehl |
| **F08** | Backup-Verzeichnis zu offen (`755`) | Fault-Test, Rechte auf `700` zurückgesetzt |

Alle Fehler werden nach dem Test automatisch zurückgesetzt (`trap ... EXIT`).

**Siehe:** [dokumentation/troubleshooting.md](dokumentation/troubleshooting.md)

---

## 📦 Deployment & Nutzung

### Reproduzierbares ZIP-Paket

```bash
# ZIP-Paket mit MANIFEST.json-Checksummen erstellen
python3 tools/build-package.py
```

### Verifikation

```bash
# Checksummen-Verifikation vor Einsatz
python3 tools/check-package.py
# oder auf der Ziel-VM:
python3 skripte/verify-package.py
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
| 🎯 Benutzer-/Gruppenverwaltung | ✅ | `setup-users.sh` |
| 🔐 Dateisystemrechte & ACLs | ✅ | `setup-folders.sh` |
| 🔑 SSH-Sicherheit | ✅ | `configure-security.sh` + Konfiguration |
| 💾 Backup/Restore | ✅ | `backup-company.sh` + `restore-company.sh` |
| ⏰ Cron-Automatisierung | ✅ | `configure-cron.sh` + 5 Jobs |
| 📝 Strukturiertes Logging | ✅ | `/var/log/company-admin/` |
| 🧪 24 automatisierte Tests | ✅ | `run-tests.sh` |
| 🐛 8 Fehlerszenarien | ✅ | F01–F08 mit Diagnosetests |
| 📋 10 Admin-Szenarien | ✅ | [ADMIN_CASES.md](dokumentation/ADMIN_CASES.md) |
| 📸 13 Evidence-Screenshots | ✅ | [evidence/](evidence/) |
| 📦 Reproduzierbares ZIP-Paket | ✅ | `tools/build-package.py` + `tools/check-package.py` |
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
✅ Bash-Skripting (modulare, robuste Skripte mit Error-Handling)  
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
**✅ Status:** Abgeschlossen (im Rahmen der IHK-Weiterbildung)  
**🏷️ Version:** v1.0  
**🎓 Projekt-Typ:** Eigenständiges Abschlussprojekt im Rahmen einer IHK-Weiterbildung (Fachinformatik)  
**📚 Dokumentation:** Umfassend (8 Markdown-Dateien + 13 Screenshots)  

**Entwickler:** [@harry0203vn](https://github.com/harry0203vn)

---

### 🔗 Weitere Links

- 📖 [Vollständige Architektur-Dokumentation](dokumentation/architecture.md)
- 🧪 [Test-Ergebnisse & Fehlerszenarien](dokumentation/testing.md)
- 📸 [Evidence & Real-World Screenshots](evidence/README.md)
- 🚀 [Deployment-Runbook](dokumentation/DEPLOYMENT.md)
- 🐛 [Troubleshooting & Root-Cause-Analyse](dokumentation/troubleshooting.md)

---

> **Hinweis:** Dieses Projekt ist ein **Lab & Portfolio-Demonstrator**, nicht für Produktiveinsatz gedacht. Alle Benutzer- und Firmendaten sind fiktiv. Keine privaten Schlüssel, Passwörter oder produktiven Zugangsdaten sind enthalten.

**[⬆ Nach oben](#-ihk-linux-sysadmin-lab--unternehmensserver-verwaltung)**

</div>
