#!/bin/bash

# Description: Verifies user accounts and their admin status based on input.

echo "Starting user verification script..."

# Prompting for admin and regular users
read -p "Enter the expected admin users (separate with spaces): " -a expected_admin_users
read -p "Enter the expected regular users (separate with spaces): " -a expected_regular_users

# Function to check if a user exists on the system
function user_exists() {
    id "$1" &>/dev/null
    return $?
}

# Checking admin users
echo "Verifying admin users..."
for user in "${expected_admin_users[@]}"; do
    if user_exists "$user"; then
        if groups "$user" | grep -q '\bsudo\b'; then
            echo "✓ $user is correctly listed as an admin."
        else
            echo "⚠️  WARNING: $user exists but is not in the admin group."
        fi
    else
        echo "⚠️  WARNING: Admin user $user is not found on this machine."
    fi
done

# Checking regular users
echo "Verifying regular users..."
for user in "${expected_regular_users[@]}"; do
    if user_exists "$user"; then
        if groups "$user" | grep -q '\bsudo\b'; then
            echo "⚠️  WARNING: Regular user $user has admin privileges."
        else
            echo "✓ $user is correctly listed as a regular user."
        fi
    else
        echo "⚠️  WARNING: Regular user $user is not found on this machine."
    fi
done

echo "User verification complete."
