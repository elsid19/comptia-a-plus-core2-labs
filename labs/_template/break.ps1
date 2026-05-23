# break.ps1 — Lab XX: [Short Title]
# Applies the fault condition for this lab.
#
# IMPORTANT: Run this inside a VM with a snapshot taken first.
# Requires administrator privileges.

#Requires -RunAsAdministrator

$ErrorActionPreference = 'Stop'
$labName = 'Lab XX — [Short Title]'
$backupFile = "$PSScriptRoot\original-[setting]-config.json"

Write-Host "`n[$labName] Applying break..." -ForegroundColor Yellow

# --- Save original state ---
# TODO: capture the setting you are about to change and write it to $backupFile
# Example:
# $original = @{ Setting = (Get-Something) }
# $original | ConvertTo-Json | Set-Content -Path $backupFile

# --- Apply the fault ---
# TODO: make the change that breaks the system

# --- Verify / flush if needed ---
# TODO: any cache flush or service restart required

Write-Host "[$labName] Break applied. Read case-file.md for the help desk ticket." -ForegroundColor Green
