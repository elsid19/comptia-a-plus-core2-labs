# Lab 05 — Suspicious Scheduled Task (TODO)

## Scenario idea

During a routine check, a technician notices the workstation is sluggish and a security scan flagged unusual scheduled task activity. A scheduled task with a benign-but-suspicious-looking name (e.g., `WindowsUpdateHelperSvc`) runs a script from the user's Temp folder every 5 minutes. The script itself is harmless (writes a timestamp to a log file), but the pattern — hidden name, runs from Temp, frequent interval — mirrors real malware persistence techniques. The student must find it, investigate it, and remove it.

## Objectives covered

| Code | Description |
|------|-------------|
| 2.3  | Given a scenario, detect, remove, and prevent malware |
| 2.4  | Explain common social engineering attacks, threats, and vulnerabilities |
| 3.2  | Given a scenario, troubleshoot common PC security issues |
| 3.3  | Given a scenario, use best practice procedures for malware removal |

## Break approach

- Drop a benign `.ps1` script into `$env:TEMP\wuhelper.ps1` (writes a timestamp to a log).
- Register a scheduled task named `WindowsUpdateHelperSvc` that runs it every 5 minutes as SYSTEM.
- Save the task name and script path to `original-task-config.json`.

## Restore approach

- Read `original-task-config.json`.
- Unregister the scheduled task: `Unregister-ScheduledTask`.
- Delete the script from Temp.
- Remove the backup file.

## Red herring ideas for case-file.md

- User installed a "system optimizer" tool last week (unrelated).
- Task name looks like a legitimate Windows service name.
- The task doesn't appear in Task Manager processes unless it's actively running.

## Exam connection

Task Scheduler is a common malware persistence mechanism. Core 2 3.2 and 3.3 cover identifying and removing malware; knowing where to look (Task Scheduler, registry Run keys, Startup folders) is exam-tested.
