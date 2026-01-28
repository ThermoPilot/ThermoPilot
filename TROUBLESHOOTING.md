# ThermoPilot – Troubleshooting Guide

---
## ❗ .NET Framework “Unhandled Exception” When Stopping ThermoPilot

**Cause:**  
You clicked the red ■ Stop button in PowerShell ISE.  
ISE force‑terminates the script engine while the ThermoPilot GUI is still running.

**Fix:**  
Close ThermoPilot using its own **Close** button, or press **Ctrl + C** in the ISE console pane.

**Notes:**  
This is expected behavior for WinForms scripts in ISE and is not a ThermoPilot error.

## ❗ CPU Temp Shows 0°C, N/A, or Blank

Cause:  
Your laptop firmware hides CPU sensors.

Fix:  
Use the **Acer Edition**.

---

## ❗ GPU Temp Shows N/A

Cause:  
LibreHardwareMonitor cannot detect your GPU.

Fix:  
- Ensure GPU drivers are installed  
- Ensure LibreHardwareMonitorLib.dll is in the same folder  
- Restart the script  

---

## ❗ Script Errors: “Illegal characters in path”

Cause:  
You ran the script **without saving it** in PowerShell ISE.
Fix:  
Save the script as `ThermoPilot.ps1` and run again.

---

## ❗ Script Does Not Launch

Check:

- Execution policy  
- File path  
- Script saved correctly  
- LibreHardwareMonitorLib.dll present  

Try:

```powershell


**Notes:**  
This is expected behavior for WinForms scripts in ISE and is not a ThermoPilot error.
