# ThermoPilot Roadmap
A forward‑looking plan for the evolution of ThermoPilot. This roadmap outlines
major goals, upcoming features, and long‑term vision for the project.

ThermoPilot is built at the intersection of thermal engineering, Windows
performance tuning, and system behavior analysis. Future development will
continue to focus on safety, clarity, and intelligent automation.

---

# 🟦 Phase 1 — Core Stability & User Experience (Current)

### ✔ Completed
- GPU‑based thermal governor with dynamic EPP control  
- CPU hard‑override safety system  
- Universal and Acer editions  
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

# 🟦 Acer‑Specific Edition Release Plan

ThermoPilot includes an Acer‑optimized edition designed for systems where CPU
temperature sensors are locked or unavailable. This version is currently kept
private while additional testing, polishing, and documentation are completed.

### 🎯 Goals for the Acer Edition
- Improve fallback logic for systems with hidden CPU sensors  
- Validate GPU‑only thermal behavior across multiple Acer models  
- Add clearer UI indicators for CPU‑sensor‑unavailable states  
- Ensure safe, predictable EPP behavior under all conditions  
- Prepare documentation specific to Acer firmware quirks  

### 📅 Release Timing
The Acer Edition will be released publicly **after the Universal Edition has been
successfully launched and stabilized**. This staggered approach ensures that the
core ThermoPilot experience is solid before expanding support to OEM‑specific
variants.

### 📝 Current Status
- Functional and tested on multiple Acer systems  
- Private repository maintained for ongoing refinement  
- Planned for future public release (not part of v1.0.0)  

The Universal Edition remains the primary focus for the initial public release,
with the Acer Edition following once it meets the same level of polish and
stability.

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
- More detailed temperature graphs (optional)  

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
- Automatic detection of OEM conflicts and safe fallback modes  

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
ThermoPilot is shaped by experience in HVAC‑R thermal systems, Windows internals,
and early‑stage cybersecurity/SOC analysis. Long‑term goals include:

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

ThermoPilot welcomes respectful discussion, ideas, and contributions from users of
all experience levels. Whether you’re a performance enthusiast, a hardware
tinkerer, or someone learning cybersecurity or system engineering, your input is
valued.

If you’re interested in contributing, collaborating, or exploring professional
opportunities related to this project, feel free to reach out through GitHub.

---

# 📅 Roadmap Status

This roadmap will evolve as ThermoPilot grows.  
Major updates will be reflected in the changelog and release notes.
