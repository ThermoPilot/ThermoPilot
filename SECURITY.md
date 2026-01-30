# Security Policy

ThermoPilot is designed with a safety‑first philosophy. It operates exclusively through standard Windows APIs and temperature telemetry. It does not modify firmware, voltages, or hardware‑level settings. Responsible reporting of issues is appreciated.

---

## Supported Versions

| Version | Status |
|--------|--------|
| 1.x.x  | Supported |
| 0.x.x  | Not supported |

---

## Reporting a Vulnerability

Please report security concerns **privately** rather than opening a public issue.

Contact the maintainer using the email listed on the GitHub profile or in the README. When reporting a concern, include:

- a clear description of the issue  
- steps to reproduce (if applicable)  
- system details (Windows version, CPU/GPU, hardware model)  

All reports are handled confidentially.

---

## Scope

ThermoPilot interacts only with:

- Windows power plan settings  
- standard system APIs  
- LibreHardwareMonitor telemetry  

ThermoPilot does **not**:

- modify firmware or embedded controller registers  
- change voltages, multipliers, or boost behavior  
- install drivers, services, or background processes  
- perform any privileged operations beyond standard Windows power configuration  

Security concerns should focus on:

- unexpected system behavior  
- incorrect EPP application  
- misleading UI states  
- privilege escalation risks (none expected)  
- telemetry inconsistencies  

---

## Commitment

The project will continue to evolve with a focus on:

- safe, predictable behavior  
- transparent design  
- responsible handling of system telemetry  
- timely responses to reported issues  
- maintaining compatibility with standard Windows environments  
