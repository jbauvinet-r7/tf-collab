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
$Password = "$AdminPD" | ConvertTo-SecureString -AsPlainText -Force
$isInstalled = (Get-WindowsFeature AD-Domain-Services).installed
if ($isInstalled -ne "True") {
  Write-Log -Message "Windows feature (AD-Domain-Services) is not installed and will be installed."
  Install-WindowsFeature -Name AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools
  Write-Log -Message "Promoting DC"
  Install-ADDSForest -CreateDnsDelegation:$false `
      -DomainName $DomainName `
      -DomainNetbiosName $DomainNetbiosName `
      -DatabasePath $DatabasePath `
      -DomainMode $DomainMode `
      -ForestMode $ForestMode `
      -SafeModeAdministratorPassword $Password `
      -InstallDns:$true `
      -LogPath $LogPath `
      -NoRebootOnCompletion:$false `
      -SysvolPath $SYSVOLPath `
      -Force:$true
  Write-Log -Message "DC Promoted" 
} else {
  Write-Log -Message "Windows feature (AD-Domain-Services) is installed"
}

Start-Sleep -Seconds 120;
$replicationSite = Get-ADReplicationSite -Filter { Name -eq $SiteName_RODC }
if ($replicationSite) {
    Write-Log -Message "The replication site '$SiteName_RODC' exists."
} else {
    New-ADReplicationSite -Name $SiteName_RODC
    #Add-ADDSReadOnlyDomainControllerAccount -DomainControllerAccountName $RODCServerName -DomainName $DomainName -DelegatedAdministratorAccountName "$DomainNetbiosName\$idr_service_account" -SiteName $SiteName
    Write-Log -Message "The replication site '$SiteName_RODC' does not exist."
} 
if ((Get-WindowsFeature RSAT-AD-PowerShell).installed -ne "True")
{
    Write-Log -Message "Windows feature (RSAT-AD-PowerShell) is not installed and will be installed."
    Install-WindowsFeature -Name RSAT-AD-PowerShell
} else
{
    Write-Log -Message "Windows feature (RSAT-AD-PowerShell) is already installed."
}
if ((Get-WindowsFeature GPMC).installed -ne "True")
{
    Write-Log -Message "Windows feature (GPMC) is not installed and will be installed."
    Install-WindowsFeature -Name GPMC -IncludeAllSubFeature -IncludeManagementTools
} else
{
    Write-Log -Message "Windows feature (GPMC) is already installed."
} 