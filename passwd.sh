#!/bin/bash

# Description: Enhances password security on Ubuntu by setting up password policies.

echo "Starting security configuration..."

# Set minimum password length to 12
echo "Setting minimum password length..."
sudo sed -i 's/^PASS_MIN_LEN.*/PASS_MIN_LEN    12/' /etc/login.defs

# Set password expiration to 20 days (maximum age)
echo "Setting password expiration to 20 days..."
sudo sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   20/' /etc/login.defs

# Set minimum password age to 2 days
echo "Setting minimum password age to 2 days..."
sudo sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   2/' /etc/login.defs

# Enforce password complexity requirements
echo "Enforcing password complexity..."
sudo apt-get install -y libpam-pwquality
sudo sed -i '/^password\s*requisite\s*pam_pwquality\.so/c\password requisite pam_pwquality.so retry=3 minlen=12 difok=4' /etc/pam.d/common-password

# Lock account after 5 failed login attempts
echo "Locking account after 5 failed login attempts..."
sudo sed -i '/^auth\s*required\s*pam_tally2\.so/c\auth required pam_tally2.so deny=5 unlock_time=900' /etc/pam.d/common-auth

# Ensure password history to avoid reuse
echo "Enforcing password history to prevent reuse..."
sudo sed -i '/^password\s*required\s*pam_unix\.so/c\password required pam_unix.so remember=5' /etc/pam.d/common-password

# Remove 'nullok' to prevent null passwords
echo "Removing 'nullok' option to prevent null passwords..."
sudo sed -i 's/nullok//g' /etc/pam.d/common-auth
sudo sed -i 's/nullok//g' /etc/pam.d/common-password

echo "Security configuration complete."
