# PowerShell Equivalent for user.sh

Write-Output "Starting user verification script..."

# Prompt for admin and regular user file paths
$adminFile = "C:\\Windows\\Temp\\admin_users.txt"
$usersFile = "C:\\Windows\\Temp\\regular_users.txt"

# Check if admin users exist and belong to the Administrators group
Write-Output "Verifying admin users..."
if (Test-Path $adminFile) {
    foreach ($user in Get-Content $adminFile) {
        if (Get-LocalUser -Name $user -ErrorAction SilentlyContinue) {
            if ((Get-LocalGroupMember -Group Administrators | Where-Object Name -eq $user)) {
                Write-Output "$user is correctly listed as an admin."
            } else {
                Write-Output "⚠️  WARNING: $user exists but is not in the admin group."
            }
        } else {
            Write-Output "⚠️  WARNING: Admin user $user is not found on this machine."
        }
    }
}

# Check if regular users exist and do not have admin privileges
Write-Output "Verifying regular users..."
if (Test-Path $usersFile) {
    foreach ($user in Get-Content $usersFile) {
        if (Get-LocalUser -Name $user -ErrorAction SilentlyContinue) {
            if ((Get-LocalGroupMember -Group Administrators | Where-Object Name -eq $user)) {
                Write-Output "⚠️  WARNING: Regular user $user has admin privileges."
            } else {
                Write-Output "$user is correctly listed as a regular user."
            }
        } else {
            Write-Output "⚠️  WARNING: Regular user $user is not found on this machine."
        }
    }
}

Write-Output "User verification complete."
