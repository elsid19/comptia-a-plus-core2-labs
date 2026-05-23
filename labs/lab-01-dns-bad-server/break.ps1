# break.ps1 — Lab 01: DNS Bad Server
# Injects a misconfigured DNS server on the active physical network adapter.
#
# IMPORTANT: Run this inside a VM with a snapshot taken first.
# Requires administrator privileges.

#Requires -RunAsAdministrator

$ErrorActionPreference = 'Stop'
$labName  = 'Lab 01 — DNS Bad Server'
$backupFile = "$PSScriptRoot\original-dns-config.json"

Write-Host "`n[$labName] Starting break sequence..." -ForegroundColor Yellow

# --- Guard: don't run if a backup already exists (break already applied) ---
if (Test-Path $backupFile) {
    Write-Host "WARNING: $backupFile already exists." -ForegroundColor Red
    Write-Host "Run restore.ps1 before applying the break again." -ForegroundColor Red
    exit 1
}

# --- Detect active physical adapter (excludes WSL, Hyper-V, VMware, etc.) ---
$virtualPattern = 'Hyper-V|WSL|VirtualBox|VMware|Loopback|isatap|Teredo|6to4|Pseudo'

$adapter = Get-NetAdapter |
    Where-Object {
        $_.Status -eq 'Up' -and
        $_.InterfaceDescription -notmatch $virtualPattern -and
        $_.Name -notmatch $virtualPattern -and
        $_.PhysicalMediaType -ne 'Unspecified'
    } | Select-Object -First 1

if (-not $adapter) {
    Write-Host "ERROR: No active physical network adapter found. Connect to a network and try again." -ForegroundColor Red
    exit 1
}

Write-Host "  Adapter detected: $($adapter.InterfaceDescription)" -ForegroundColor Cyan

# --- Save original DNS settings so restore.ps1 can undo this exactly ---
$currentDns = Get-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -AddressFamily IPv4

$original = @{
    InterfaceIndex   = $adapter.ifIndex
    InterfaceAlias   = $adapter.Name
    ServerAddresses  = $currentDns.ServerAddresses   # empty array = DHCP-assigned
    IsAutomatic      = ($currentDns.ServerAddresses.Count -eq 0)
}

$original | ConvertTo-Json | Set-Content -Path $backupFile -Encoding UTF8
Write-Host "  Original DNS saved to: $backupFile" -ForegroundColor Cyan

# --- Apply the fault: set DNS to a non-existent server ---
Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ServerAddresses '8.8.8.99'
Write-Host "  DNS set to: 8.8.8.99 (non-existent server)" -ForegroundColor Cyan

# --- Flush DNS cache so the bad server takes effect immediately ---
Clear-DnsClientCache
Write-Host "  DNS cache flushed." -ForegroundColor Cyan

Write-Host "`n[$labName] Break applied." -ForegroundColor Green
Write-Host "See case-file.md for the help desk ticket.`n" -ForegroundColor Green
