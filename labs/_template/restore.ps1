# restore.ps1 — Lab XX: [Short Title]
# Restores the system to its pre-lab state.
#
# Requires administrator privileges.

#Requires -RunAsAdministrator

$ErrorActionPreference = 'Stop'
$labName = 'Lab XX — [Short Title]'
$backupFile = "$PSScriptRoot\original-[setting]-config.json"

Write-Host "`n[$labName] Restoring original state..." -ForegroundColor Yellow

# --- Check backup file exists ---
if (-not (Test-Path $backupFile)) {
    Write-Host "ERROR: Backup file not found at $backupFile" -ForegroundColor Red
    Write-Host "Was break.ps1 run first?" -ForegroundColor Red
    exit 1
}

# --- Read saved state ---
$original = Get-Content -Path $backupFile | ConvertFrom-Json

# --- Restore ---
# TODO: apply the original values back

# --- Verify / flush if needed ---
# TODO: any cache flush or service restart required

# --- Clean up backup file ---
Remove-Item -Path $backupFile -Force

Write-Host "[$labName] Restore complete. System returned to original state." -ForegroundColor Green
