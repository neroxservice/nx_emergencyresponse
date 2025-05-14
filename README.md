# 🚑 nx_EmergencyResponse

**`nx_EmergencyResponse`** ist ein leistungsstarkes, immersives und vollständig dynamisches Sanitäter-Jobscript für FiveM-Server, das sowohl Gameplay als auch Serververwaltung auf ein neues Level hebt.  
Es simuliert automatisierte Notrufe mit zufälligen Wartezeiten, sorgt für ein realistisches Einsatzgefühl und enthält moderne Entwickler-Tools wie automatische Versionserkennung.

---

## ✨ Features

### 🎯 Dynamische Einsätze
- Zufällige Generierung von Notrufen (zwischen **20 Minuten und 2 Stunden**).
- Log-Ausgabe in **Minuten und Stunden** für bessere Planbarkeit.
- Automatischer Check, ob ein Sanitäter (Job: `ambulance`) **im Dienst** ist – andernfalls wird kein Einsatz gestartet.
- EmergencyDispatch Integration für die Dispatches.

### 🧠 Intelligente Ressourcensteuerung
- Einsätze werden **nur dann** gestartet, wenn der Server vollständig geladen und bereit ist.
- Ressourcen- und Performance-schonend durch `CreateThread` mit dynamischem `Wait`.

### 🔔 Automatischer Update-Checker (GitHub API)
- Prüft bei Serverstart die aktuelle Version deines Scripts.
- Gibt aus:
  - ✅ Ob du die **neueste Version** nutzt.
  - ⚠️ Ob eine **neuere Version verfügbar** ist.
  - 📋 **Changelog** aus dem GitHub Release.
- Farbliche Konsolen-Ausgabe mit ANSI-Farben (Grün, Gelb, Cyan, **Rot** bei Fehlern).

### 📦 Kompatibilität mit folgenden Frameworks
- Unterstützung für [**QBCore**](https://github.com/qbcore-framework/qb-core)
- [**QB-Target**](https://github.com/qbcore-framework/qb-target/tree/main) für Interaktionen
- [**EmergencyDispatch**](https://shop.loverp-scripts.de/package/4887641) `Anforderung - Anpassbar mit bisschen Coding Verstädnis`

## 🤝 Mitwirken
- Pull Requests, Issues oder Funktionsvorschläge sind herzlich willkommen.
- Hinterlasse ein ⭐ auf GitHub, wenn dir das Projekt gefällt.
---

## 🔧 Konfiguration

```lua
-- config.lua
Config.SpawnInterval = 2700000 -- DEAKTIVIERT! Wird nun automatisch durch Random Timer ersetzt.

