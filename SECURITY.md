# Security Policy

## Data Handling
ThermoPilot Universal:
- Does **not** collect data  
- Does **not** transmit data  
- Does **not** upload telemetry  
- Does **not** require network access  

All processing occurs locally on the user’s machine.

## Reporting Issues
If you discover a security issue:
1. Open a GitHub Issue  
2. Describe the behavior  
3. Include steps to reproduce  

No logs or personal data are required.

## Supported Versions
- v1.0.2 (current)
- v1.0.1 (limited support)

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
