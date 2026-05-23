# Lab 04 — Wrong Default Gateway (TODO)

## Scenario idea

A user reports they can't reach any websites or external servers, but they can access shared drives and printers on the local network with no issues. Their IP address and DNS look correct. The default gateway has been changed to a non-existent IP on the local subnet (e.g., 10.0.0.254 instead of 10.0.0.1), so traffic destined for outside the subnet has nowhere to go.

## Objectives covered

| Code | Description |
|------|-------------|
| 1.2  | Use the appropriate Microsoft command-line tool (ipconfig, ping, tracert) |
| 3.1  | Given a scenario, troubleshoot common Windows OS problems |

## Break approach

- Detect the active physical adapter (same virtual-filter logic as Lab 01).
- Save current IP configuration (IP, prefix length, gateway, DNS) to `original-gateway-config.json`.
- Remove the existing IP config and re-apply with the wrong gateway using `New-NetIPAddress` / `Set-NetIPAddress` and `Remove-NetRoute`.
- Note: this lab works best on a statically configured adapter or after setting a static IP in the VM; DHCP will overwrite on renewal.

## Restore approach

- Read `original-gateway-config.json`.
- Remove the bad route and restore the correct default gateway with `New-NetRoute`.
- If the IP was originally DHCP, use `Set-NetIPInterface` to switch back to DHCP.
- Remove the backup file.

## Red herring ideas for case-file.md

- User recently moved desks and reconnected the ethernet cable themselves.
- IT changed the router firmware last night (true, but unrelated).
- User can ping their own machine by hostname — which works because it's local.

## Exam connection

`tracert` is the key tool here — the first hop will be wrong or unreachable. This tests understanding of default gateway purpose and `ipconfig /all` interpretation, both core to 1.2 and 3.1.
