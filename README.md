ThermoPilot – Acer Edition
A lightweight, intelligent thermal governor for Windows 11 gaming laptops.

🔥 Overview
ThermoPilot is a smart, automatic thermal‑management utility designed for Windows 11 laptops — with special tuning for Acer gaming systems. It reads real GPU temperature directly from LibreHardwareMonitorLib.dll, giving you accurate, low‑overhead sensor data without requiring any external applications to run.
ThermoPilot then uses that temperature data to dynamically adjust your system’s power plan and CPU behavior, keeping your machine cool, quiet, and responsive under all workloads.
No bloat.
No OEM conflicts.
No guesswork.
Just clean, predictable thermal automation.

❄️ Key Features
✔ Direct hardware sensor access via LibreHardwareMonitor
ThermoPilot loads LibreHardwareMonitorLib.dll directly, providing:
- Accurate GPU temperature
- Modern CPU/GPU support
- Zero dependency on OpenHardwareMonitor.exe
- No WMI polling
- No background apps required
✔ Four‑stage thermal governor
ThermoPilot intelligently transitions through Cool → Warm → Hot → Acer Revert Mode based on real GPU temperature.
✔ Dynamic EPP control
ThermoPilot rewrites the CPU’s Energy Performance Preference (EPP) in real time to optimize performance and heat output.
✔ Acer‑optimized behavior
At 75°C, ThermoPilot automatically hands control back to Acer’s embedded firmware to avoid conflicts and ensure stability.
✔ Clean, modern GUI
- Windows 11‑style layout
- Centered ThermoPilot logo
- Clear status panel
- No clutter, no unnecessary controls
✔ Lightweight and efficient
Runs on PowerShell with minimal CPU usage and no background services.

⚡ Energy Performance Preference (EPP) — How ThermoPilot Controls CPU Behavior
What is EPP?
Energy Performance Preference (EPP) is a low‑level CPU tuning parameter built into Windows and modern AMD/Intel processors.
It tells the CPU how aggressively it should boost versus how conservatively it should save power.
Think of it as the CPU’s “performance personality”:
- Low EPP (0–30) → Maximum performance, fast boost, high responsiveness
- Medium EPP (30–60) → Balanced behavior
- High EPP (60–100) → Efficiency‑first, cooler, quieter
EPP directly affects:
- boost frequency
- boost duration
- power draw
- heat output
- responsiveness under load
It’s one of the most important CPU controls in Windows — but OEMs rarely expose it.

🔥 ThermoPilot’s Four‑Stage EPP System
ThermoPilot dynamically rewrites the active power plan’s EPP value based on real GPU temperature.
This gives you adaptive CPU behavior that changes with thermal load.

🟦 Stage 1 — COOL (Below 60°C)
EPP = 10
- Maximum responsiveness
- Fast CPU boost
- Ideal for gaming, browsing, and general use
- System stays cool enough to allow aggressive performance
This is your “full power” mode.

🟧 Stage 2 — WARM (60–75°C)
EPP = 35
- Balanced performance
- Reduced boost pressure
- Lower heat buildup
- Smooth transition between cool and hot states
This prevents unnecessary heat creep.

🔥 Stage 3 — HOT (Approaching 75°C)
EPP = 55
- CPU boost becomes more conservative
- Heat output drops
- Helps stabilize temps before hitting Acer’s firmware threshold
This stage slows the climb toward thermal limits.

🛡️ Stage 4 — ACER REVERT MODE (75°C and above)
At 75°C, ThermoPilot stops writing EPP and hands control back to Acer’s embedded firmware.
Acer laptops have internal thermal logic that activates around 75°C, including:
- hidden EPP overrides
- boost suppression
- internal thermal tables
- OEM‑controlled power behavior
Instead of fighting Acer’s firmware, ThermoPilot steps aside and lets the system protect itself.
What happens at 75°C:
- ThermoPilot pauses EPP control
- Acer’s firmware takes over CPU behavior
- Boost limits and thermal protections activate
- ThermoPilot continues monitoring temperature but does not interfere
When temps fall below 75°C again, ThermoPilot automatically resumes normal control.

⭐ Why ThermoPilot Stands Out
✔ Four‑stage thermal logic
Most tools only offer “performance” and “balanced.”
ThermoPilot uses Cool → Warm → Hot → Acer Revert, giving you smoother transitions and better stability.
✔ Direct EPP control
ThermoPilot writes EPP directly into the active power plan — no OEM utilities, no background services, no guesswork.
✔ Temperature‑driven behavior
EPP changes are tied to real GPU temperature, not timers or static profiles.
✔ Acer‑aware design
ThermoPilot respects Acer’s firmware and hands control back at 75°C to avoid conflicts.
✔ Better than OEM tools
Acer’s software doesn’t expose EPP at all — ThermoPilot gives you control they never intended you to have.

📦 Installation
- Download the latest release from the Releases section.
- Extract the folder anywhere you like.
- Ensure the following files are in the same directory:
- ThermoPilot.ps1
- LibreHardwareMonitorLib.dll
- thermopilot_logo.png
- Run the script using PowerShell (Run as Administrator recommended).

🧭 Usage
- Launch ThermoPilot
- The GUI will display:
- GPU temperature (via LibreHardwareMonitor)
- Active power plan
- Current thermal stage
- Last EPP write‑back
- ThermoPilot will automatically adjust your power plan as temperatures change.
- Close the GUI at any time — the script exits cleanly.

🛡️ Safety & Stability
ThermoPilot is designed with reliability first:
- Never forces extreme turbo modes
- Never overrides OEM fan curves
- Never writes invalid power settings
- Never crashes if sensors are missing
- Never changes anything unless temperature data is valid
If anything looks wrong, ThermoPilot simply pauses automation and waits.

🧩 Requirements
- Windows 11
- PowerShell 5.1 or newer
- LibreHardwareMonitorLib.dll (included)
- Administrator privileges for power plan changes

📸 Screenshots
(Will Upload Later)

📝 Roadmap
- Optional dark mode
- Optional tray icon
- Optional advanced tuning panel
- Support for CPU temperature fallback
- Support for multi‑GPU systems

📄 License
MIT License — free to use, modify, and distribute.

⭐ Why ThermoPilot Exists
OEM thermal tools are often bloated, unpredictable, or overly aggressive.
ThermoPilot was built to be:
- predictable
- lightweight
- transparent
- user‑controlled
- and actually helpful
It’s a tool made by someone who understands the pain of overheating laptops and wanted a clean, reliable solution.


