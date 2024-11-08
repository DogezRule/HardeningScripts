#!/bin/bash

# Description: Configures and enables UFW with custom port/service rules.

echo "Starting firewall configuration..."

# Check if UFW is installed
if ! command -v ufw &> /dev/null; then
    echo "⚠️  WARNING: UFW is not installed on this system."
    echo "Please install UFW with: sudo apt install ufw"
    exit 1
fi

# Enable UFW
echo "Enabling UFW..."
sudo ufw enable

# Set default rules
echo "Setting default rules to deny incoming connections and allow outgoing..."
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Ask if the user wants to allow SSH on port 22
read -p "Do you want to allow SSH on port 22? (y/n): " allow_ssh
if [[ "$allow_ssh" =~ ^[Yy]$ ]]; then
    echo "Allowing SSH on port 22..."
    sudo ufw allow 22
else
    echo "SSH on port 22 will not be allowed."
fi

# Display current UFW status and rules
echo "Current UFW status and rules:"
sudo ufw status verbose

# Prompt user to add or remove rules
while true; do
    echo "Would you like to add or remove a port or service? (add/remove/exit)"
    read -r action
    if [[ "$action" == "add" ]]; then
        echo "Enter the port number or service name you want to allow:"
        read -r port
        sudo ufw allow "$port"
        echo "Allowed $port through the firewall."
    elif [[ "$action" == "remove" ]]; then
        echo "Enter the port number or service name you want to deny:"
        read -r port
        sudo ufw deny "$port"
        echo "Denied $port from the firewall."
    elif [[ "$action" == "exit" ]]; then
        echo "Exiting the configuration."
        break
    else
        echo "Invalid option. Please enter 'add', 'remove', or 'exit'."
    fi
done

# Enable logging
echo "Enabling UFW logging for monitoring purposes..."
sudo ufw logging on

echo "Firewall configuration complete."
sudo ufw status verbose
