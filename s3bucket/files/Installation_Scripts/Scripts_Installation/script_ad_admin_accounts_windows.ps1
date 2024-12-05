param(
  [Parameter(Mandatory = $false)]
  [string] $R7_Region,
  [Parameter(Mandatory = $false)]
  [string] $AWS_Region,
  [Parameter(Mandatory = $false)]
  [string] $ServerName,
  [Parameter(Mandatory = $false)]
  [string] $AD_IP,
  [Parameter(Mandatory = $false)]
  [string] $TimeZoneID,
  [Parameter(Mandatory = $false)]
  [string] $Bucket_Name,
  [Parameter(Mandatory = $false)]
  [string] $DatabasePath,
  [Parameter(Mandatory = $false)]
  [string] $ZoneName,
  [Parameter(Mandatory = $false)]
  [string] $ZoneNameNetbiosName,
  [Parameter(Mandatory = $false)]
  [string] $ZoneNameExt,
  [Parameter(Mandatory = $false)]
  [string] $DomainName,
  [Parameter(Mandatory = $false)]
  [string] $DomainNetbiosName,
  [Parameter(Mandatory = $false)]
  [string] $DomainExt,
  [Parameter(Mandatory = $false)]
  [string] $ForestMode,
  [Parameter(Mandatory = $false)]
  [string] $DomainMode,
  [Parameter(Mandatory = $false)]
  [string] $SYSVOLPath,
  [Parameter(Mandatory = $false)]
  [string] $LogPath,
  [Parameter(Mandatory = $false)]
  [string] $Token,
  [Parameter(Mandatory = $false)]
  [string] $AdminUser,
  [Parameter(Mandatory = $false)]
  [string] $AdminPD,
  [Parameter(Mandatory = $false)]
  [string] $idr_service_account,
  [Parameter(Mandatory = $false)]
  [string] $idr_service_account_pwd,
  [Parameter(Mandatory = $false)]
  [string] $AdminSafeModePassword,
  [Parameter(Mandatory = $false)]
  [string] $SecureAdminSafeModePassword,
  [Parameter(Mandatory = $false)]
  [string] $VR_Agent_File,
  [Parameter(Mandatory = $false)]
  [string] $Instance_IP1,
  [Parameter(Mandatory = $false)]
  [string] $Instance_IP2,
  [Parameter(Mandatory = $false)]
  [string] $Instance_Mask,
  [Parameter(Mandatory = $false)]
  [string] $Instance_GW,
  [Parameter(Mandatory = $false)]
  [string] $Instance_AWSGW,
  [Parameter(Mandatory = $false)]
  [string] $Agent_Type,
  [Parameter(Mandatory = $false)]
  [string] $SEOPS_VR_Install,
  [Parameter(Mandatory = $false)]
  [string] $Coll_IP,
  [Parameter(Mandatory = $false)]
  [string] $Orch_IP,
  [Parameter(Mandatory = $false)]
  [string] $mycreds,
  [Parameter(Mandatory = $false)]
  [string] $SiteName,
  [Parameter(Mandatory = $false)]
  [string] $SiteName_RODC,
  [Parameter(Mandatory = $false)]
  [string] $RODCServerName,
  [Parameter(Mandatory = $false)]
  [string] $RODC_IP,
  [Parameter(Mandatory = $false)]
  [string] $User_Account,
  [Parameter(Mandatory = $false)]
  [string] $Keyboard_Layout,
  [Parameter(Mandatory = $false)]
  [string] $Routing_Type,
  [Parameter(Mandatory = $false)]
  [string] $Username,
  [Parameter(Mandatory = $false)]
  [string] $Deployment_Mode,
  [Parameter(Mandatory = $false)]
  [string] $User_Lists,
  [Parameter(Mandatory = $false)]
  [string] $VRM_License_Key,
  [Parameter(Mandatory = $false)]
  [string] $Scenario,
  [Parameter(Mandatory = $false)]
  [string] $PhishingName
)

function Write-Log {
  [CmdletBinding()]
  param(
      [Parameter()]
      [ValidateNotNullOrEmpty()]
      [string]$Message
  )
  [pscustomobject]@{
      Time = (Get-Date -f g)
      Message = $Message
  } | Export-Csv -Path "c:\UserDataLog\UserDataLogFile.log" -Append -NoTypeInformation
}
Set-ExecutionPolicy Bypass -Scope Process -Force

