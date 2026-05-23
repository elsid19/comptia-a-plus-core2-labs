# Lab 02 — Print Spooler Stopped (TODO)

## Scenario idea

A user reports they can't print to any printer — network or local. Their print jobs disappear immediately without any error. Other users on the same network print fine. The Print Spooler service has been stopped and its startup type changed to Manual, so it does not recover on reboot.

## Objectives covered

| Code | Description |
|------|-------------|
| 1.3  | Use features and tools of the Microsoft Windows OS (services.msc, Task Manager) |
| 3.1  | Given a scenario, troubleshoot common Windows OS problems |

## Break approach

- Save the current startup type and state of the Print Spooler service to `original-spooler-config.json`.
- Stop the `Spooler` service: `Stop-Service -Name Spooler`
- Set startup type to Manual so it stays stopped after a reboot: `Set-Service -Name Spooler -StartupType Manual`

## Restore approach

- Read `original-spooler-config.json`.
- Restore the startup type (Automatic).
- Start the service: `Start-Service -Name Spooler`
- Remove the backup file.

## Red herring ideas for case-file.md

- User recently installed a new printer driver.
- User says the printer "was working this morning."
- The print queue shows no jobs at all (because the spooler isn't running to hold them).

## Exam connection

Services.msc, `net start`/`net stop`, common services and their functions are directly tested on Core 2 3.1.
