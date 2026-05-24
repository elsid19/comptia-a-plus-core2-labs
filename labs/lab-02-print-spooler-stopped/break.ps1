# break.ps1 — Lab 02: Print Spooler Stopped
# Stops the Print Spooler service and changes its startup type to Manual,
# simulating the fault the technician must diagnose and fully resolve.
#
# The print queue folder is intentionally left untouched — any stuck jobs
# already present are part of the diagnostic puzzle.
#
# IMPORTANT: Run this inside a VM with a snapshot taken first.
# Requires administrator privileges.

#Requires -RunAsAdministrator

$ErrorActionPreference = 'Stop'
$labName    = 'Lab 02 — Print Spooler Stopped'
$backupFile = "$PSScriptRoot\original-spooler-config.json"

Write-Host "`n[$labName] Starting break sequence..." -ForegroundColor Yellow

# --- Guard: don't run if a backup already exists (break already applied) ---
if (Test-Path $backupFile) {
    Write-Host "WARNING: $backupFile already exists." -ForegroundColor Red
    Write-Host "Run restore.ps1 before applying the break again." -ForegroundColor Red
    exit 1
}

# --- Query current Spooler service state before making any changes ---
$svc = Get-Service -Name Spooler

Write-Host "  Spooler current state — Status: $($svc.Status), StartupType: $($svc.StartType)" -ForegroundColor Cyan

# --- Save original state so restore.ps1 can undo this exactly ---
$original = @{
    ServiceName         = 'Spooler'
    OriginalStatus      = $svc.Status.ToString()
    OriginalStartupType = $svc.StartType.ToString()
}

$original | ConvertTo-Json | Set-Content -Path $backupFile -Encoding UTF8
Write-Host "  Original state saved to: $backupFile" -ForegroundColor Cyan

# --- Apply the fault: stop the service ---
Stop-Service -Name Spooler -Force
Write-Host "  Spooler service stopped." -ForegroundColor Cyan

# --- Apply the fault: change startup type so it stays stopped after reboot ---
Set-Service -Name Spooler -StartupType Manual
Write-Host "  Spooler startup type set to: Manual" -ForegroundColor Cyan

Write-Host "`n[$labName] Break applied." -ForegroundColor Green
Write-Host "See case-file.md for the help desk ticket.`n" -ForegroundColor Green
