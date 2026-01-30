<p align="center">
  <img src="assets/banner.png" width="100%" />
</p>

# ThermoPilot – Intelligent Thermal Governor for Windows
**Dynamic GPU‑driven performance control. CPU‑aware safety. Zero firmware access.**

ThermoPilot is a lightweight, intelligent thermal governor for Windows that dynamically adjusts CPU Energy Performance Preference (EPP) based on real‑time GPU and CPU temperatures. It delivers smoother performance, quieter operation, and safer thermals — all without touching firmware, drivers, or fan curves.

ThermoPilot fills a gap that Windows and OEM tools never addressed:  
**real‑time, temperature‑based performance scaling.**

---

# 🌟 Why ThermoPilot Exists

Modern laptops and compact systems push hardware harder than ever:

- shared CPU/GPU thermal budgets  
- aggressive boost algorithms  
- thin chassis with limited cooling  
- OEM tools that only switch static modes  
- Windows power plans that never adjust dynamically  

ThermoPilot introduces a **smart, adaptive thermal governor**:

- GPU‑based thermal stages  
- CPU hard‑override safety  
- dynamic EPP control every 2 seconds  
- universal compatibility  
- zero risk to firmware or hardware  

It behaves like a feature Windows *should* have had — but never did.

---

# 🧬 What Makes ThermoPilot Unique

ThermoPilot is not another “performance mode” switcher or fan‑control utility.  
It introduces a capability that neither Windows nor OEM tools provide:  
**real‑time, temperature‑driven EPP control based on GPU and CPU behavior.**

---

## 🔹 1. Dynamic EPP Control (Windows and OEMs Don’t Do This)

Windows power plans are static.  
OEM tools (PredatorSense, Armoury Crate, MSI Center, Lenovo Vantage) are also static.

They set EPP **once** when you choose a mode.

ThermoPilot is different:

- reads temperatures every 2 seconds  
- adjusts EPP dynamically  
- reacts to real thermal conditions  
- stabilizes performance under fluctuating loads  

This is something **no OEM tool and no Windows feature does.**

---

## 🔹 2. GPU‑Driven Thermal Logic (A First for Windows)

Windows has no native GPU temperature API.  
OEM tools rarely use GPU temperature to influence CPU behavior.

ThermoPilot does.

Modern laptops share thermal budgets between CPU and GPU.  
GPU heat is often the limiting factor — not CPU heat.

ThermoPilot uses GPU temperature as the **primary governor**, making it far more accurate than CPU‑only tools.

---

## 🔹 3. CPU Hard‑Override Safety (Hybrid Thermal Intelligence)

ThermoPilot combines:

- GPU‑based performance scaling  
- CPU‑based safety override  

If the CPU overheats, ThermoPilot immediately raises EPP to reduce boost pressure — even if the GPU is cool.

This hybrid logic mirrors how high‑end systems manage thermals internally.

---

## 🔹 4. Zero Firmware Access (Safe on Every System)

ThermoPilot never touches:

- EC registers  
- fan curves  
- BIOS settings  
- voltage tables  
- clock multipliers  
- firmware values  

It uses only:

- Windows power APIs  
- standard powercfg commands  
- LibreHardwareMonitor for sensor reading  

This makes it:

- safe  
- reversible  
- OEM‑agnostic  
- compatible with all laptops and desktops  

---

## 🔹 5. Works With Intel Speed Shift and AMD CPPC2

ThermoPilot doesn’t fight modern CPU boost technologies — it **guides** them.

### ✔ Intel Speed Shift (HWP)
ThermoPilot dynamically adjusts EPP, which Speed Shift responds to instantly.

Benefits:

- smoother boost behavior  
- fewer thermal spikes  
- more consistent performance  

### ✔ AMD CPPC2
ThermoPilot’s dynamic EPP adjustments allow AMD CPUs to:

- boost harder when cool  
- back off when hot  
- avoid thermal throttling  
- maintain stable clocks  

ThermoPilot works *with* the CPU, not against it.

---

## 🔹 6. Universal Compatibility

ThermoPilot works on:

- Intel and AMD CPUs  
- NVIDIA and AMD GPUs  
- Windows 10 and 11  
- laptops and desktops  
- systems with full or partial telemetry  

If CPU telemetry is unavailable, ThermoPilot automatically falls back to **GPU‑only mode**, which remains safe and fully supported.

---

## 🔹 7. A True Thermal Governor for Windows

ThermoPilot behaves like a Linux‑style thermal governor:

- monitors temps  
- adjusts performance  
- prevents throttling  
- stabilizes workloads  
- protects hardware  

Windows has never offered this.  
OEM tools don’t offer this.  
No third‑party tool offers this in a universal, firmware‑safe way.

ThermoPilot is the missing thermal layer Windows never built.

---

# 🖥️ Editions

## **Universal Edition**
The primary public release. Supports:

- GPU temperature detection  
- CPU temperature detection (if exposed by firmware)  
- GPU‑based thermal stages  
- CPU hard‑override safety  
- dynamic EPP control  

If CPU telemetry is unavailable, ThermoPilot automatically uses GPU‑only mode.

---

# ⚙️ How ThermoPilot Works

## 🎯 GPU‑Based Thermal Stages (Primary Governor)

| Stage | Temp Range | EPP | Behavior |
|-------|------------|-----|----------|
| **Cool** | 0–55°C | 10 | Maximum responsiveness |
| **Warm** | 56–70°C | 35 | Balanced performance |
| **Hot** | 71–75°C | 55 | Reduced boost to stabilize temps |

