# Lab 03 — Account Disabled (TODO)

## Scenario idea

A user calls in saying they can't log in to their workstation. They receive the message "Your account has been disabled. Please see your system administrator." They were on vacation for two weeks and are trying to log back in on their first day back. A local test account (e.g., `labuser`) is disabled by break.ps1 to simulate this.

## Objectives covered

| Code | Description |
|------|-------------|
| 2.5  | Given a scenario, manage and configure basic security settings in the Windows OS |
| 1.3  | Use features and tools of the Microsoft Windows OS (lusrmgr.msc, Local Users and Groups) |
| 3.1  | Given a scenario, troubleshoot common Windows OS problems |

## Break approach

- Create a local test account `labuser` if it doesn't exist (or target an existing non-admin account).
- Save current enabled/disabled state to `original-account-config.json`.
- Disable the account: `Disable-LocalUser -Name 'labuser'`

## Restore approach

- Read `original-account-config.json`.
- Re-enable the account: `Enable-LocalUser -Name 'labuser'`
- Remove the backup file.

## Red herring ideas for case-file.md

- User thinks it might be because they forgot their password (it's not — it's disabled, not locked).
- User mentions IT sent a security email two weeks ago about account audits.
- The error message is slightly different from a lockout — a good technician knows the distinction.

## Exam connection

Account management (enable/disable, lockout vs. disabled) is tested under 2.5 and 2.6. `net user`, `lusrmgr.msc`, and Local Users and Groups are key tools.
