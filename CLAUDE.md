# CLAUDE.md — Project Briefing

This file is read automatically by Claude Code at the start of every session in this
repository. It captures the conventions established during initial development so they
are applied consistently going forward.

---

## Project Goal

Hands-on CompTIA A+ Core 2 (220-1202) troubleshooting labs designed to run inside
Hyper-V VMs (also compatible with VMware and VirtualBox). Each lab simulates a real
Help Desk ticket:

1. `break.ps1` — injects a misconfiguration silently
2. `case-file.md` — presents the scenario as a user-submitted ticket (no spoilers)
3. Technician investigates and resolves the issue
4. `restore.ps1` — reverts all changes back to original state

Labs map to official Core 2 exam objectives and include a `README.md` with a
collapsible solution walkthrough.

---

## Required Lab Structure

Every lab folder under `labs/` must contain all five files:

```
labs/lab-XX-name/
├── README.md          ← lab guide, objectives map, solution walkthrough (collapsible)
├── break.ps1          ← injects the fault; saves original state to JSON
├── restore.ps1        ← reads JSON, restores original state, deletes JSON
├── case-file.md       ← help desk ticket (no spoilers, includes red herrings)
└── example-ticket.md  ← fully worked ticket write-up using templates/ticket-template.md
```

New labs should be built by copying `labs/_template/` and filling in the TODOs.

---

## PowerShell Coding Conventions (break.ps1 / restore.ps1)

```powershell
#Requires -RunAsAdministrator          # always first — exits cleanly if not elevated

$ErrorActionPreference = 'Stop'        # turn all errors into terminating errors
$backupFile = "$PSScriptRoot\original-*.json"  # use $PSScriptRoot, never hardcode paths
```

### State management

- **Before any change**, save original state to a JSON file in the lab folder.
- `break.ps1` must check whether the JSON already exists and refuse to run if it does
  (idempotency guard — prevents double-break).
- `restore.ps1` must check whether the JSON exists and exit with a clear error if not.
- `restore.ps1` must delete the JSON after a successful restore.

### Output color convention

| Color   | Use                            |
|---------|--------------------------------|
| Yellow  | Section start / "working on…"  |
| Cyan    | Individual status steps        |
| Green   | Success / completion           |
| Red     | Errors and warnings            |

---

## Network Adapter Detection Rules

**Bug fixed in Lab 01** — use this exact pattern in every lab that touches adapters.

```powershell
$virtualPattern     = 'WSL|VirtualBox|VMware|Loopback|isatap|Teredo|6to4|Pseudo'
$physicalMediaTypes = '802.3', 'Native 802.11'

$adapter = Get-NetAdapter | Where-Object {
    $_.Status -eq 'Up' -and
    $_.InterfaceDescription -notmatch $virtualPattern -and
    $_.Name -notmatch $virtualPattern -and
    $_.MediaType -in $physicalMediaTypes
} | Select-Object -First 1
```

**Rules:**
- Filter on `MediaType` (`802.3` = Ethernet, `Native 802.11` = Wi-Fi). ✅
- Do **NOT** filter on `PhysicalMediaType` — it reports `Unspecified` for both
  virtual NICs and real synthetic adapters inside Hyper-V VMs, causing false negatives. ❌
- `Hyper-V` is **intentionally absent** from `$virtualPattern`. Inside a Hyper-V VM,
  "Microsoft Hyper-V Network Adapter" is the real guest NIC and must pass the filter.

---

## Commit Message Conventions

This repo uses [Conventional Commits](https://www.conventionalcommits.org/):

| Prefix | When to use |
|--------|-------------|
| `feat(lab-XX):` | New lab fully built |
| `fix(lab-XX):` | Bug fix in a specific lab |
| `docs:` | Documentation-only changes |
| `refactor:` | Non-functional code changes |

---

## Workflow Rules

When working with the user in this repo, always follow these rules:

1. **Read before writing** — read existing files before proposing changes to them.
2. **Show diffs first** — present proposed changes as diffs before applying any file.
3. **Ask permission per file** — do not batch-apply multiple files without individual approval.
4. **Never push without an explicit instruction** — wait for the user to say "push it"
   before running `git push`. A commit approval does not imply push approval.
5. **Use the ticket template** — when creating any `example-ticket.md`, follow the
   structure defined in `templates/ticket-template.md`.
