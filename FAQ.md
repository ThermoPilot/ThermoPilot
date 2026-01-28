# ThermoPilot – Frequently Asked Questions

---

## ❓ Why does my CPU temperature show 0°C, N/A, or stay blank?

Your laptop likely has **firmware‑locked CPU sensors**.

Acer (and a few other OEMs) hide CPU temperature from Windows and from tools like LibreHardwareMonitor. When this happens:

- CPU temp cannot be read  
- CPU override cannot activate  
- GPU governor still works normally  

Use the **Acer Edition** if this applies to you.

---

## ❓ Does ThermoPilot conflict with OEM tools like PredatorSense or Armoury Crate?

No — not in a harmful way.

ThermoPilot:

- does not modify firmware  
- does not touch fans  
- does not access EC registers  
- only writes EPP through Windows power APIs  

OEM tools set EPP **once** when you choose a mode.  
ThermoPilot adjusts EPP **continuously**, so it simply takes priority.

---

## ❓ Why didn’t Microsoft build something like ThermoPilot?

Because:

- Windows was never designed to be a thermal governor  
- Microsoft expects OEMs to handle cooling  
- There is no universal thermal API  
- GPU temperature is not part of Windows  
- OEM tools all work differently  
- EPP was never meant to be dynamic  

ThermoPilot fills a gap that no one else addressed.

---

## ❓ Is ThermoPilot safe?

Yes.

ThermoPilot uses:

- Windows power APIs  
- Standard powercfg commands  
- LibreHardwareMonitor for sensor reading  

It does **not**:

- modify firmware  
- change fan curves  
- force clocks  
- write to EC registers  
- install drivers  

It is fully reversible and safe.

---

## ❓ Does ThermoPilot work on desktops?

Yes.

Desktops expose CPU and GPU sensors normally, so the Universal Edition works perfectly.

---

## ❓ Does ThermoPilot work on Intel and AMD?

Yes.

EPP is supported by:

- Intel Speed Shift  
- AMD CPPC2  

ThermoPilot works on both.

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

Direct clock control is unsafe and OEM‑specific.  
EPP is the correct mechanism for a universal tool.

---

## ❓ Why is GPU temperature the primary governor?

Because:

- GPU heat is the main cause of throttling in modern laptops  
- GPU load often determines system temperature  
- CPU and GPU share thermal budgets  
- GPU temp is a better predictor of fan behavior  

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
