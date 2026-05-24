# restore.ps1 — Lab 02: Print Spooler Stopped
# Restores the Print Spooler service to the state saved by break.ps1:
# startup type is restored first, then the service is started if it was
# originally running.
#
# Requires administrator privileges.

#Requires -RunAsAdministrator

$ErrorActionPreference = 'Stop'
$labName    = 'Lab 02 — Print Spooler Stopped'
$backupFile = "$PSScriptRoot\original-spooler-config.json"

Write-Host "`n[$labName] Starting restore sequence..." -ForegroundColor Yellow

# --- Verify backup file exists ---
if (-not (Test-Path $backupFile)) {
    Write-Host "ERROR: Backup file not found: $backupFile" -ForegroundColor Red
    Write-Host "Was break.ps1 run first?" -ForegroundColor Red
    exit 1
}

# --- Load original state ---
$original = Get-Content -Path $backupFile -Raw | ConvertFrom-Json

Write-Host "  Restoring Spooler — StartupType: $($original.OriginalStartupType), Status: $($original.OriginalStatus)" -ForegroundColor Cyan

# --- Restore startup type first so the service is correctly configured before starting ---
Set-Service -Name Spooler -StartupType $original.OriginalStartupType
Write-Host "  Startup type restored to: $($original.OriginalStartupType)" -ForegroundColor Cyan

# --- Start the service only if it was running when break.ps1 captured state ---
if ($original.OriginalStatus -eq 'Running') {
    Start-Service -Name Spooler
    Write-Host "  Spooler service started." -ForegroundColor Cyan
}

# --- Remove backup file ---
Remove-Item -Path $backupFile -Force
Write-Host "  Backup file removed." -ForegroundColor Cyan

Write-Host "`n[$labName] Restore complete. System returned to original state.`n" -ForegroundColor Green
