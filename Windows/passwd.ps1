# PowerShell Equivalent for passwd.sh

Write-Output "Starting password security configuration..."

# Set minimum password length, expiration, and complexity through Local Security Policy
$seceditFile = "C:\\Windows\\Temp\\secedit.inf"
$seceditContent = @"
[System Access]
MinimumPasswordLength = 12
MaximumPasswordAge = 20
PasswordComplexity = 1
PasswordHistorySize = 5
LockoutBadCount = 5
LockoutDuration = 15
"@
$seceditContent | Out-File -FilePath $seceditFile -Encoding ASCII

# Apply the security settings
Write-Output "Applying password policy settings..."
secedit /configure /db secedit.sdb /cfg $seceditFile /overwrite

Write-Output "Password policy configuration complete."
