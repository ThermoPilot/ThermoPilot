# ThermoPilot – Frequently Asked Questions

---

## ❓ Why do I get a .NET Framework “Unhandled Exception” when stopping ThermoPilot?

This occurs only when running ThermoPilot inside **PowerShell ISE** and clicking the red ■ Stop button.

PowerShell ISE does not gracefully stop WinForms applications. When you click Stop:

- ISE immediately kills the PowerShell script engine  
- The ThermoPilot window is still running  
- The timer and message loop are still active  
- The form attempts to update itself  
- But the PowerShell host is gone  
- .NET throws an “Unhandled Exception” dialog  

This is normal behavior for any WinForms script in ISE.

### ✔ How to avoid this error
Use one of these safe shutdown methods:

- Click the **Close** button inside the ThermoPilot window  
- Press **Ctrl + C** in the ISE console pane  
- Run ThermoPilot from Windows Terminal or PowerShell.exe  

### ✔ Is this a ThermoPilot bug?
No.  
It is a PowerShell ISE limitation. ThermoPilot shuts down cleanly when closed from its own window.

---

## ❓ Why does my CPU temperature show 0°C, N/A, or stay blank?

Some systems do not expose CPU temperature sensors through standard telemetry.  
When this happens:

- CPU temperature cannot be read  
- CPU override cannot activate  
- GPU‑based thermal control still works normally  

ThermoPilot automatically falls back to **GPU‑only mode**, which is safe and fully supported.

---

## ❓ Does ThermoPilot conflict with OEM tools like PredatorSense or Armoury Crate?

No.

ThermoPilot:

- does not modify firmware  
- does not touch fans  
- does not access EC registers  
- only writes EPP through Windows power APIs  

OEM tools typically set EPP **once** when you choose a mode.  
ThermoPilot adjusts EPP **continuously**, so it simply takes priority.

---

## ❓ Why didn’t Microsoft build something like ThermoPilot?

Because:

- Windows was never designed to be a thermal governor  
- Microsoft expects OEMs to manage cooling  
- There is no universal thermal API  
- GPU temperature is not part of Windows  
- OEM tools all work differently  
- EPP was never intended to be dynamic  

ThermoPilot fills a gap that no existing tool addresses.

---

## ❓ Is ThermoPilot safe?

Yes.

ThermoPilot uses:

- Windows power APIs  
- standard powercfg commands  
- LibreHardwareMonitor for sensor reading  

It does **not**:

- modify firmware  
- change fan curves  
- force clocks  
- write to EC registers  
- install drivers or services  

It is fully reversible and safe.

---

## ❓ Does ThermoPilot work on desktops?

Yes.

Desktops expose CPU and GPU sensors normally, and ThermoPilot works as expected.  
Desktops benefit mainly from smoother CPU behavior and reduced fan ramping.

---

## ❓ Does ThermoPilot work on Intel and AMD?

Yes.

EPP is supported by:

- Intel Speed Shift  
- AMD CPPC2  

ThermoPilot works with both technologies.

---

## ❓ Does ThermoPilot void my warranty?

No.

It uses only Windows‑level APIs and does not modify hardware.

---

## ❓ Why does ThermoPilot adjust EPP instead of clocks?

Because EPP is:

- safe  
- universal  
- reversible  
- supported by Windows  
- supported by Intel and AMD  
- designed for dynamic performance scaling  

Direct clock control is OEM‑specific and unsafe for a universal tool.  
EPP is the correct mechanism for cross‑platform performance tuning.

---

## ❓ Why is GPU temperature the primary governor?

Because:

- GPU heat is the main cause of throttling in modern laptops  
- GPU load often determines system temperature  
- CPU and GPU share thermal budgets  
- GPU temperature is a better predictor of sustained performance  

CPU override still protects the CPU when needed.

---

## ❓ Why does the script need to be saved before running?

PowerShell ISE cannot determine the script path unless it is saved.  
If unsaved, `$MyInvocation.MyCommand.Path` contains the script text, causing errors.

Save the script before running.

---

## ❓ What happens if I close the GUI?

ThermoPilot stops immediately.  
No background processes remain.

---

# ⚠️ Common Issues

## ❗ EPP Not Changing
Possible causes:

- OEM tool constantly rewriting EPP  
- Running multiple tuning tools  
- Power plan locked by corporate policy  

Fix:

- Close OEM performance tools  
- Use ThermoPilot exclusively  
- Ensure the active power plan is editable  

---

## ❗ Power Plan Not Switching
Cause:  
Windows may be stuck on a custom OEM plan.

Fix:

- Delete unused OEM plans  
- Recreate the ThermoPilot plan  
- Run PowerShell as Administrator  

---

## ❗ GUI Looks Cut Off or Misaligned
Cause:  
WinForms scaling on high‑DPI displays.

Fix:

- Ensure Windows scaling is 100–125%  
- Resize the window  
- Use the latest version of ThermoPilot  

---

## ❗ CPU Override Never Activates
Cause:  
CPU temperature is not available on your system.

Fix:  
ThermoPilot will automatically operate in GPU‑only mode when CPU telemetry is unavailable.
