[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$DomainName,

    [Parameter(Mandatory=$true)]
    [string]$DomainNetBiosName,

    [Parameter(Mandatory=$true)]
    [string]$DomainMode,

    [Parameter(Mandatory=$true)]
    [string]$ForestMode,

    [Parameter(Mandatory=$true)]
    [string]$SafeModeAdministratorPassword
)

# Create New Forest, add Domain Controller
Import-Module ADDSDeployment

#Convert the SafeModeAdministratorPassword to a secureString
$SecuredSafeModeAdministratorPassword = ConvertTo-SecureString -String $SafeModeAdministratorPassword -AsPlainText -Force

Install-ADDSForest -CreateDnsDelegation:$false `
-DomainName $DomainName `
-DomainNetbiosName $DomainNetbiosName `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode $DomainMode `
-ForestMode $ForestMode `
-SafeModeAdministratorPassword $SecuredSafeModeAdministratorPassword `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true