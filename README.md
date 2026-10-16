# Active Directory User Provisioning Lab

## Project overview

This lab demonstrates **Active Directory administration and PowerShell automation** by creating organizational units and bulk-provisioning user accounts in a controlled Windows Server / Active Directory environment.

The repository contains two approaches:

- **`1_CREATE_USERS.ps1`** — creates accounts from a supplied `names.txt` list.
- **`Generate-Names-Create-Users.ps1`** — generates synthetic names and can create a large number of test accounts for lab-scale directory administration practice.

## Skills demonstrated

- Active Directory Domain Services (AD DS)
- PowerShell automation
- `New-ADUser`
- Organizational Unit administration
- bulk user provisioning
- account naming conventions
- secure temporary-password handling
- repeatable administrative workflows

## Repository layout

```text
Active-Directory-/
├── README.md
└── Active directory/
    ├── 1_CREATE_USERS.ps1
    ├── Generate-Names-Create-Users.ps1
    ├── names.txt
    └── gitignore.txt
```

## Script 1 — Create users from a name list

The script reads first/last names from `names.txt`, creates an `_USERS` OU if necessary, builds a username from the first initial plus surname, and provisions enabled AD users.

Before running it, an administrator is prompted for a **temporary password as a SecureString**. The script does not store a reusable plaintext password in source control.

### Requirements

- Windows Server joined to or hosting the target AD domain
- Active Directory PowerShell module
- privileges to create OUs and users
- run from the directory containing `names.txt`

```powershell
Import-Module ActiveDirectory
.\1_CREATE_USERS.ps1
```

## Script 2 — Generate synthetic lab accounts

The second script generates random synthetic first/last names and provisions test users into an `_EMPLOYEES` OU.

The default count is intentionally high for directory-scale practice. **Use a much smaller value first** and run only in a disposable lab domain.

## Security considerations

This repository is for **authorized lab use**.

Production identity workflows should additionally use:

- approved identity lifecycle processes
- unique initial credentials or controlled password delivery
- MFA where supported
- least-privilege delegated administration
- password expiration and rotation policies
- account ownership and manager attributes
- logging and change auditing
- joiner/mover/leaver controls
- idempotent provisioning and duplicate-account checks

## Portfolio takeaway

This project demonstrates the difference between manually creating directory users and using PowerShell to create a repeatable provisioning workflow. The scripts are intentionally small enough to inspect, troubleshoot, and extend with group membership, department attributes, RBAC assignments, and deprovisioning logic.
