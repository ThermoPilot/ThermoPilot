# ThermoPilot Roadmap

A forward‑looking plan for the evolution of ThermoPilot. This roadmap outlines major goals, upcoming features, and the long‑term vision for the project.

ThermoPilot is built at the intersection of thermal engineering, Windows performance tuning, and system behavior analysis. Future development will continue to prioritize safety, clarity, and intelligent automation.

---

# 🟦 Phase 1 — Core Stability & User Experience (Current)

### ✔ Completed
- GPU‑based thermal governor with dynamic EPP control  
- CPU safety‑override system  
- Universal Edition architecture  
- Real‑time GUI with temperature and EPP visibility  
- Automatic ThermoPilot power plan creation  
- Clean shutdown behavior  
- Full documentation (README, FAQ, Troubleshooting, Code of Conduct)  
- Initial public release (v1.0.0)

### 🎯 In Progress
- GUI refinements and layout polish  
- Improved error handling and sensor fallback logic  
- Additional safety checks for unsupported systems  

---

# 🟦 OEM‑Specific Edition Framework

ThermoPilot is designed with a modular architecture that allows for **OEM‑specific editions** when certain hardware platforms require unique handling or behavior tuning. These editions are developed separately to ensure:

- safety  
- stability  
- proper validation  
- responsible handling of system‑specific behavior  

The Universal Edition remains the primary public release for broad compatibility.

### 🎯 Goals for OEM‑Specific Editions
- Improve fallback logic for systems with limited or atypical telemetry  
- Validate behavior across multiple hardware configurations  
- Add clearer UI indicators for telemetry‑unavailable states  
- Ensure safe, predictable EPP behavior under all conditions  
- Prepare documentation tailored to platform‑specific behavior  

### 📝 Current Status
- Internal testing and refinement ongoing  
- Released only when validated for safety and stability  
- Not part of the v1.0.0 public release  

---

# 🟩 Phase 2 — Configurability & User Control

### 🔧 Planned Features
- Adjustable thermal thresholds (Cool/Warm/Hot ranges)  
- Customizable EPP values per stage  
- Optional CPU‑only or GPU‑only modes  
- User‑defined update interval (1–5 seconds)  
- Toggle for CPU override behavior  
- Configurable logging level (minimal, normal, verbose)  

### 🎨 UI Enhancements
- Settings panel within the GUI  
- Theme options (light/dark)  
- Optional detailed temperature graphs  

---

# 🟧 Phase 3 — Telemetry, Logging & Analytics

### 📊 Logging & Monitoring
- Session logging (temps, EPP changes, thermal stages)  
- Exportable logs for troubleshooting or performance analysis  
- Rolling log system to prevent large file sizes  

### 📈 Analytics Mode
- Average temps per session  
- Time spent in each thermal stage  
- CPU/GPU thermal correlation insights  
- Optional “Performance Stability Score”  

---

# 🟥 Phase 4 — Advanced System Integration

### 🧠 Intelligent Enhancements
- Adaptive thresholds based on historical behavior  
- Predictive thermal modeling (anticipate spikes before they occur)  
- Optional integration with fan telemetry (read‑only)  
- Automatic detection of system conflicts and safe fallback modes  

### 🪟 Windows Integration
- Optional taskbar temperature indicator  
- Auto‑start with Windows (user‑controlled)  
- Graceful handling of sleep/hibernate transitions  

---

# 🟪 Phase 5 — Packaging & Distribution

### 📦 Installer & Executable
- Standalone EXE version (PowerShell‑free)  
- Optional MSI installer  
- Digital signing (long‑term goal)  

### 🧩 Plugin Architecture (Exploratory)
- Modular thermal profiles  
- Community‑created presets  
- OEM‑specific extensions  

---

# 🟫 Phase 6 — Long‑Term Vision

### 🌐 Cross‑Discipline Expansion
ThermoPilot is shaped by experience in HVAC‑R thermal systems, Windows internals, and early‑stage cybersecurity/system analysis. Long‑term goals include:

- deeper system behavior modeling  
- safer, smarter thermal automation  
- tools that help users understand their hardware  
- bridging performance engineering with system monitoring  

### 🏢 Professional Integration
Future possibilities include:

- collaboration with hardware vendors  
- integration with Windows performance teams  
- contributions to open‑source telemetry frameworks  
- expanding ThermoPilot into a full‑time engineering focus  

---

# 🤝 Community & Contributions

ThermoPilot welcomes respectful discussion, ideas, and contributions from users of all experience levels. Whether you’re a performance enthusiast, a hardware tinkerer, or someone learning cybersecurity or system engineering, your input is valued.

If you’re interested in contributing, collaborating, or exploring professional opportunities related to this project, feel free to reach out through GitHub.

---

# 📅 Roadmap Status

# ThermoPilot Universal — Roadmap

## Completed
- v1.0.2 — Bottleneck detection + runtime failsafes
- v1.0.1 — GUI + stability improvements
- v1.0.0 — Initial release

## In Progress
- GPU‑only fallback mode for OEM‑locked systems
- Optional logging module (user‑toggle)
- Improved GUI with utilization graphs

## Planned
- v1.1.0 — Auto‑update checker
- v1.2.0 — Plugin system for advanced modules
- v1.3.0 — Optional background‑service mode
