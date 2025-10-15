<#
.SYNOPSIS
  Blocks or removes ICMP Timestamp Request (Type 13) and Timestamp Reply (Type 14) on Windows Server 2019.

.DESCRIPTION
  This script remediates the “ICMP Timestamp Request Remote Date Disclosure” vulnerability (Plugin ID 10114)
  by blocking inbound and outbound ICMP messages of types 13 and 14 using Windows Advanced Firewall.

  It creates two firewall rules:
   - Block inbound ICMP Type 13 (Timestamp Request)
   - Block outbound ICMP Type 14 (Timestamp Reply)

  The rules persist across reboots. Use the -Revert switch to remove them.

.PARAMETER Revert
  Optional switch. If specified, the script will remove the ICMP Timestamp firewall rules instead of applying them.

.AUTHOR
  Danny Cologero

.DATE CREATED
  10-15-2025

.VERSION
  1.1

.HOW TO USE
1. Open PowerShell as Administrator.
2. Navigate to the folder containing this script:
     cd "C:\Users\danny\Desktop"
3. To apply the remediation (block ICMP timestamp):
     .\remediation-icmp-timestamp.ps1
4. To remove the rules (revert):
     .\remediation-icmp-timestamp.ps1 -Revert

.VERIFICATION
1. Check applied rules in PowerShell:
     Get-NetFirewallRule | findstr Timestamp
2. Confirm the rules block traffic from another host:
     nmap -sO -p 13,14 <server-ip>
     (ICMP Type 13 & 14 should be filtered)
     Note: You may get error if FW or NSG is blocking Ping: "Host seems down. If it is really up, but blocking our ping probes, try -Pn"
      # nmap -sO -Pn -p 13,14 <host-ip>
3. Rules persist across reboots; check again after restart.

.NOTES
  Requires: Windows Server 2019 Datacenter (Build 1809), PowerShell 5.1.17763.7786
  Administrative privileges required to run.
#>

param(
    [switch]$Revert
)

# Requires administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "[ERROR] Please run this script as Administrator." -ForegroundColor Red
    exit 1
}

function Info ($msg)  { Write-Host "[INFO]  $msg" -ForegroundColor Cyan }
function Warn ($msg)  { Write-Host "[WARN]  $msg" -ForegroundColor Yellow }
function ErrorExit ($msg) { Write-Host "[ERROR] $msg" -ForegroundColor Red; exit 1 }

# Rule names
$ruleInName  = "Block ICMP Timestamp Request (Type 13) - Inbound"
$ruleOutName = "Block ICMP Timestamp Reply (Type 14) - Outbound"

if ($Revert) {
    Info "Reverting ICMP Timestamp firewall rules..."

    if (Get-NetFirewallRule -DisplayName $ruleInName -ErrorAction SilentlyContinue) {
        Info "Removing inbound rule..."
        Remove-NetFirewallRule -DisplayName $ruleInName
    } else {
        Warn "Inbound rule not found; nothing to remove."
    }

    if (Get-NetFirewallRule -DisplayName $ruleOutName -ErrorAction SilentlyContinue) {
        Info "Removing outbound rule..."
        Remove-NetFirewallRule -DisplayName $ruleOutName
    } else {
        Warn "Outbound rule not found; nothing to remove."
    }

    Info "Revert complete."
    exit 0
}

# Normal remediation path
Info "Starting ICMP Timestamp remediation..."

# Remove existing rules first (idempotent)
if (Get-NetFirewallRule -DisplayName $ruleInName -ErrorAction SilentlyContinue) {
    Info "Existing inbound rule found; removing old rule."
    Remove-NetFirewallRule -DisplayName $ruleInName
}
if (Get-NetFirewallRule -DisplayName $ruleOutName -ErrorAction SilentlyContinue) {
    Info "Existing outbound rule found; removing old rule."
    Remove-NetFirewallRule -DisplayName $ruleOutName
}

# Create inbound rule for ICMP type 13 (timestamp-request)
Info "Creating inbound rule to block ICMP type 13 (Timestamp Request)..."
New-NetFirewallRule -DisplayName $ruleInName `
    -Direction Inbound `
    -Protocol ICMPv4 `
    -IcmpType 13 `
    -Action Block `
    -Profile Any `
    -Description "Blocks ICMP Timestamp Request (type 13) to prevent remote system clock disclosure."

# Create outbound rule for ICMP type 14 (timestamp-reply)
Info "Creating outbound rule to block ICMP type 14 (Timestamp Reply)..."
New-NetFirewallRule -DisplayName $ruleOutName `
    -Direction Outbound `
    -Protocol ICMPv4 `
    -IcmpType 14 `
    -Action Block `
    -Profile Any `
    -Description "Blocks ICMP Timestamp Reply (type 14) to prevent remote system clock disclosure."

# Confirm rule creation
Info "Confirming applied rules..."
Get-NetFirewallRule -DisplayName "*Timestamp*" | Format-Table -AutoSize -Property DisplayName, Direction, Action, Enabled

Info "Remediation complete. ICMP Timestamp Requests/Replies are now blocked."

Write-Host "`nTo verify:" -ForegroundColor Cyan
Write-Host "  1. Run: 'Get-NetFirewallRule | findstr Timestamp'"
Write-Host "  2. From another host, run: 'nmap -sO -p 13,14 <your-server-ip>' (should show filtered)"
Write-Host "  3. Rules persist automatically across reboots."
Write-Host "`nTo remove rules, run: '.\remediation-icmp-timestamp.ps1 -Revert'"
