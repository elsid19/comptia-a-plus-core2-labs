# restore.ps1 — Lab 01: DNS Bad Server
# Restores the original DNS configuration saved by break.ps1.
# Works on any hypervisor (Hyper-V, VMware, VirtualBox) — no adapter detection here,
# all state is read from original-dns-config.json written by break.ps1.
#
# Requires administrator privileges.

#Requires -RunAsAdministrator

$ErrorActionPreference = 'Stop'
$labName    = 'Lab 01 — DNS Bad Server'
$backupFile = "$PSScriptRoot\original-dns-config.json"

Write-Host "`n[$labName] Starting restore sequence..." -ForegroundColor Yellow

# --- Verify backup file exists ---
if (-not (Test-Path $backupFile)) {
    Write-Host "ERROR: Backup file not found: $backupFile" -ForegroundColor Red
    Write-Host "Was break.ps1 run first?" -ForegroundColor Red
    exit 1
}

# --- Load original DNS settings ---
$original = Get-Content -Path $backupFile -Raw | ConvertFrom-Json

Write-Host "  Restoring adapter: $($original.InterfaceAlias)" -ForegroundColor Cyan

# --- Restore: DHCP-automatic or static, depending on what was saved ---
if ($original.IsAutomatic) {
    # DNS was obtained automatically via DHCP — reset to that state
    Set-DnsClientServerAddress -InterfaceIndex $original.InterfaceIndex -ResetServerAddresses
    Write-Host "  DNS restored to: automatic (DHCP)" -ForegroundColor Cyan
} else {
    # DNS was manually configured — restore the original addresses
    Set-DnsClientServerAddress -InterfaceIndex $original.InterfaceIndex `
        -ServerAddresses $original.ServerAddresses
    Write-Host "  DNS restored to: $($original.ServerAddresses -join ', ')" -ForegroundColor Cyan
}

# --- Flush DNS cache to clear the bad entries ---
Clear-DnsClientCache
Write-Host "  DNS cache flushed." -ForegroundColor Cyan

# --- Remove backup file ---
Remove-Item -Path $backupFile -Force
Write-Host "  Backup file removed." -ForegroundColor Cyan

Write-Host "`n[$labName] Restore complete. System returned to original state.`n" -ForegroundColor Green
