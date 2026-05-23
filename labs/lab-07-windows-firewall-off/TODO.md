# Lab 07 — Windows Firewall Off (TODO)

## Scenario idea

A security scan run by the IT team flags a workstation as non-compliant: the Windows Defender Firewall is disabled on all profiles (Domain, Private, and Public). The user has no idea it was turned off — they think antivirus is enough. The student must confirm the firewall state, understand the exposure, document it, and re-enable all profiles.

## Objectives covered

| Code | Description |
|------|-------------|
| 2.5  | Given a scenario, manage and configure basic security settings in the Windows OS |
| 2.6  | Given a scenario, configure a workstation to meet best practices for security |

## Break approach

- Save the current firewall profile states to `original-firewall-config.json` using `Get-NetFirewallProfile`.
- Disable all three profiles:
  ```powershell
  Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled False
  ```

## Restore approach

- Read `original-firewall-config.json`.
- Re-enable each profile to its original state using `Set-NetFirewallProfile`.
- Remove the backup file.

## Red herring ideas for case-file.md

- User recently installed a third-party antivirus that "said it would handle the firewall."
- The security scan report also mentions an unrelated expired certificate — a distractor.
- User's machine received a Group Policy update recently (unrelated to the firewall setting).

## Exam connection

Windows Firewall configuration (per-profile enable/disable, inbound/outbound rules) is tested under 2.5. Students should know how to check firewall state via `wf.msc`, `netsh advfirewall`, and PowerShell.
