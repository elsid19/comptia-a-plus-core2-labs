# Lab 06 — UAC Disabled (TODO)

## Scenario idea

During a security audit walkthrough, a technician sits down at a workstation and notices that installing software and running elevated tasks produce no UAC prompt at all — everything silently elevates. The user says a previous IT contractor "turned off those annoying popups" months ago. UAC has been disabled via the registry. The student must identify the misconfiguration, understand the risk, and re-enable UAC.

## Objectives covered

| Code | Description |
|------|-------------|
| 2.5  | Given a scenario, manage and configure basic security settings in the Windows OS |
| 2.6  | Given a scenario, configure a workstation to meet best practices for security |

## Break approach

- Save the current UAC registry value to `original-uac-config.json`.
  - Key: `HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System`
  - Value: `EnableLUA` (1 = enabled, 0 = disabled)
- Set `EnableLUA` to `0`.
- Note: a reboot is required for UAC changes to take effect — the lab guide should instruct the student to reboot after the break is applied.

## Restore approach

- Read `original-uac-config.json`.
- Restore `EnableLUA` to the saved value.
- Prompt the student to reboot to apply the change.
- Remove the backup file.

## Red herring ideas for case-file.md

- The audit was triggered by an unrelated software licensing issue.
- User insists the machine "works fine" and faster without the prompts.
- A legitimate admin tool is installed on the machine — student must determine UAC is the issue, not the tool.

## Exam connection

UAC is explicitly covered under 2.5. The exam tests understanding of what UAC does, where to configure it (both via GUI and `HKLM` registry), and why disabling it is a security risk.
