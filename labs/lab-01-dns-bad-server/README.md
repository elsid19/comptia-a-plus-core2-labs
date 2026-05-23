# Lab 01 — DNS Bad Server

**Difficulty:** Beginner  
**Estimated time:** 20–30 minutes  
**Requires admin:** Yes (to run break/restore scripts)

---

## Scenario

A user in the Marketing department reports that the internet is completely down on her machine. She can't reach any websites and her cloud apps won't load. Her colleague at the next desk has no issues. The Wi-Fi icon shows a normal connected state with no warning.

Read the full ticket in [`case-file.md`](case-file.md).

---

## Objectives mapped

| Code | Description |
|------|-------------|
| 1.2  | Use the appropriate Microsoft command-line tool |
| 3.1  | Given a scenario, troubleshoot common Windows OS problems |

---

## What you'll learn

- How to distinguish between network connectivity and name resolution failures
- How to use `ping`, `ipconfig`, and `nslookup` to isolate a DNS fault
- Where DNS settings live in Windows and how to read/change them
- Why a user can reach local resources but not the internet when DNS is broken
- The difference between DHCP-assigned DNS and manually configured DNS

---

## Prerequisites

- Windows 10 or 11 VM with a snapshot labeled **"Clean"**
- PowerShell 5.1 or later
- Administrator account in the VM

---

## How to run this lab

1. Revert your VM to the **"Clean"** snapshot.
2. Open PowerShell **as Administrator**.
3. `cd` to this lab folder.
4. Run `.\break.ps1` — this injects the fault and prints a confirmation.
5. Switch to (or stay as) a standard user and open `case-file.md`.
6. Work the ticket: investigate the reported symptoms using only tools a technician would normally use.
7. When you've identified and fixed the issue (or if you get stuck), expand the solution below.
8. Run `.\restore.ps1` as Administrator to reset DNS to its original state.
9. Verify the restore: open a browser and confirm websites load normally.

---

## Solution walkthrough

<details>
<summary>Spoilers — click to expand</summary>

### Root cause

The DNS server address on the active network adapter was manually set to `8.8.8.99` — an IP address that does not respond. When Windows can't reach the DNS server, it cannot resolve hostnames, so all URL-based traffic fails. However, traffic addressed directly by IP (like pinging the router or printing to a local printer by IP) still works fine because those requests never touch DNS.

### Why the symptoms fit

| Symptom | Explanation |
|---------|-------------|
| Wi-Fi icon shows connected | The adapter has a valid IP and gateway — the link is up |
| Websites fail | All URLs require DNS resolution — none can succeed |
| Local printer works | The printer is reached by IP, not hostname |
| Colleague unaffected | The bad DNS is set only on this machine, not via DHCP |
| Restart didn't help | DNS settings survive reboots |
| Windows Update is a red herring | Unrelated to DNS server configuration |

### Diagnostic steps

1. **Confirm the link is up:**
   ```powershell
   ipconfig /all
   ```
   Look for a valid IP, subnet, and gateway. Note the DNS server listed — if it shows `8.8.8.99`, that's your culprit.

2. **Test connectivity by IP (bypasses DNS):**
   ```powershell
   ping 8.8.8.8
   ```
   If this succeeds but the next step fails, DNS is the problem — not the network.

3. **Test name resolution:**
   ```powershell
   ping google.com
   ```
   Expected result: `Ping request could not find host google.com.`

4. **Confirm with nslookup:**
   ```powershell
   nslookup google.com
   ```
   This will time out or return a server failure, and will show `8.8.8.99` as the server being queried.

5. **Identify the fix:**
   The DNS server is wrong. Either set it back to automatic (DHCP) or enter a valid server such as `8.8.8.8`.

### Fix (manual)

**Via GUI:**
1. Open **Settings → Network & Internet → Wi-Fi (or Ethernet) → Hardware properties**
2. Click **Edit** next to DNS server assignment
3. Set to **Automatic (DHCP)** or enter `8.8.8.8` / `1.1.1.1`

**Via PowerShell:**
```powershell
# Reset to DHCP-provided DNS
Set-DnsClientServerAddress -InterfaceAlias "Wi-Fi" -ResetServerAddresses

# OR set a specific DNS manually
Set-DnsClientServerAddress -InterfaceAlias "Wi-Fi" -ServerAddresses "8.8.8.8","8.8.4.4"

# Flush the cache after changing
Clear-DnsClientCache
```

### What to remember for the exam

- **Ping by IP works, ping by name fails = DNS problem** — this is a classic A+ scenario.
- `ipconfig /all` shows the configured DNS servers; `nslookup` lets you query them interactively.
- `ipconfig /flushdns` clears the local DNS cache — useful after fixing DNS settings.
- DNS can be set per-adapter, independently of DHCP — a manually entered wrong DNS survives a reboot and a network reconnect.
- Always check whether the issue is isolated to one machine before assuming a network-wide problem.

</details>
