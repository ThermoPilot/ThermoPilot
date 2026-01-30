# Changelog  
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)  
and this project adheres to **Semantic Versioning**.

---

## [1.0.0] – Initial Public Release

### 🎉 Overview
This is the first major public release of **ThermoPilot**, an intelligent thermal governor for Windows that dynamically adjusts CPU Energy Performance Preference (EPP) based on real‑time GPU and CPU temperatures. This release introduces the core architecture, GUI, thermal logic, and universal compatibility that define ThermoPilot’s design philosophy.

### ✨ Added
- **Dynamic GPU‑based thermal governor**  
  - Cool, Warm, and Hot stages with automatic EPP adjustments  
  - Real‑time GPU temperature monitoring  
  - 2‑second adaptive update cycle  

- **CPU hard‑override safety system**  
  - CPU HOT (≥ 90°C) and CPU MAX (≥ 95°C) protection modes  
  - Automatic fallback when CPU sensors are unavailable  

- **Universal Edition**  
  - Works on most Windows laptops and desktops  
  - Supports Intel Speed Shift and AMD CPPC2  
  - Fully Windows‑native and firmware‑safe  

- **Acer Edition**  
  - Designed for systems with locked CPU sensors  
  - GPU‑only thermal governor with full functionality  

- **Windows‑native EPP control**  
  - No drivers, no firmware access, no EC writes  
  - Safe, reversible, and OEM‑agnostic  

- **Graphical User Interface (GUI)**  
  - Real‑time temperature display  
  - Current EPP state  
  - Current thermal stage  
  - CPU override indicators  
  - Clean, simple, user‑friendly layout  

- **Power plan integration**  
  - Automatic creation of a ThermoPilot power plan  
  - Continuous EPP updates without modifying clocks or voltages  

- **Safe shutdown behavior**  
  - Clean exit when closing the ThermoPilot window  
  - Documentation for avoiding PowerShell ISE stop‑button exceptions  

- **Documentation**  
  - Full README with technical explanation  
  - FAQ  
  - Troubleshooting guide  
  - Code of Conduct  
  - Developer background and professional interest section  

### 🛠 Known Limitations
- Some Acer systems hide CPU temperature sensors  
- PowerShell ISE stop button causes .NET exceptions (expected behavior)  
- Corporate‑managed systems may block power plan editing  

### 🔮 Future Plans
- Optional fan telemetry integration  
- Configurable thermal thresholds  
- Custom EPP profiles  
- Logging and analytics mode  
- Standalone executable version  

---

## v1.0.1 — GUI & OEM Lock Detection Improvements
- Added OEM EPP‑lock detection for systems with firmware‑forced overrides
- Added Acer EC override messaging with referral to ThermoPilot‑Acer Edition
- Improved GUI layout and spacing for clarity
- Increased panel height to prevent clipping
- Adjusted label sizing and wrapping for multi‑line messages
- Centered and aligned all text elements for a cleaner visual layout
- Improved stability of EPP writeback reporting
- Minor cosmetic refinements for readability
