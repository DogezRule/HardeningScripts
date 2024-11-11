# PowerShell Equivalent for firewall.sh

Write-Output "Starting firewall configuration..."

# Check if Firewall is Enabled
$firewallEnabled = (Get-NetFirewallProfile -Profile Domain, Public, Private).Enabled
if (-not ($firewallEnabled -contains $true)) {
    Write-Output "Firewall is not enabled on this system. Enabling firewall..."
    Set-NetFirewallProfile -Profile Domain, Public, Private -Enabled True
}

# Set default inbound and outbound rules
Write-Output "Setting default rules to block inbound and allow outbound connections..."
Set-NetFirewallProfile -Profile Domain, Public, Private -DefaultInboundAction Block -DefaultOutboundAction Allow

# Prompt to allow SSH
$allowSSH = Read-Host "Do you want to allow SSH on port 22? (y/n)"
if ($allowSSH -match "^[Yy]$") {
    Write-Output "Allowing SSH on port 22..."
    New-NetFirewallRule -DisplayName "Allow SSH" -Direction Inbound -Protocol TCP -LocalPort 22 -Action Allow
} else {
    Write-Output "SSH on port 22 will not be allowed."
}

# Display current firewall rules
Write-Output "Current firewall rules:"
# Display firewall rules excluding rules with generic or user-based names
Write-Output "Filtered firewall rules (excluding user/generic application rules):"
Get-NetFirewallRule | Where-Object { $_.DisplayName -notmatch "user|application|default" } | Format-Table -Property DisplayName, Direction, Action, Enabled, Profile, LocalPort -AutoSize


# Prompt to add or remove rules
do {
    $action = Read-Host "Would you like to add or remove a port or service? (add/remove/exit)"
    if ($action -eq "add") {
        $port = Read-Host "Enter the port number or service name you want to allow:"
        New-NetFirewallRule -DisplayName "Allow $port" -Direction Inbound -Protocol TCP -LocalPort $port -Action Allow
        Write-Output "Allowed $port through the firewall."
    } elseif ($action -eq "remove") {
        $port = Read-Host "Enter the port number or service name you want to block:"
        New-NetFirewallRule -DisplayName "Block $port" -Direction Inbound -Protocol TCP -LocalPort $port -Action Block
        Write-Output "Blocked $port from the firewall."
    }
} while ($action -ne "exit")

Write-Output "Firewall configuration complete."
