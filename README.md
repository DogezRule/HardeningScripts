# HardeningScripts

This repository contains shell scripts for hardening an Ubuntu system by configuring security settings, managing users, and setting up firewalls.

## Scripts Overview

### 1. `firewall.sh`
This script configures and enables the Uncomplicated Firewall (UFW) on the system. It includes:
- Enabling the UFW firewall.
- Setting default rules to deny incoming connections and allow outgoing ones.
- Allowing SSH on the default port (port 22) (If wanted only).
- Asks if you want any more services enabled or disabled.
- Enabling logging for monitoring purposes.

### 2. `passwd.sh`
This script enhances password security on the system by configuring settings in `/etc/login.defs` and `/etc/pam.d/common-password`. It includes:
- Setting a minimum password length.
- Enforcing password expiration policies.
- Enabling password complexity requirements using `libpam-pwquality`.
- Locking accounts after a set number of failed login attempts.
- Removing the `nullok` option to prevent null (empty) passwords.

### 3. `ssh_verify.sh`
This script verifies and automatically fixes SSH configuration settings for better security. It includes:
- Ensuring that root login is disabled.
- Enforcing SSH protocol version 2.
- Setting an idle session timeout to log out inactive SSH sessions.
- Disabling password authentication to enforce key-based login only.
- Restarting the SSH service to apply any changes.

### 4. `user.sh`
This script checks the system’s users and compares them against expected lists of admin and regular users. It includes:
- Opening two files (`admin_temp.txt` and `users_temp.txt`) where the user can specify expected admin and regular users, one per line.
- Checking if each listed user exists on the system.
- Verifying if each user has the correct permissions (admin users in the `sudo` group, regular users without it).
- Notifying if there are discrepancies (e.g., a regular user with admin privileges or a missing user).

## How to Use

1. Clone this repository to your system.
2. Make each script executable with:
   ```bash
   chmod +x script_name.sh
