<#
.SYNOPSIS
    Uninstalls any installed version of Wireshark from the system executing the script.
    Tested on multiple Wireshark versions.
    Please test thoroughly in a non-production environment before deploying widely.
    Make sure to run as Administrator or with appropriate privileges.

.NOTES
    Author        : Danny
    Date Created  : 10-15-2025
    Last Modified : 10-15-2025
    Version       : 1.2

.TESTED ON
    Date(s) Tested    : 10-15-2025
    Tested By         : Danny
    Systems Tested    : Windows Server 2019 Datacenter, Build 1809
    PowerShell Ver.   : 5.1.17763.7786

.USAGE
    Example syntax:
    PS C:\> .\remediation-wireshark-uninstall.ps1 
#>

# ----------------------------------------
# Ensure script is running as Administrator
# ----------------------------------------
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Please run this script as Administrator."
    exit
}

# ----------------------------------------
# Define Variables
# ----------------------------------------
$silentUninstallSwitch = "/S"
$logFolder = "$env:ProgramData\Wireshark_Uninstall_Logs"
$logFile = "$logFolder\Wireshark_Uninstall_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

# Ensure log folder exists
if (-not (Test-Path -Path $logFolder)) {
    New-Item -ItemType Directory -Path $logFolder -Force | Out-Null
}

Start-Transcript -Path $logFile

# ----------------------------------------
# Function: Detect Installed Wireshark Versions
# ----------------------------------------
function Get-WiresharkInstallPaths {
    $possiblePaths = @(
        "$env:ProgramFiles\Wireshark",
        "$env:ProgramFiles(x86)\Wireshark"
    )

    $installedPaths = @()

    foreach ($path in $possiblePaths) {
        if (Test-Path $path) {
            # Look for uninstall.exe in the folder
            $uninstaller = Join-Path $path "uninstall.exe"
            if (Test-Path $uninstaller) {
                # Use Get-Item for reliable version detection
                $version = (Get-Item $uninstaller).VersionInfo.ProductVersion
                $installedPaths += [PSCustomObject]@{
                    Path    = $uninstaller
                    Version = $version
                }
            }
        }
    }

    return $installedPaths
}

# ----------------------------------------
# Function: Uninstall Wireshark
# ----------------------------------------
function Uninstall-Wireshark {
    $installedWireshark = Get-WiresharkInstallPaths

    if ($installedWireshark.Count -eq 0) {
        Write-Output "No Wireshark installation found on this system."
        return
    }

    foreach ($install in $installedWireshark) {
        $displayName = "Wireshark $($install.Version)"
        Write-Output "Uninstalling $displayName..."

        try {
            & $install.Path $silentUninstallSwitch
            Write-Output "$displayName has been uninstalled successfully."
        }
        catch {
            # FIX: Use ${_} to avoid parser error
            Write-Error "Failed to uninstall $displayName: $($_)"
        }
    }
}

# ----------------------------------------
# Execute the Uninstall
# ----------------------------------------
Uninstall-Wireshark

Stop-Transcript

