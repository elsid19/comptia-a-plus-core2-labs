# Lab 08 — BitLocker Suspended (TODO)

## Scenario idea

During a compliance check, a technician discovers that BitLocker protection on the C: drive is showing as "Suspended" rather than "On." The drive is still encrypted, but the protection is paused — meaning the encryption key is stored in the clear and the drive is effectively unprotected. This is a realistic scenario: BitLocker auto-suspends during certain Windows Updates or BIOS changes and sometimes fails to resume. The student must identify the state, understand the risk, and resume protection.

## Objectives covered

| Code | Description |
|------|-------------|
| 2.5  | Given a scenario, manage and configure basic security settings in the Windows OS |
| 2.8  | Given a scenario, use common data destruction and disposal methods (data protection context) |

## Break approach

- Check if BitLocker is enabled on C: first — skip and warn if not (BitLocker may not be available in all VM configs).
- Save current protection status to `original-bitlocker-config.json`.
- Suspend BitLocker: `Suspend-BitLocker -MountPoint "C:" -RebootCount 0`

## Restore approach

- Read `original-bitlocker-config.json`.
- Resume BitLocker protection: `Resume-BitLocker -MountPoint "C:"`
- Remove the backup file.

## Notes / constraints

- BitLocker requires a TPM or a USB startup key; it may not be available in all VM environments.
- Add a pre-flight check in break.ps1 that gracefully skips the lab if BitLocker is not present.
- Consider an alternate version using a VHD with BitLocker To Go for environments without TPM.

## Red herring ideas for case-file.md

- A recent BIOS update was pushed by IT (this actually can legitimately cause suspension — the student must still fix it).
- User reports a performance improvement since "something changed" — suspended BitLocker slightly reduces overhead.

## Exam connection

BitLocker states (On, Suspended, Off), where to manage it (Control Panel, `manage-bde`, PowerShell), and when it auto-suspends are all testable under 2.5.
