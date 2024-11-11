# PowerShell Equivalent for ssh_verify.sh

Write-Output "Starting SSH configuration verification and fixing..."

# Check if SSH Server is installed
if (!(Get-WindowsCapability -Online | Where-Object Name -like "OpenSSH.Server*").State -eq "Installed") {
    Write-Output "⚠️  WARNING: SSH Server is not installed on this system. Installing OpenSSH Server..."
    Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
}

# Define SSH configuration file path
$sshConfigFile = "$env:ProgramData\\ssh\\sshd_config"

# Function to set or fix configuration in sshd_config
function Set-Setting {
    param($Setting, $Value, $Description)
    if (Test-Path $sshConfigFile) {
        (Get-Content $sshConfigFile) -replace "(?m)^$Setting.*", "$Setting $Value" | Set-Content $sshConfigFile
        Write-Output "$Description set to $Value."
    }
}

# Disable root login, set protocol version, idle timeout, etc.
Set-Setting "PermitRootLogin" "no" "Root login disabled"
Set-Setting "Protocol" "2" "SSH protocol version set to 2"
Set-Setting "ClientAliveInterval" "300" "Idle session timeout (300 seconds)"
Set-Setting "ClientAliveCountMax" "0" "Max idle session count set to 0"
Set-Setting "PasswordAuthentication" "no" "Password-based authentication disabled"

# Restart SSH service to apply changes
Write-Output "Restarting SSH service to apply changes..."
Restart-Service -Name sshd

Write-Output "SSH configuration verification and fixing complete."
