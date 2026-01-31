# ThermoPilot – Changelog

All notable changes to this project will be documented in this file.  
This project follows [Semantic Versioning](https://semver.org/).

# Changelog

## v1.0.2 — Bottleneck Detection + Failsafes Upgrade
**Release Date:** 2026‑01‑30

### Added
- CPU/GPU utilization‑based bottleneck detection using LibreHardwareMonitor.
- SAFE MODE fallback for missing or invalid telemetry.
- Runtime failsafes for null sensors, negative values, and hardware update failures.
- Hybrid EPP logic combining GPU temperature + workload state.
- Exponential moving average (EMA) smoothing for CPU/GPU utilization.
- GUI indicators for SAFE MODE, bottleneck stage, and EPP status.

### Improved
- More stable EPP transitions with reduced oscillation.
- Better compatibility with OEM‑locked systems (Acer Nitro, ASUS TUF).
- Clearer separation between telemetry, logic, and GUI layers.
- More accurate GPU‑bound detection for modern games.

### Fixed
- Occasional EPP override misreporting in the GUI.
- Rare crash when LibreHardwareMonitor returned incomplete sensor sets.
  
---

## [1.0.1] – 2026-01-30
### Refinements, Stability Improvements, and Documentation Polish

#### Updated
- Improved GUI layout consistency across different DPI scaling levels  
- Enhanced fallback behavior for systems with partial or missing telemetry  
- Refined GPU‑only mode logic for systems without CPU temperature reporting  
- Polished documentation across the entire project:
  - README  
  - FAQ  
  - Troubleshooting Guide  
  - Roadmap  
  - Security Policy  
  - Code of Conduct  
  - Contributing Guide  
- Improved clarity around safe shutdown behavior in PowerShell ISE  

#### Fixed
- Minor UI alignment issues  
- Occasional delayed EPP updates under rapid thermal fluctuations  
- Edge‑case handling when CPU telemetry is unavailable  

#### Notes
- ThermoPilot continues to use a **validated, fixed thermal curve** to ensure predictable, safe, and universal behavior.  
- User‑adjustable EPP values and custom thermal thresholds will **not** be introduced to prevent misconfiguration and instability.

---

## [1.0.0] – 2026-01-29
### Initial Public Release (Universal Edition)

#### Added
- Dynamic GPU‑driven thermal governor  
- CPU hard‑override safety system  
- Real‑time EPP adjustment every 2 seconds  
- Automatic ThermoPilot power plan creation  
- GPU‑based thermal stages (Cool / Warm / Hot)  
- CPU temperature override thresholds  
- Universal telemetry support via LibreHardwareMonitor  
- Real‑time GUI with:
  - GPU temperature  
  - CPU temperature (if available)  
  - current EPP value  
  - active thermal stage  
  - CPU override status  
- Clean shutdown behavior  
- Safe fallback to GPU‑only mode when CPU telemetry is unavailable  
- Full documentation set:
  - README  
  - Troubleshooting Guide  
  - FAQ  
  - Security Policy  
  - Code of Conduct  
  - Roadmap  
  - Contributing Guide  

#### Notes
- ThermoPilot uses only Windows power APIs and standard telemetry.  
- No firmware, EC, voltage, or fan‑curve modifications are performed.  
- Designed for universal compatibility across Windows 10/11 systems.

---

## [Unreleased]
### Planned (Non‑Thermal Enhancements Only)

ThermoPilot will continue using a **fixed, validated thermal curve** to ensure safe, predictable behavior across all systems.  
User‑adjustable EPP values and custom thermal thresholds will **not** be added.

#### Upcoming Improvements
- Optional CPU‑only or GPU‑only modes (when telemetry is limited)  
- User‑selectable update interval (1–5 seconds)  
- Configurable logging level (minimal, normal, verbose)  

#### UI Enhancements
- Settings panel for non‑thermal preferences  
- Theme options (light/dark)  
- Optional detailed temperature graphs  
- Optional taskbar temperature indicator  

#### Long‑Term Goals
- Standalone EXE version (PowerShell‑free)  
- Predictive thermal modeling  
- Enhanced system‑behavior analytics  

See the **Roadmap** for full details.
