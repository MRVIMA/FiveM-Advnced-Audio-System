# 🔊 VØIDVIMA Advanced Audio System (QBX Edition)

![Version](https://img.shields.io/badge/version-3.0.0-purple?style=for-the-badge)
![Framework](https://img.shields.io/badge/Framework-QBX%20%2F%20QBCore-blue?style=for-the-badge)
![UI](https://img.shields.io/badge/UI-Glassmorphism%20React-cyan?style=for-the-badge)

An ultra-high-fidelity vehicle audio replacement for FiveM, engineered for performance and immersion. Created by **VØIDVIMA** (Vimukthi Hewage), this system replaces the standard GTA V radio with a modern, spatial-audio-driven interface capable of streaming live music and YouTube URLs directly into your vehicle's trunk.

---

## ✨ Key Features

* **💎 Glassmorphism UI:** A sleek, modern tablet interface (F2) for managing your audio streams.
* **🔊 Spatial 3D Audio:** Integrated with `xsound` for realistic 1:1 3D positioning. Music fades as you walk away from the car.
* **🛠️ Tiered Upgrades:** Three distinct levels of hardware (Standard, Premium, Ultimate) with varying volume and distance limits.
* **📦 Physical Props:** 3D Subwoofers and Amplifiers physically spawn and attach to the vehicle's trunk bone upon installation.
* **👁️ ox_target Integration:** Interact directly with the vehicle's trunk to "Open Audio Interface" and see your physical setup.
* **🔋 Battery & Physics:** "Ultimate" tier features dynamic screen-shake and license plate rattle based on vehicle speed and bass levels.
* **💾 Persistent Database:** Vehicle upgrades are tied to the license plate and saved via `oxmysql`, surviving server restarts.

---

## 🚀 Technical Stack

* **Core:** [QBX Core](https://github.com/QBX-Net/qbx_core)
* **Database:** `oxmysql` (Scalar Await / Modern Queries)
* **Inventory:** `ox_inventory` (Metadata-ready)
* **UI/Interaction:** `ox_lib` (Progress Bars, Notifications, Context Menus) & `ox_target`
* **Audio Engine:** `xsound` (YouTube/URL API)

---

## 🛠️ Installation

1.  **Database:** Run the provided `audio_tiers.sql` or execute this query:
    ```sql
    CREATE TABLE IF NOT EXISTS `vehicle_audio_tiers` (
      `plate` VARCHAR(50) NOT NULL,
      `tier` VARCHAR(50) NOT NULL,
      PRIMARY KEY (`plate`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ```

2.  **Items:** Add the following to your `ox_inventory/data/items.lua`:
    * `audio_standard`
    * `audio_premium`
    * `audio_ultimate`

3.  **Dependencies:** Ensure these are started in order in your `server.cfg`:
    ```text
    ensure ox_lib
    ensure qbx_core
    ensure ox_inventory
    ensure xsound
    ensure vima_audio
    ```

---

## 🎮 Controls

* **F2:** Open/Close Audio Tablet (Only in upgraded vehicles).
* **LALT (Third-Eye):** Interact with the trunk of an upgraded car to view speakers.
* **Commands:** * `/tp -346.3 -133.3 39.0` - Teleport to the LSC Audio Shop NPC.

---

## 👨‍💻 Author

**Vimukthi Hewage (VØIDVIMA)**
* Software Engineering Student @ Cardiff Metropolitan University
* Music Producer & Sound Master

---

### 📝 License
This project is for private use. Unauthorized redistribution or "leaking" of the VØIDVIMA proprietary UI/Logic is strictly prohibited.