---

## 🔥 CPU Hard Safety Override

If CPU temperature is available:

- **≥ 90°C** → EPP 60 (CPU HOT)  
- **≥ 95°C** → EPP 90 (CPU MAX)  

If CPU telemetry is unavailable, this feature is automatically disabled.

---

# 🖼️ ThermoPilot GUI Preview

![ThermoPilot GUI](assets/ThermoPilot_GUI.png)

The GUI provides real‑time visibility into GPU and CPU temperatures,  
current EPP value, active thermal stage, and CPU override status — all in a clean, lightweight interface.

---

# 🧩 Interaction with OEM Tools

ThermoPilot does **not** conflict with OEM tools in any harmful way.

It does **not**:

- modify firmware  
- change fan curves  
- access EC registers  
- override boost algorithms directly  

OEM tools typically set EPP **once** when you choose a mode.  
ThermoPilot adjusts EPP **continuously**, so it simply takes priority.

---

# 🖥️ Laptops vs Desktops — Who Benefits Most?

## ✔ Laptops (Highest Benefit)
Most laptops use **shared heatpipes**, meaning CPU and GPU thermals affect each other.

ThermoPilot helps by:

- reducing CPU spikes that steal GPU thermal headroom  
- improving sustained GPU clocks  
- reducing thermal throttling  
- smoothing long‑session performance  

## ✔ Desktops (Moderate Benefit)
Desktops typically have **separate cooling**, so thermal interaction is minimal.

ThermoPilot helps by:

- smoothing CPU boost behavior  
- reducing fan ramping  
- improving long‑session stability  

But desktops do **not** gain GPU performance.

---

# 🎮 Game Behavior — Who Sees Gains?

## ✔ GPU‑Heavy Games (Best Case)
- Cyberpunk 2077  
- Red Dead Redemption 2  
- Hogwarts Legacy  

ThermoPilot improves:

- sustained GPU clocks  
- frame pacing  
- thermal stability  

## ✔ Balanced Games (Moderate Benefit)
- Apex Legends  
- Warzone  
- Fortnite  

## ✔ CPU‑Heavy Games (Low or No Benefit)
- Cities Skylines  
- Factorio  
- Minecraft (Java)  

CPU‑bound games rely heavily on CPU turbo behavior, so gains are minimal.

---

# 📦 Installation

1. Download the Universal Edition.  
2. Place `ThermoPilot.ps1` and `LibreHardwareMonitorLib.dll` in the same folder.  
3. (Optional) Add your ThermoPilot logo PNG.  
4. Open PowerShell or Windows Terminal.  
5. Run the script (saving is required if using ISE).  
6. Press **F5** or run `.\ThermoPilot.ps1`.

---

# 🧪 System Compatibility

### ✔ Works on:
- Windows 10 / 11  
- Intel and AMD CPUs  
- NVIDIA and AMD GPUs  
- laptops and desktops  

### ❗ Limitations:
- Some systems restrict CPU telemetry  
- Some corporate devices lock power‑plan editing  

---

# 🔍 How to Verify ThermoPilot Is Working

## 1. Check Live EPP Values
Run: powercfg /query SCHEME_CURRENT SUB_PROCESSOR PERFENERGYPREFERENCE
You will see EPP change as ThermoPilot adjusts it.

## 2. Confirm Temperature Readings
Compare with:

- LibreHardwareMonitor  
- HWiNFO  
- OpenHardwareMonitor  

## 3. Trigger State Changes
- Idle → EPP rises  
- Moderate load → EPP adjusts  
- Heavy GPU load → EPP drops  

## 4. Optional: Check Event Log
If logging is enabled, entries appear under:

**Event Viewer → Applications and Services Logs → ThermoPilot**

---

# 📚 Documentation

- [FAQ](FAQ.md)  
- [Troubleshooting](TROUBLESHOOTING.md)  
- [Roadmap](ROADMAP.md)  
- [Contributing](CONTRIBUTING.md)  
- [License](LICENSE)  

---

# 📝 License

MIT License.  
ThermoPilot is free to use, modify, and distribute.

---

# 🤝 Contributing

Pull requests, feature suggestions, and improvements are welcome.  
ThermoPilot is designed to be simple, safe, and community‑friendly.

---

📧 Contact: ThermoPilot@outlook.com

---

# 👤 About the Developer

ThermoPilot is developed by a creator with a unique blend of experience across  
**HVAC‑R thermal systems**, **Windows performance engineering**, and **cybersecurity/system analysis**.

My background includes:

- HVAC‑R training in heat transfer, airflow dynamics, and system load balancing  
- hands‑on troubleshooting across both physical and digital systems  
- Windows internals, power‑management behavior, and hardware telemetry  
- early‑stage cybersecurity/SOC analysis training  

ThermoPilot reflects the intersection of everything I enjoy:  
**understanding systems, analyzing behavior, solving problems, and building tools that make technology safer and more efficient.**

I’m actively transitioning these skills into a long‑term professional career in:

- Windows performance engineering  
- gaming hardware optimization  
- system‑level software development  
- cybersecurity / SOC analysis  
- or a hybrid role that blends both worlds  

If you work in the Windows, gaming, hardware, or cybersecurity space and are interested in collaboration or professional opportunities, feel free to reach out through GitHub.
