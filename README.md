# CompTIA A+ Core 2 (220-1202) Hands-On Lab Repository

A personal learning portfolio of break/restore labs for the CompTIA A+ Core 2 exam. Each lab simulates a real-world help desk scenario: a fault is injected into a Windows VM via a PowerShell script, you work the ticket as a technician, then a restore script resets the system cleanly. Labs are mapped to official exam objectives so you can tie hands-on practice directly to what's tested.

---

## Exam Blueprint

| Domain | Topic | Weight |
|--------|-------|--------|
| 1 | Operating Systems | 28% |
| 2 | Security | 28% |
| 3 | Software Troubleshooting | 23% |
| 4 | Operational Procedures | 21% |

Full sub-objective breakdown: [`objectives/core2-blueprint.md`](objectives/core2-blueprint.md)

---

## Lab Index

| # | Lab | Domain(s) | Status |
|---|-----|-----------|--------|
| 01 | [DNS Bad Server](labs/lab-01-dns-bad-server/) | 1, 3 | ✅ Built |
| 02 | [Print Spooler Stopped](labs/lab-02-print-spooler-stopped/) | 1, 3 | 🚧 Scaffolded |
| 03 | [Account Disabled](labs/lab-03-account-disabled/) | 2, 3 | 🚧 Scaffolded |
| 04 | [Wrong Default Gateway](labs/lab-04-wrong-default-gateway/) | 1, 3 | 🚧 Scaffolded |
| 05 | [Suspicious Scheduled Task](labs/lab-05-suspicious-scheduled-task/) | 2, 3 | 🚧 Scaffolded |
| 06 | [UAC Disabled](labs/lab-06-uac-disabled/) | 2 | 🚧 Scaffolded |
| 07 | [Windows Firewall Off](labs/lab-07-windows-firewall-off/) | 2 | 🚧 Scaffolded |
| 08 | [BitLocker Suspended](labs/lab-08-bitlocker-suspended/) | 2 | 🚧 Scaffolded |
| 09 | [Event Log Cleared](labs/lab-09-event-log-cleared/) | 2, 4 | 🚧 Scaffolded |
| 10 | [Startup Program Malware Pattern](labs/lab-10-startup-program-malware-pattern/) | 2, 3 | 🚧 Scaffolded |

---

## How to Use This Repo

### Safety — read this first

> **All labs must be run inside a virtual machine.**
> Do not run `break.ps1` on your host machine or any production system.
> Take a VM snapshot labeled **"Clean"** before running any lab.
> If anything goes wrong, revert the snapshot — the VM is disposable, your host is not.

### Prerequisites

- Windows 10 or 11 VM (VirtualBox, VMware, or Hyper-V)
- PowerShell 5.1 or later (built into Windows)
- A standard user account and a separate administrator account in the VM
- VM snapshots enabled

### Workflow for each lab

1. Revert your VM to the **"Clean"** snapshot.
2. Open PowerShell **as Administrator**.
3. Navigate to the lab folder: `cd labs\lab-XX-name`
4. Run `.\break.ps1` — this injects the fault.
5. Switch to a standard user session if the lab requires it.
6. Open `case-file.md` and work the ticket as if it were real.
7. Investigate and resolve without looking at the solution.
8. When done (or if stuck), expand the **Solution walkthrough** in the lab's `README.md`.
9. Run `.\restore.ps1` (as Administrator) to reset the system.
10. Verify everything is back to normal before moving to the next lab.

---

## Repository Structure

```
comptia-a-plus-core2-labs/
├── README.md                  ← you are here
├── .gitignore
├── LICENSE
├── objectives/
│   └── core2-blueprint.md     ← full exam domain breakdown
├── labs/
│   ├── _template/             ← copy this when building new labs
│   └── lab-XX-name/
│       ├── README.md          ← lab guide + spoiler walkthrough
│       ├── break.ps1          ← injects the fault
│       ├── restore.ps1        ← resets the system
│       └── case-file.md       ← the help desk ticket
├── questions/                 ← practice questions (coming soon)
└── flashcards/                ← term/definition sets (coming soon)
```

---

## Contributing

This is a personal learning portfolio built while studying for the CompTIA A+ Core 2 exam. It is public for reference and inspiration — pull requests are not expected, but feel free to fork it for your own study.
