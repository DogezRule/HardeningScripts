#!/bin/bash

# Description: Verifies and automatically fixes SSH configuration settings for security.

echo "Starting SSH configuration verification and fixing..."

# Check if SSH is installed
if ! command -v sshd &> /dev/null; then
    echo "⚠️  WARNING: SSH is not installed on this system."
    echo "Please install SSH with: sudo apt install openssh-server"
    exit 1
fi

# Path to SSH configuration file
ssh_config_file="/etc/ssh/sshd_config"

# Function to set or fix a configuration setting in sshd_config
function set_setting() {
    local setting="$1"
    local value="$2"
    local description="$3"
    
    # Add or update the configuration setting
    if grep -q "^$setting" "$ssh_config_file"; then
        sudo sed -i "s/^$setting.*/$setting $value/" "$ssh_config_file"
        echo "✓ $description set to $value."
    else
        echo "$setting $value" | sudo tee -a "$ssh_config_file" > /dev/null
        echo "✓ $description added and set to $value."
    fi
}

# Disable root login
set_setting "PermitRootLogin" "no" "Root login disabled"

# Ensure only SSH protocol 2 is allowed
set_setting "Protocol" "2" "SSH protocol version set to 2"

# Set idle timeout to 300 seconds (5 minutes)
set_setting "ClientAliveInterval" "300" "Idle session timeout (300 seconds)"
set_setting "ClientAliveCountMax" "0" "Max idle session count set to 0"

# Disable password authentication for key-based authentication only
set_setting "PasswordAuthentication" "no" "Password-based authentication disabled"

# Restart SSH service to apply changes
echo "Restarting SSH service to apply changes..."
sudo systemctl restart ssh

echo "SSH configuration verification and fixing complete."
