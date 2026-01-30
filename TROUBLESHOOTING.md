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
ThermoPilot.ps1 Then run it again.

---

## ❗ ThermoPilot Does Not Launch

### Check the following:

### 1. Execution Policy
Run: Get-ExecutionPolicy
If it returns **Restricted**, use: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

---

### 2. File Path
Ensure the script is not inside a protected directory such as:

- Program Files  
- Windows  
- System32  

Place it somewhere like: C:\Users<YourName>\Desktop\ThermoPilot\

---

### 3. Required Files
Ensure the folder contains:

- ThermoPilot.ps1  
- LibreHardwareMonitorLib.dll  
- ThermoPilot assets folder (if applicable)

### 4. PowerShell Version
ThermoPilot supports:

- Windows PowerShell 5.1  
- PowerShell 7+  

---

## ❗ ThermoPilot Opens Then Immediately Closes

### Cause
A startup error occurred before the GUI could initialize.

### Fix
Run ThermoPilot from a PowerShell terminal (not by double‑clicking): .\ThermoPilot.ps1

This will display the error message in the console.

---

## ❗ EPP Values Are Not Changing

### Possible Causes & Fixes

### 1. System is idle
ThermoPilot only adjusts EPP when thermal thresholds are crossed.

### 2. CPU/GPU telemetry unavailable
ThermoPilot will fall back to GPU‑only mode if CPU sensors are missing.

### 3. Conflicting software
Other tools may override EPP, such as:

- OEM control panels  
- Overclocking utilities  
- Third‑party power managers  

Close them before running ThermoPilot.

### 4. Unsupported hardware
Some systems restrict EPP control. ThermoPilot will fail safely and log the issue.

---

## ❗ Laptop vs Desktop Behavior Differences

### Cause
Laptops often use **shared heatpipes**, meaning CPU and GPU thermals affect each other. Desktops typically use **separate cooling**, so thermal interaction is minimal.

### Laptop Behavior
- Best performance gains  
- Smoother GPU clocks  
- Reduced thermal throttling  
- Better long‑session stability  

### Desktop Behavior
- Moderate benefit  
- Smoother CPU behavior  
- Reduced fan ramping  
- No GPU performance increase  

---

## ❗ ThermoPilot Doesn’t Improve Performance in Certain Games

### Cause
Some games are **CPU‑bound**, not GPU‑bound.

### Examples of CPU‑heavy games
- Cities Skylines  
- Factorio  
- Minecraft (Java)  
- Simulation/strategy titles  

### Result
ThermoPilot may provide little or no benefit because these games rely heavily on CPU turbo behavior.

### Best‑case scenarios
ThermoPilot shines in **GPU‑heavy** or **balanced** games:

- Cyberpunk 2077  
- Red Dead Redemption 2  
- Hogwarts Legacy  
- Apex Legends  
- Warzone  

---

## ❗ How to Reset Everything to Default

### 1. Delete the ThermoPilot power plan

powercfg /delete "ThermoPilot"

### 2. Restore your preferred plan
Example: powercfg /setactive SCHEME_BALANCED

### 3. Delete the ThermoPilot folder
Remove the directory where you extracted it.

### 4. Reboot
This ensures all power settings reload cleanly.

---

## ⭐ Troubleshooting Summary

| Issue | Cause | Fix |
|-------|--------|------|
| .NET error on exit | Stopping in ISE | Close via GUI or Ctrl+C |
| CPU temp N/A | Firmware hides sensors | GPU‑only fallback |
| GPU temp N/A | LHM can’t detect GPU | Check drivers + DLL |
| Script errors | Unsaved script 






