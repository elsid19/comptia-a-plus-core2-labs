# Lab 09 — Event Log Cleared (TODO)

## Scenario idea

A user reports a strange pop-up appeared briefly on their screen and then disappeared. IT is asked to investigate. When the technician opens Event Viewer to look at the Security and System logs, they find both logs have been recently cleared — a classic indicator of an attempt to cover tracks. The student must recognize the significance of cleared logs, document the finding per incident response procedure, and check for the single Event ID (1102 in Security log, 104 in System log) that Windows writes when a log is cleared.

## Objectives covered

| Code | Description |
|------|-------------|
| 1.3  | Use features and tools of the Microsoft Windows OS (Event Viewer) |
| 2.4  | Explain common social engineering attacks, threats, and vulnerabilities |
| 4.1  | Compare and contrast best practices associated with types of documentation |
| 4.2  | Given a scenario, implement basic change management best practices |

## Break approach

- Export the current Security and System logs to `.evtx` backup files in `$PSScriptRoot` so restore.ps1 can re-import them.
- Save backup file paths to `original-eventlog-config.json`.
- Clear the Security log: `Clear-EventLog -LogName Security`
- Clear the System log: `Clear-EventLog -LogName System`
- Note: clearing the Security log itself generates Event ID 1102 — this is intentional and part of the learning.

## Restore approach

- Read `original-eventlog-config.json`.
- Re-import the saved `.evtx` files using `wevtutil im` or by copying them back.
- Remove backup files and the JSON.
- Note: log restoration is imperfect; document this limitation in the lab README.

## Red herring ideas for case-file.md

- The "pop-up" the user describes could be a Windows notification (irrelevant) — the real finding is the cleared logs.
- A legitimate IT task ran last night that required a reboot — did that clear the logs? (No, reboots don't clear logs.)

## Exam connection

Event IDs 1102 (Security log cleared) and 104 (System log cleared) are important for 2.4 (threat recognition). Event Viewer navigation and incident documentation are tested under 1.3 and 4.1.