if (!(Get-ADUser -Filter "sAMAccountName -eq '$AdminUser'")) {
    Write-Log -Message "User $AdminUser does not exist."
    Write-Log -Message "Creating $AdminUser and adding to Domain Admins Group."
    New-ADUser -Name "$AdminUser" -SamAccountName "$AdminUser" -AccountPassword(ConvertTo-SecureString "$AdminPD" -AsPlainText -force) -Enabled $true
    Add-ADGroupMember -Identity "Domain Admins" -Members $AdminUser
    Add-ADGroupMember -Identity "Remote Desktop Users" -Members $AdminUser 
    Write-Log -Message "Modifying Administrator Password (Local+AD)"
    $password = ConvertTo-SecureString "$AdminPD" -AsPlainText -Force
    Set-LocalUser -Name Administrator -Password $password
    $NewPassword = ConvertTo-SecureString "$AdminPD" -AsPlainText -Force
    Set-ADAccountPassword -Identity Administrator -NewPassword $NewPassword -Reset
    net accounts /maxpwage:unlimited
    Set-ADDefaultDomainPasswordPolicy -Identity "$DomainName" -MaxPasswordAge 0  
} else {
    Write-Log -Message "User already exist."
}
if (!(Get-ADUser -Filter "sAMAccountName -eq '$idr_service_account'")) {
    Write-Log -Message "User $idr_service_account does not exist."
    Write-Log -Message "Creating $idr_service_account and adding to Domain Admins Group."
    New-ADUser -Name "$idr_service_account" -SamAccountName "$idr_service_account" -AccountPassword(ConvertTo-SecureString "$idr_service_account_pwd" -AsPlainText -force) -Enabled $true
    Add-ADGroupMember -Identity "Domain Admins" -Members $idr_service_account
    New-SmbShare -Name "dnslogs" -Path "C:\dnslogs\" -FullAccess "$idr_service_account"
    New-SmbShare -Name "dhcplogs" -Path "C:\dhcplogs\" -FullAccess "$idr_service_account"
    Write-Log -Message "Adding all users"
} else {
    Write-Log -Message "User already exist."
}

foreach ($user in $User_Lists.Split(',')) { 
    if (!(Get-ADUser -Filter "sAMAccountName -eq '$User'")) {
        Write-Log -Message "Adding User :  $User"
        New-ADUser -Name "$User" -SamAccountName "$User" -AccountPassword(ConvertTo-SecureString "$AdminPD" -AsPlainText -force) -Enabled $true
        Add-ADGroupMember -Identity "Remote Desktop Users" -Members $User
        Add-ADGroupMember -Identity "Domain Admins" -Members $User 
        Add-ADGroupMember -Identity "Administrators" -Members $User 
        Write-Log -Message "User :  $User added"
    }
    else {
        Write-Log -Message "User :  $User already in the Active Directory"
        Add-ADGroupMember -Identity "Remote Desktop Users" -Members $User
        Add-ADGroupMember -Identity "Domain Admins" -Members $User 
        Add-ADGroupMember -Identity "Administrators" -Members $User 
    }
}

#Add AdminUser
$op = Get-LocalUser | where-Object Name -eq "$AdminUser" | Measure
if ($op.Count -eq 0) {
    # Creating the user
    $password = ConvertTo-SecureString $AdminPD -AsPlainText -Force
    New-LocalUser -AccountNeverExpires:$true -Name $AdminUser -Password $password -FullName $AdminUser -Description $AdminUser
    Add-LocalGroupMember -Group Users -Member $AdminUser
    Add-LocalGroupMember -Group "Administrators" -Member $AdminUser  
    Add-LocalGroupMember -Group "Remote Desktop Users" -Member $AdminUser
    Write-Log -Message "The user $AdminUser will be created and added to Administrators and RDP Users."  
    net accounts /maxpwage:unlimited
} else {
    Write-Log -Message "The user $AdminUser already exist."  
    Add-LocalGroupMember -Group Users -Member $AdminUser
    Add-LocalGroupMember -Group "Administrators" -Member $AdminUser  
    Add-LocalGroupMember -Group "Remote Desktop Users" -Member $AdminUser
} 