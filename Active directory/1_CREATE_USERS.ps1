# Bulk-create Active Directory users from names.txt.
Import-Module ActiveDirectory

$USER_FIRST_LAST_LIST = Get-Content ".\names.txt"
$password = Read-Host "Enter a temporary password for the lab users" -AsSecureString

$ouName = "_USERS"
$domainDn = ([ADSI]"").distinguishedName
$ouDn = "OU=$ouName,$domainDn"

if (-not (Get-ADOrganizationalUnit -LDAPFilter "(ou=$ouName)" -SearchBase $domainDn -ErrorAction SilentlyContinue)) {
    New-ADOrganizationalUnit -Name $ouName -ProtectedFromAccidentalDeletion $false
}

foreach ($n in $USER_FIRST_LAST_LIST) {
    $parts = $n.Trim().Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)
    if ($parts.Count -lt 2) {
        Write-Warning "Skipping malformed name: $n"
        continue
    }

    $first = $parts[0].ToLower()
    $last = $parts[-1].ToLower()
    $username = "$($first.Substring(0,1))$last".ToLower()

    if (Get-ADUser -Filter "SamAccountName -eq '$username'" -ErrorAction SilentlyContinue) {
        Write-Warning "Skipping existing user: $username"
        continue
    }

    Write-Host "Creating user: $username" -ForegroundColor Cyan

    New-ADUser `
        -SamAccountName $username `
        -UserPrincipalName "$username@$((Get-ADDomain).DNSRoot)" `
        -AccountPassword $password `
        -GivenName $first `
        -Surname $last `
        -DisplayName "$first $last" `
        -Name $username `
        -EmployeeID $username `
        -ChangePasswordAtLogon $true `
        -PasswordNeverExpires $false `
        -Path $ouDn `
        -Enabled $true
}
