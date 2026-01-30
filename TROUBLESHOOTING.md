# ThermoPilot – Troubleshooting Guide

This guide covers the most common issues users may encounter when running ThermoPilot. All solutions are written with safety, clarity, and Windows‑ecosystem compatibility in mind.

---

## ❗ Stopping ThermoPilot in PowerShell ISE Causes a .NET “Unhandled Exception”

### Cause
PowerShell ISE force‑terminates the script engine when the red ■ Stop button is clicked. The ThermoPilot GUI is still running, which triggers a .NET Framework error.

### Fix
- Close ThermoPilot using its **own Close button**, or  
- Press **Ctrl + C** in the ISE console pane  

### Notes
This is normal behavior for any WinForms script inside PowerShell ISE. It is not a ThermoPilot bug.

---

## ❗ CPU Temperature Shows 0°C, N/A, or Blank

### Cause
Your system’s firmware does not expose CPU temperature sensors through standard telemetry.

### Fix
ThermoPilot automatically falls back to **GPU‑based thermal control** when CPU telemetry is unavailable. This mode is safe and fully supported.

### Notes
- Many laptops expose GPU sensors but restrict CPU telemetry  
- ThermoPilot remains fully functional in GPU‑only mode  
- Performance benefits may vary depending on workload  

---

## ❗ GPU Temperature Shows N/A

### Cause
LibreHardwareMonitor cannot detect your GPU.

### Fix
- Ensure GPU drivers are installed  
- Ensure **LibreHardwareMonitorLib.dll** is in the same folder as ThermoPilot  
- Restart ThermoPilot  
- If using a laptop with hybrid graphics, ensure the dGPU is active  

### Notes
Some systems disable the dGPU when idle. Launching a game or GPU‑accelerated app may activate it.

---

## ❗ Script Errors: “Illegal characters in path”

### Cause
The script was run **unsaved** inside PowerShell ISE. ISE assigns a temporary path containing invalid characters.

### Fix
Save the script as:
