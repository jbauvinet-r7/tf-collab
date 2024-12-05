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
if (-not(Test-Path "C:\ADDS"))
{
    New-Item -Path "C:\" -Name "ADDS" -ItemType "directory"
    Write-Log -Message "Created ADDS folder to store log file."
} else {
    Write-Log -Message "ADDS Folder already exists."
}
Set-ExecutionPolicy Bypass -Scope Process -Force
$username = "$DomainNetbiosName\$idr_service_account" #user name with privileges to add a device to the $domain 
$password = "$idr_service_account_pwd" |ConvertTo-SecureString -asPlainText -Force #password for the above user  
$credential = New-object -TypeName System.Management.Automation.PSCredential -ArgumentList ($username, $password)  
$isInstalled = (Get-WindowsFeature AD-Domain-Services).installed
if ($isInstalled -ne "True") {
  Write-Log -Message "Windows feature (AD-Domain-Services) is not installed and will be installed."
  Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
} else {
  Write-Log -Message "Windows feature (AD-Domain-Services) is installed"
}
Start-Sleep -Seconds 120;
# Promote to DC only if not already installed or not a DC 
if ($isInstalled -eq "True" -or (Get-ADDomain).Count -eq 0) {
    # If not installed, install the role
    Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
    Import-Module ADDSDeployment 
    Install-ADDSDomainController -Credential $credential -NoGlobalCatalog:$false -CriticalReplicationOnly:$false -DatabasePath "$DatabasePath" -DomainName $DomainName -InstallDns:$true -LogPath "$LogPath" -SafeModeAdministratorPassword $password -NoRebootOnCompletion:$false -ReadOnlyReplica:$true -SiteName $SiteName -SysvolPath "$SYSVOLPath" -Force:$true 
    # Optionally, you can restart the server after installation
    #Restart-Computer -Force
    Write-Log -Message "AD-Domain-Services role installed successfully."
} else {
     Write-Log -Message "Domain Controller is already installed."
}
Start-Sleep -Seconds 5;
#Check Windows feature RSAT-AD-PowerShell
if ((Get-WindowsFeature RSAT-AD-PowerShell).installed -ne "True")
{
    Write-Log -Message "Windows feature (RSAT-AD-PowerShell) is not installed and will be installed."
    Install-WindowsFeature -Name RSAT-AD-PowerShell
} else
{
    Write-Log -Message "Windows feature (RSAT-AD-PowerShell) is already installed."
}
#Check Windows feature RSAT-AD-AdminCenter
if ((Get-WindowsFeature RSAT-AD-AdminCenter).installed -ne "True")
{
    Write-Log -Message "Windows feature (RSAT-AD-AdminCenter) is not installed and will be installed."
    Install-WindowsFeature -Name RSAT-AD-AdminCenter
} else
{
    Write-Log -Message "Windows feature (RSAT-AD-AdminCenter) is already installed."
}
Start-Sleep -Seconds 5;
#Check Windows feature RSAT-ADDS-Tools
if ((Get-WindowsFeature RSAT-ADDS-Tools).installed -ne "True")
{
    Write-Log -Message "Windows feature (RSAT-ADDS-Tools) is not installed and will be installed."
    Install-WindowsFeature -Name RSAT-ADDS-Tools
} else
{
    Write-Log -Message "Windows feature (RSAT-ADDS-Tools) is already installed."
}