<div align="center">
  <img src="https://img.shields.io/badge/Version-2.1.8-blueviolet?style=for-the-badge" />
  <img src="https://img.shields.io/badge/FiveM-Advanced_Audio-orange?style=for-the-badge&logo=gtav" />
  <img src="https://img.shields.io/badge/SQL-Supported-blue?style=for-the-badge&logo=mysql" />
  
  <h1 align="center">🔊 Vima Advanced Audio System</h1>
  <p align="center">
    <strong>A professional-grade spatial audio and vehicle upgrade framework for FiveM.</strong>
  </p>
</div>

---

## 🎭 Project Overview
This system is a modular vehicle enhancement suite that introduces high-fidelity spatial audio, tiered hardware upgrades, and realistic physical feedback. Built with a focus on **Software Engineering** principles, it ensures optimized performance and persistent data management via SQL.

### 🚀 Key Features
* **📡 Spatial Audio Logic**: Implements 3D sound positioning and custom trunk-specific audio effects.
* **📈 Tiered Upgrade System**: Four distinct hardware tiers (Basic, Standard, Premium, Ultimate) with unique price points and specs.
* **🔋 Battery Management**: Dynamic power consumption logic that drains or recharges based on engine status and audio load.
* **✨ Physical Feedback**: Immersive screen shake and license plate rattle effects synchronized with audio intensity.
* **🖥️ NUI Interface**: A sleek, HTML/JS media player interface for real-time control.

---

## 📊 Audio Tier Specifications
| Tier | Price | Max Distance | Volume | Power Drain |
| :--- | :--- | :--- | :--- | :--- |
| **Basic** | $0 | 50.0m | 1.0x | 0.1 |
| **Standard** | $25,000 | 75.0m | 1.2x | 0.2 |
| **Premium** | $50,000 | 100.0m | 1.5x | 0.3 |
| **Ultimate** | $100,000 | 150.0m | 2.0x | 0.4 |

---

## 🛠️ Technical Implementation
The system utilizes a specialized damping formula to handle physical vehicle feedback:
$$v_{new} = v_{current} \times 0.9$$

### **Installation**
1.  **Database**: Import `audio_tiers.sql` into your database.
2.  **Configuration**: Adjust values in `config.lua` to fit your server's economy.
3.  **Deployment**: Ensure the folder is named `vima_audio` and add `ensure vima_audio` to your `server.cfg`.

---

<div align="center">
  <h3>👨‍💻 About the Developer</h3>
  <p><strong>MR. Vima</strong> | BSc (Hons) Software Engineering Student</p>
  <p>Cardiff Metropolitan University</p>
  <p>
    <a href="https://discord.gg/XF7fYtZK"><img src="https://img.shields.io/badge/Discord-100000?style=for-the-badge&logo=discord&logoColor=white" /></a>
  </p>
</div>