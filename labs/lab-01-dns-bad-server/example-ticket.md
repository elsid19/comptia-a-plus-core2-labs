# Ticket: DNS Resolution Failure — HD-2026-0142

**Resolved by:** [Your name]
**Date:** 2026-05-23
**User:** Maria Chen, Marketing Department

---

### SYMPTOMS

- Unable to load any website in any browser (Chrome, Edge both tested)
- Microsoft Teams fails to connect; shows "We're having trouble connecting"
- SharePoint Online unreachable
- Wi-Fi icon shows a normal connected state — no warning triangle
- Colleague at adjacent desk has no connectivity issues on the same network
- Restarting the computer twice did not resolve the issue

---

### DIAGNOSIS

Network layer connectivity is intact. The adapter has a valid IP address, subnet
mask, and default gateway, and pinging an external IP (8.8.8.8) succeeds — confirming
the path to the internet is open. However, pinging any hostname fails immediately with
"Ping request could not find host." This is the classic pattern for a DNS resolution
failure: the physical and logical network work, but the system cannot translate names
to IP addresses.

Inspection of `ipconfig /all` revealed the DNS server was manually configured as
8.8.8.99 — an address that does not exist or respond. Because DNS is set per-adapter
and survives reboots, the two restarts the user attempted had no effect. The colleague's
machine was unaffected because DNS is not distributed by DHCP on this network — each
adapter's DNS was set individually at some point.

---

### EVIDENCE

- `ipconfig /all` — DNS Servers field shows `8.8.8.99`; flag "DHCP Enabled: No" confirms
  this is a static entry, not DHCP-assigned
- `ping 8.8.8.8` — 4/4 replies received; confirms internet path is up and the issue
  is not general connectivity
- `ping google.com` — fails: `Ping request could not find host google.com`
- `Resolve-DnsName google.com` — returns `DNS_ERROR_RCODE_SERVER_FAILURE`; server at
  8.8.8.99 is unreachable
- `nslookup google.com` — request times out; confirms 8.8.8.99 is not responding to
  DNS queries

---

### RESOLUTION

1. Opened **Settings → Network & Internet → Wi-Fi → Hardware properties**.
2. Clicked **Edit** next to "DNS server assignment."
3. Set DNS to **Automatic (DHCP)** — not to a static alternative like 8.8.8.8. The
   correct fix restores the intended automatic state; substituting a different static
   server would leave a manually managed entry that could cause future confusion.
4. Ran `ipconfig /flushdns` in PowerShell to clear stale cache entries that referenced
   8.8.8.99.
5. Confirmed `ipconfig /all` now shows DHCP-assigned DNS servers and "DHCP Enabled: Yes."

---

### VERIFICATION

- `ping google.com` — resolved successfully and received 4/4 replies
- `nslookup google.com` — returned correct A records from the DHCP-assigned DNS server
- Opened browser and confirmed google.com, sharepoint.company.com, and weather.com
  all load normally
- User (Maria Chen) verbally confirmed Teams connected and websites are accessible

---

### ROOT CAUSE / FOLLOW-UP

The cause of the original misconfiguration is unknown. The DNS server was manually
set to 8.8.8.99, which does not match any known public DNS service (Google's actual
public DNS is 8.8.8.8). It is unclear whether this was set accidentally, by a previous
technician, or as an unauthorized change.

**Recommendations:**

- Audit the DHCP scope options for this subnet to confirm correct DNS server addresses
  are being distributed and that "DHCP Enabled" is the expected state for workstations
- Review Group Policy settings (particularly `Computer Configuration → Windows Settings
  → Name Resolution Policy`) for any policy that could override adapter DNS settings
- Check whether any other machines on the same subnet have similarly unexpected static
  DNS entries (`Get-DnsClientServerAddress` across managed endpoints)
- If unauthorized changes are suspected, review Event Viewer and any endpoint management
  logs for changes made to network adapter settings around the time of the incident
