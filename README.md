<div align="center">

# 🚑 nx_EmergencyResponse

[![Framework](https://img.shields.io/badge/framework-QBCore-0d0d1a?style=for-the-badge&logoColor=00e5ff)](#-requirements)
[![Language](https://img.shields.io/badge/language-Lua-0d0d1a?style=for-the-badge&logo=lua&logoColor=ff2d95)](#-tech-stack)
[![License](https://img.shields.io/badge/license-GPL--3.0-0d0d1a?style=for-the-badge&logoColor=b967ff)](LICENSE)
[![Release](https://img.shields.io/badge/release-v1.8.3--beta-0d0d1a?style=for-the-badge&logoColor=00e5ff)](https://github.com/neroxservice/nx_emergencyresponse/releases)

</div>

---

## 📖 About

**`nx_EmergencyResponse`** ist ein leistungsstarkes, immersives und
vollständig dynamisches Sanitäter-Jobscript für FiveM-Server, das sowohl
Gameplay als auch Serververwaltung auf ein neues Level hebt. Es simuliert
automatisierte Notrufe mit zufälligen Wartezeiten, sorgt für ein
realistisches Einsatzgefühl und bringt eine automatische Versionserkennung
für bessere Update-Mitteilungen mit.

---

## ✨ Features

### 🎯 Dynamische Einsätze
- Zufällige Generierung von Notrufen (zwischen **20 Minuten und 2 Stunden**).
- Log-Ausgabe in **Minuten und Stunden** für bessere Planbarkeit.
- Automatischer Check, ob ein Sanitäter (Job: `ambulance`) **im Dienst** ist —
  andernfalls wird kein Einsatz gestartet.
- **EmergencyDispatch**-Integration für die Dispatches.

### 🎯 Einsätze steuern
- Einsätze können auf Dauer deaktiviert werden.
- Ebenso jederzeit wieder gestartet werden.

### 🎯 Countdown
- Anzeige, wie lange der aktuelle Einsatz noch aktiv bleibt, bevor er
  deaktiviert wird.
- ✅ Der Count resettet sich korrekt.

### 🧠 Intelligente Ressourcensteuerung
- Einsätze werden **nur dann** gestartet, wenn der Server vollständig
  geladen und bereit ist.
- Ressourcen- und performance-schonend durch `CreateThread` mit dynamischem
  `Wait`.

### 🔔 Automatischer Update-Checker (GitHub API)
- Prüft bei Serverstart die aktuelle Version deines Scripts.
- Gibt aus:
  - ✅ Ob du die **neueste Version** nutzt.
  - ⚠️ Ob eine **neuere Version verfügbar** ist.
  - 📋 **Changelog** aus dem GitHub Release.
- Farbliche Konsolen-Ausgabe mit ANSI-Farben (Grün, Gelb, Cyan, **Rot** bei
  Fehlern).

### 📦 Kompatibilität

| Framework / System | Unterstützung |
|---|---|
| [QBCore](https://github.com/qbcore-framework/qb-core) | ✅ |
| [QB-Target](https://github.com/qbcore-framework/qb-target/tree/main) | ✅ (Interaktionen) |
| [EmergencyDispatch](https://shop.loverp-scripts.de/package/4887641) | ✅ Anforderung — anpassbar mit etwas Coding-Verständnis |

---

## 🛠️ Tech Stack

<div align="center">

![Lua](https://img.shields.io/badge/Lua-2B2E3A?style=flat-square&logo=lua&logoColor=00E5FF)
![QBCore](https://img.shields.io/badge/QBCore-2B2E3A?style=flat-square&logoColor=FF2D95)
![QB--Target](https://img.shields.io/badge/QB--Target-2B2E3A?style=flat-square&logoColor=BD93F9)
![GitHub API](https://img.shields.io/badge/GitHub_API-2B2E3A?style=flat-square&logo=github&logoColor=00E5FF)

</div>

- **Framework:** QBCore
- **Interaktion:** QB-Target
- **Dispatch:** EmergencyDispatch (optional, anpassbar)
- **Update-Check:** GitHub API mit Changelog-Ausgabe
- **Sprache:** 100 % Lua

---

## ⚙️ Requirements

- `qb-core`
- `qb-target`
- optional: `EmergencyDispatch`

---

## 🔧 Konfiguration

```lua
-- config.lua
Config.SpawnInterval = 2700000 -- DEAKTIVIERT! Wird nun automatisch durch Random Timer ersetzt.
Config.CommandStart = "custom name" -- Command zum Starten der Automatisierung
Config.CommandStop = "customname"   -- Command zum Stoppen der Automatisierung
```

---

## ✔️ To-Do Liste

### 🚀 Projektstart
- [x] Projekt erstellen
- [x] README gestalten

### 🎨 Frontend
- [x] Responsives Layout erstellen
- [x] Komponenten strukturieren
- [x] Kommands zum Starten und Stoppen der Automatisierung

### 🎨 Backend
- [ ] Den NPC zum Krankenhaus bringen
- [ ] NPC mit Trage transportieren

### 🧪 Tests
- [ ] Unit Tests schreiben
- [ ] E2E Tests vorbereiten

---

## 🤝 Mitwirken

- Pull Requests, Issues oder Funktionsvorschläge sind herzlich willkommen.
- Hinterlasse ein ⭐ auf GitHub, wenn dir das Projekt gefällt.

---

## 📜 License

Veröffentlicht unter der **[GPL-3.0 License](LICENSE)**.

<div align="center">

Made with ❤️ by **nxService & Streams**

</div>
