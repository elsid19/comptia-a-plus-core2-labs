# Ticket: Print Spooler Service Failure — HD-2026-0205

**Resolved by:** [Your name]  
**Date:** 2026-05-25  
**User:** James Okafor, Accounts Payable

---

### SYMPTOMS

- Cannot print to either available printer: shared network colour printer
  (`\\CORP-PRINT-01\HP-Color`) and desk USB HP LaserJet both affected
- Clicking Print in Word and in Chrome produces no output and no error dialog —
  the job silently disappears
- Print queue appears empty; one job from earlier this morning is stuck and
  cannot be cancelled (right-click → Cancel has no effect)
- Received exact error when attempting to add a second USB printer:
  "Windows cannot connect to the printer. The local print spooler service is
  not running. Please restart the spooler or restart the machine."
- Rebooted twice — problem returns after each login
- Colleagues on the same floor print without issue

---

### DIAGNOSIS

Two leads were investigated and eliminated before the root cause was confirmed.

The Windows Update lead was ruled out first: the update ran two nights ago, but
James printed without issue for the entire following day. An update that breaks
printing does so immediately; a one-day delay is not consistent with update
causation.

The HP Universal Print Driver lead was ruled out next: the driver was installed
last week, and James printed normally for several days after installation. More
decisively, both the network printer and the local USB printer are affected. A
driver issue is always specific to the printer it serves — a single bad driver
cannot simultaneously disable two printers that use separate drivers.

The error message James reported when attempting to add a printer named the
service layer directly. This shifted the investigation from hardware and drivers
to Windows services. `Get-Service -Name Spooler` confirmed the primary finding:
`Status: Stopped`. The spooler is the single Windows component that handles all
print jobs for all printers — stopped means nothing prints, from any app, to any
device.

The critical secondary finding was the startup type. `Get-Service -Name Spooler |
Select-Object Name, Status, StartType` returned `StartType: Manual`. A service
set to Manual does not start automatically when Windows boots. This is why two
reboots failed to restore printing — the service was never running after login.
Starting the service alone would be insufficient; without restoring the startup
type to Automatic, the next reboot would re-open the same ticket.

The stuck print job from this morning is consistent with this timeline: it was
accepted by the spooler before the service went down and is now queued but
unprocessable. It will clear automatically once the spooler is running again.

---

### EVIDENCE

- `Get-Service -Name Spooler | Select-Object Name, Status, StartType` before fix:
  `Name: Spooler, Status: Stopped, StartType: Manual`
- services.msc observation: Print Spooler row shows blank Status column (stopped)
  and "Manual" in the Startup Type column
- Exact error text from add-printer dialog: "Windows cannot connect to the
  printer. The local print spooler service is not running. Please restart the
  spooler or restart the machine."
- Print queue observation: one job dated this morning, Status "Deleting",
  right-click Cancel unresponsive — consistent with spooler not running

---

### RESOLUTION

1. Opened **Run** (`Win + R`), typed `services.msc`, pressed Enter.
2. Located **Print Spooler** in the services list.
3. Right-clicked **Print Spooler** → **Start** to bring the service up.
4. Right-clicked **Print Spooler** → **Properties**.
5. Changed **Startup type** from **Manual** to **Automatic** → clicked **OK**.
6. Confirmed the Status column now shows **Running**.

PowerShell equivalent (for reference / remote remediation):
```powershell
Set-Service -Name Spooler -StartupType Automatic
Start-Service -Name Spooler
```

---

### VERIFICATION

- `Get-Service -Name Spooler | Select-Object Status, StartType` after fix:
  `Status: Running, StartType: Automatic`
- Sent a test print to `\\CORP-PRINT-01\HP-Color` — job processed and printed
- Sent a test print to the desk USB HP LaserJet — same result
- The stuck morning job cleared from the queue automatically once the spooler started
- Advised James to reboot and confirm printing still works after login — James
  confirmed via follow-up that printing resumed normally after restart
- James confirmed he was able to print the AP report he needed

---

### ROOT CAUSE / FOLLOW-UP

The cause of the Manual startup type is unknown. It is not attributable to the
Windows Update (printing worked the full day after the update) or the HP driver
install (printing worked for days after installation and both printers are
affected). Possible causes include a prior technician action, a software
installer that modified service configuration as a side effect, or an
unauthorised change.

**Recommendations:**

- Check Group Policy for any policy enforcing service startup types: `Computer
  Configuration → Windows Settings → Security Settings → System Services` — a
  policy setting Print Spooler to Manual would re-apply on every Group Policy
  refresh and cause this ticket to recur
- Run `Get-Service -Name Spooler | Select-Object MachineName, Status, StartType`
  across managed endpoints to identify other machines with a Manual startup type
  before they generate tickets
- Review **Event Viewer → Windows Logs → System**, filter for Source: Service
  Control Manager, Event IDs **7036** (service entered stopped state) and **7045**
  (new service installed) to establish when the startup type was last changed
- If an unauthorised change is suspected, review endpoint management logs for
  service configuration changes around the time the problem began
