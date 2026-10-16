# Generate synthetic names and create lab-only Active Directory users.
Import-Module ActiveDirectory

$NUMBER_OF_ACCOUNTS_TO_CREATE = 10000
$password = Read-Host "Enter a temporary password for the lab users" -AsSecureString

function New-RandomName {
    $consonants = @('b','c','d','f','g','h','j','k','l','m','n','p','q','r','s','t','v','w','x','z')
    $vowels = @('a','e','i','o','u','y')
    $nameLength = Get-Random -Minimum 3 -Maximum 7
    $name = ""

    for ($i = 0; $i -lt $nameLength; $i++) {
        if (($i % 2) -eq 0) {
            $name += $consonants[(Get-Random -Minimum 0 -Maximum $consonants.Count)]
        }
        else {
            $name += $vowels[(Get-Random -Minimum 0 -Maximum $vowels.Count)]
        }
    }

    return $name
}

$ouName = "_EMPLOYEES"
$domainDn = ([ADSI]"").distinguishedName
$ouDn = "OU=$ouName,$domainDn"

if (-not (Get-ADOrganizationalUnit -LDAPFilter "(ou=$ouName)" -SearchBase $domainDn -ErrorAction SilentlyContinue)) {
    New-ADOrganizationalUnit -Name $ouName -ProtectedFromAccidentalDeletion $false
}

$count = 0
while ($count -lt $NUMBER_OF_ACCOUNTS_TO_CREATE) {
    $firstName = New-RandomName
    $lastName = New-RandomName
    $username = "$firstName.$lastName".ToLower()

    if (Get-ADUser -Filter "SamAccountName -eq '$username'" -ErrorAction SilentlyContinue) {
        continue
    }

    Write-Host "Creating user: $username" -ForegroundColor Cyan

    New-ADUser `
        -SamAccountName $username `
        -UserPrincipalName "$username@$((Get-ADDomain).DNSRoot)" `
        -AccountPassword $password `
        -GivenName $firstName `
        -Surname $lastName `
        -DisplayName "$firstName $lastName" `
        -Name $username `
        -EmployeeID $username `
        -ChangePasswordAtLogon $true `
        -PasswordNeverExpires $false `
        -Path $ouDn `
        -Enabled $true

    $count++
}
