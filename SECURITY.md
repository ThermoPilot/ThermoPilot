# Security Policy

ThermoPilot is designed to operate safely using standard Windows APIs and
temperature telemetry. It does not modify firmware, voltages, or hardware-level
settings. Responsible reporting of issues is appreciated.

---

## Supported Versions

| Version | Status |
|--------|--------|
| 1.x.x  | Supported |
| 0.x.x  | Not supported |

---

## Reporting a Vulnerability

Please report security concerns **privately** rather than opening a public issue.

Contact the maintainer through the email listed on the GitHub profile or in the
README. Include:

- a clear description of the issue  
- steps to reproduce (if applicable)  
- system details (Windows version, CPU/GPU, OEM model)  

Reports are handled confidentially.

---

## Scope

ThermoPilot interacts only with:

- Windows power plan settings  
- standard system APIs  
- LibreHardwareMonitor telemetry  

It does **not**:

- modify firmware or EC registers  
- change voltages or multipliers  
- install drivers or services  

Security concerns should focus on:

- unexpected system behavior  
- incorrect EPP application  
- misleading UI states  
- privilege escalation risks (none expected)

---

## Commitment

The project will continue to evolve with a focus on:

- safe, predictable behavior  
- transparent design  
- timely handling of reported issues  
