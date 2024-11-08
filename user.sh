#!/bin/bash

# Description: Verifies user accounts and their admin status based on input from two separate files.

echo "Starting user verification script..."

# Define paths for the temporary files
admin_file="admin_temp.txt"
users_file="users_temp.txt"

# Prompt to open the files in Nano
echo "Please enter the usernames in two separate files:"
echo "- Admin users: One username per line in $admin_file."
echo "- Regular users: One username per line in $users_file."
echo "Each file will now open for you to paste the lists. Save and close the files after pasting (Ctrl+O, Enter, then Ctrl+X in Nano)."

# Create and open the files in Nano
touch "$admin_file" "$users_file"
nano "$admin_file"
nano "$users_file"

# Read the files into arrays
mapfile -t expected_admin_users < "$admin_file"
mapfile -t expected_regular_users < "$users_file"

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
