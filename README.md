# ThermoPilot – A Temperature‑Aware Power Governor for Windows

ThermoPilot is an open‑source thermal governor for Windows laptops and desktops.  
It dynamically adjusts your system’s power plan based on real CPU/GPU temperatures, reducing overheating, preventing throttling, and improving gaming stability — all without modifying firmware or fan curves.

Windows has static power plans.  
OEM tools have inconsistent fan control.  
ThermoPilot bridges the gap with intelligent, temperature‑aware automation.

---

## ⭐ Features

- **Hybrid Thermal Governor**
  Automatically switches between Best Performance and Balanced based on CPU/GPU temps.

- **Profiles**
  Quiet, Balanced, and Performance modes with customizable thresholds.

- **GPU + CPU Temperature Monitoring**
  Uses OpenHardwareMonitor’s WMI interface for accurate sensor data.

- **Safe & Non‑Intrusive**
  No BIOS mods, no EC flashing, no kernel drivers.

- **Tray Icon + GUI**
  Clean WinForms interface with real‑time temps and status messages.

- **Auto‑Launch Support**
  Works seamlessly with Windows Task Scheduler.

- **Vendor‑Agnostic**
  Works on Acer, ASUS, Dell, Lenovo, MSI, HP, and more.

---

## 📦 Installation

1. Download **OpenHardwareMonitor**  
   Place it in:  
   `C:\Users\<you>\Tools\OpenHardwareMonitor\OpenHardwareMonitor.exe`

2. Download `ThermoPilot.ps1` from Releases.

3. (Optional) Create a Scheduled Task:
   ```
   powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "C:\Path\To\ThermoPilot.ps1"
   ```

4. Run the script.  
   The GUI will appear and minimize to tray.

---

## 🧠 How It Works

ThermoPilot does **not** control fan speed.  
Instead, it controls **heat generation** by adjusting CPU boost behavior through Windows power plans.

### When temps rise:
- Switch to **Balanced**
- Reduce CPU boost
- Reduce heat output
- Allow fans to catch up

### When temps fall:
- Switch to **Best Performance**
- Restore full boost
- Maximize FPS and responsiveness

This mirrors how Linux laptop governors work — but for Windows.

---

## 🛠 Roadmap

- [ ] Configurable thresholds per profile  
- [ ] GPU‑based switching logic  
- [ ] Logging to file  
- [ ] Auto‑restart if OHM crashes  
- [ ] Optional LibreHardwareMonitor support  
- [ ] Dark mode GUI  
- [ ] Export/import profiles  
- [ ] EXE packaging  

---

## 🤝 Contributing

Pull requests are welcome.  
If you have ideas for new features, open an issue.

---

## 📄 License

MIT License – free to use, modify, and distribute.

---

## 💬 Why This Exists

Windows lacks a temperature‑aware power governor.  
OEM tools are inconsistent.  
Gamers and power users deserve better.

ThermoPilot fills that gap with a safe, open, and intelligent solution.
