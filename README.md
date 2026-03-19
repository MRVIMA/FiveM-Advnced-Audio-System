<div align="center">
  <img src="https://img.shields.io/badge/Version-2.2.0-blueviolet?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Framework-QBCore-blue?style=for-the-badge&logo=lua" />
  <img src="https://img.shields.io/badge/FiveM-VØIDVIMA_Audio-orange?style=for-the-badge&logo=gtav" />
  
  <h1 align="center">🔊 VØIDVIMA Advanced Audio System</h1>
  <p align="center">
    <strong>A professional-grade, vehicle-bound spatial audio and mechanic upgrade framework for FiveM Roleplay.</strong>
  </p>
</div>

---

## 🎭 Project Overview
The VØIDVIMA Audio System is a premium vehicle enhancement suite designed for immersive roleplay servers. Moving beyond simple client-side scripts, version 2.2.0 fully integrates with **QBCore** and mechanic scripts (like `jim-mechanic`). Audio systems are now physical items installed into vehicles, tied persistently to license plates via SQL, and controlled through a high-fidelity, glassmorphism UI.

### 🚀 Key Features
* **🔧 Mechanic Integration**: Systems are installed via usable inventory items complete with progress bars, animations, and trunk-access requirements.
* **🚗 Vehicle-Bound Logic**: Audio tiers and battery life are saved to the vehicle's license plate, meaning the system stays with the car, whoever drives it.
* **🌌 High-Fidelity NUI**: A sleek, dark-mode glassmorphism interface featuring neon accents, custom CSS audio visualizers, and real-time battery tracking.
* **🔋 Persistent Battery Management**: Dynamic power consumption that drains based on the installed tier and engine status, with background recharging mechanics.
* **✨ Physical Feedback**: Immersive screen shake and license plate rattle effects that synchronize with vehicle speed and high-end audio intensity.

---

## 📊 Audio Tier Specifications
| Tier | Item Name | Price | Max Distance | Volume | Power Drain |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Basic (Stock)** | *N/A* | $0 | 20.0m | 0.8x | 0.05 |
| **Standard** | `audio_standard` | $2,500 | 75.0m | 1.2x | 0.2 |
| **Premium** | `audio_premium` | $5,000 | 100.0m | 1.5x | 0.3 |
| **Ultimate** | `audio_ultimate` | $10,000 | 150.0m | 2.0x | 0.4 |

---

## 🛠️ Technical Implementation
The system utilizes a specialized damping formula to handle physical vehicle feedback during intense audio playback at high speeds:
$$v_{new} = v_{current} \times 0.9$$

### **Installation**
1.  **Framework Dependencies**: Ensure you are running `qb-core`. 
2.  **Database**: Run the provided `audio_tiers.sql` to generate the license-plate tracking table.
3.  **Items**: Add the items from the README configuration into your `qb-core/shared/items.lua`.
4.  **Configuration**: Adjust prices, battery drain, and screen shake intensity in `config.lua` to fit your server's economy.
5.  **Deployment**: Ensure the resource folder is named `vima_audio` and add `ensure vima_audio` to your `server.cfg`.

---

<div align="center">
  <h3>👨‍💻 About the Developer</h3>
  <p><strong>VØIDVIMA (MR. Vima)</strong> | Software Engineering Student</p>
  <p>Cardiff Metropolitan University</p>
  <p>
    <a href="https://discord.gg/XF7fYtZK"><img src="https://img.shields.io/badge/Discord-100000?style=for-the-badge&logo=discord&logoColor=white" /></a>
  </p>
</div>
