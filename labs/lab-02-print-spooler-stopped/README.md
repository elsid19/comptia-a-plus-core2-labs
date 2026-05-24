# Lab 02 — Print Spooler Stopped

**Difficulty:** Beginner  
**Estimated time:** 20–30 minutes  
**Requires admin:** Yes (to run break/restore scripts)

---

## Scenario

A user in the Accounts Payable department reports that he cannot print to any printer —
neither the shared network colour printer nor his desk USB device. Print jobs disappear
silently the moment he clicks Print, with no error dialog. His colleagues print without
issue. Rebooting twice has not resolved the problem.

Read the full ticket in [`case-file.md`](case-file.md).

---

## Objectives mapped

| Code | Description |
|------|-------------|
| 1.4  | Given a scenario, use Microsoft Windows operating system features and tools — specifically Task Manager (Services tab), services.msc, and the Print Spooler service |
| 3.1  | Given a scenario, troubleshoot common Windows OS issues — specifically the "services not starting" symptom |

> Objective references verified against CompTIA A+ 220-1202 Exam Objectives v4.0.

---

## What you'll learn

- What the Print Spooler service does and why all printing stops when it is not running
- How to identify a stopped service using services.msc, Task Manager → Services tab, and `Get-Service` in PowerShell
- Why fixing only the service state (starting it) is not enough — the startup type must also be restored to Automatic or the problem returns after the next reboot
- How to start a service and change its startup type via GUI (services.msc) and via PowerShell and the command prompt
- How to interpret a silent empty print queue and a stuck job as service-layer clues rather than driver or queue corruption problems
- The difference between Manual and Automatic startup types, and when each applies

---

## Prerequisites

- Windows 10 or 11 VM with a snapshot labeled **"Clean"**
- PowerShell 5.1 or later
- Administrator account in the VM

---

## Compatibility

| Environment | Supported |
|-------------|-----------|
| Windows host (Wi-Fi or Ethernet) | ✅ |
| Hyper-V VM (Microsoft Hyper-V Network Adapter) | ✅ |
| VMware VM (VMware VMXNET / E1000) | ✅ |
| VirtualBox VM (VirtualBox network adapter) | ✅ |

This lab does not touch network adapters. The compatibility note above applies to
running the VM environment itself; no adapter detection code is used in the scripts.

---

## How to run this lab

1. Revert your VM to the **"Clean"** snapshot.
2. Open PowerShell **as Administrator**.
3. `cd` to this lab folder.
4. Run `.\break.ps1` — this injects the fault and prints a confirmation.
5. Switch to (or stay as) a standard user and open `case-file.md`.
6. Work the ticket: investigate the reported symptoms using only tools a technician would normally use.
7. When you've identified and fixed the issue (or if you get stuck), expand the solution below.
8. Run `.\restore.ps1` as Administrator to reset the service to its original state.
9. Verify the restore: confirm the Print Spooler is Running and set to Automatic, then send a test print.

---

## How to document your troubleshooting

Working a ticket without documenting it is a missed learning opportunity. After you
resolve this lab, write up what you found using the repo's ticket template — it
builds the habit of clear technical communication, which matters as much as technical
skill in a real IT role.

- **Blank template:** [`../../templates/ticket-template.md`](../../templates/ticket-template.md)
- **Worked example for this lab:** [`example-ticket.md`](example-ticket.md)

The example shows how to eliminate the red herrings, why the stuck job is a clue and
not the cause, and why both the service state and the startup type must be corrected.

---

## Solution walkthrough

<details>
<summary>Spoilers — click to expand</summary>

### Root cause

The Print Spooler service (`Spooler`) was stopped and its startup type was changed from
Automatic to Manual. Windows routes every print job through the spooler — without it,
nothing prints. Because the startup type is Manual, the service does not start
automatically when Windows boots, so a reboot does not fix the problem.

The correct resolution requires **two actions**: start the service AND restore the
startup type to Automatic. Doing only one leaves the machine broken or one reboot away
from the same ticket.

### Why the symptoms fit

| Symptom | Explanation |
|---------|-------------|
| Print jobs disappear silently | The spooler accepts jobs from apps; stopped = no queue, no output |
| No error dialog when printing | The app hands off to Windows print APIs, which fail silently when the spooler is down |
| Queue appears empty | The spooler manages the queue display; stopped = queue not rendered |
| Stuck job from this morning | Spooled before the service went down; cannot be processed or cancelled without the spooler |
| Error when adding a printer | Windows checks for a running spooler before allowing printer management |
| Reboots don't fix it | Startup type is Manual — the service does not auto-start at boot |
| Colleagues unaffected | Service state is per-machine |
| Windows Update — red herring | Update ran two nights ago; printing worked all of yesterday |
| New driver — red herring | Both the network and USB printer fail; a driver issue is always printer-specific |

### Diagnostic steps

1. **Confirm it affects all printers** — both network and USB fail, ruling out a single driver or printer fault.

2. **Inspect the print queue** — open Devices and Printers, note the stuck job and the absence of new jobs.

3. **Check the Print Spooler service state:**

   Via PowerShell:
   ```powershell
   Get-Service -Name Spooler
   ```
   Expected output shows `Status: Stopped`. A healthy machine shows `Running`.

   Check the startup type:
   ```powershell
   Get-Service -Name Spooler | Select-Object Name, Status, StartType
   ```
   Expected output shows `StartType: Manual`. A healthy machine shows `Automatic`.

   Via services.msc:
   - Press `Win + R`, type `services.msc`, press Enter
   - Find **Print Spooler** in the list
   - Status column shows blank (stopped); Startup Type column shows **Manual**

   Via Task Manager:
   - Open Task Manager → **Services** tab
   - Find **Spooler** — Status shows **Stopped**

4. **Identify the full fix** — the service must be started AND the startup type restored to Automatic. Starting alone is insufficient.

### Fix

**Via services.msc (exam-objective path):**
1. In services.msc, right-click **Print Spooler** → **Start**
2. Right-click **Print Spooler** → **Properties**
3. Change **Startup type** from Manual to **Automatic** → click **OK**

**Via PowerShell:**
```powershell
Set-Service -Name Spooler -StartupType Automatic
Start-Service -Name Spooler
Get-Service -Name Spooler   # verify: Status Running, StartType Automatic
```

**Via command prompt:**
```cmd
sc config spooler start= auto
net start spooler
```

Note: `sc config` requires a space between `start=` and the value (`auto`).

### Verification

- `Get-Service -Name Spooler | Select-Object Status, StartType` → `Running`, `Automatic`
- Send a test print to both printers — jobs process and print
- The stuck queue job clears automatically once the spooler is running
- Reboot and retest — service starts automatically and printing continues

### What to remember for the exam

- **Print Spooler** is one of the named common services explicitly listed in Core 2 objective 1.4
- A stopped service with a Manual startup type requires two fixes — state and startup type
- Startup types: **Automatic** (starts at boot), **Manual** (starts on demand or when explicitly started), **Disabled** (cannot start)
- Key tools for service management: `services.msc`, Task Manager → Services tab, `net start`/`net stop`, `sc config`, `Get-Service`/`Start-Service`/`Set-Service` in PowerShell
- A silent, empty print queue with no error dialogs is a strong indicator of a spooler problem, not a driver or network problem

</details>
