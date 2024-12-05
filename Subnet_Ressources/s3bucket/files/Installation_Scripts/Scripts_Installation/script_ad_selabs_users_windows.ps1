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

if (-not(Test-Path "C:\s3-downloads\selabs_users\adusers_list_$DomainNetbiosName.csv"))
{
    New-Item -Path "C:\s3-downloads\" -Name "selabs_users" -ItemType "directory"
    Copy-Item -Path "C:\s3-downloads\Scripts_Installation\selabs_users\adusers_list_$DomainNetbiosName.csv" -Destination "C:\s3-downloads\selabs_users\adusers_list_$DomainNetbiosName.csv"
    # Path to the CSV file
    $csvPath = "C:\s3-downloads\selabs_users\adusers_list_$DomainNetbiosName.csv"
    # The distinguished name (DN) of the target OU
    # Check if the OU exists
    $ouPath = "OU=Lab-Users,DC=$DomainNetbiosName,DC=$DomainExt"
    $ou = Get-ADOrganizationalUnit -Filter { DistinguishedName -eq $ouPath } -ErrorAction SilentlyContinue
    if ($ou -eq $null) {
        # OU does not exist, so create it
        New-ADOrganizationalUnit -Name "Lab-Users" -Path "DC=$DomainNetbiosName,DC=$DomainExt"
        Write-Host "OU Lab-Users created successfully."
    } else {
        Write-Host "OU Lab-Users already exists."
    }
} else {
    Write-Log -Message "SELABS OU already installed"
}
# Import the CSV file
$users = Import-Csv -Path $csvPath
# Iterate over each user in the CSV file
foreach ($user in $users) {
    $firstName = $user.firstname
    $lastName = $user.lastname
    $email = $user.useremail
    $username = "$firstName.$lastName"
    # Create a new user in Active Directory
    try {
        New-ADUser -GivenName $firstName -Surname $lastName -EmailAddress $email -Name "$firstName $lastName" -UserPrincipalName "$email" -SamAccountName $username -Path $ouPath -AccountPassword (ConvertTo-SecureString "$idr_service_account_pwd" -AsPlainText -Force) -Enabled $true
        Write-Host "Successfully created user: $firstName $lastName"
    } catch {
        Write-Error "Failed to create user: $firstName $lastName"
    }
}
#The distinguished name (DN) of the target OU
$ouPath = "CN=Computers,DC=$DomainNetbiosName,DC=$DomainExt"
#Import the CSV file
$computers = Import-Csv -Path $csvPath
#Iterate over each computer in the CSV file
foreach ($computer in $computers) {
if ($computer.AssetTypeFamily -eq "Windows") {
    $computerName = $computer.userworkstation
    $user = $computer.nameuser
    $operatingSystem = $computer.AssetTypeProduct

    # Create a new computer account in Active Directory
    try {
        New-ADComputer -Name $computerName -SamAccountName $computerName -Path $ouPath -Description "Computer for $user" -OperatingSystem $operatingSystem -Enabled $true
        Write-Host "Successfully created computer: $computerName"
    } catch {
        Write-Error "Failed to create computer: $computerName"
    }
} else {
    Write-Host "Skipping non-Windows computer: $($computer.userworkstation)"
}
}
