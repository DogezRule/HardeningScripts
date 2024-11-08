#!/bin/bash

# Description: Configures basic firewall settings on Ubuntu for enhanced security.

echo "Starting firewall configuration..."

# Enable UFW
echo "Installing UFW"
sudo apt install ufw -y

# Enable UFW
echo "Enabling UFW..."
sudo ufw enable

# Allow SSH on default port (22)
echo "Allowing SSH on port 22..."
sudo ufw allow 22

# Deny all other incoming connections by default
echo "Setting default rules to deny incoming connections..."
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Enable firewall logging for monitoring purposes
echo "Enabling UFW logging..."
sudo ufw logging on

# Display UFW status
echo "Firewall configuration complete. Current UFW status:"
sudo ufw status verbose
