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
# Function to enable network discovery
function Enable-NetworkDiscovery {
  netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes
}

# Enable network discovery
Write-Log -Message "Enable Network Discovery."
Enable-NetworkDiscovery
 # Define the registry key path
 $regKeyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
 $regValueName = "EnableLinkedConnections"
 $regValueData = 1
 
 # Check if the registry value exists and its data is not 1
 if (((Get-Item -Path $regKeyPath).GetValue($regValueName) -ne $null) -eq $false) {
  # Create or update the registry value
     New-ItemProperty -Path $regKeyPath -Name $regValueName -Value $regValueData -PropertyType DWORD -Force | Out-Null
     # Display a message indicating completion
     Write-Host "EnableLinkedConnections registry value has been configured."
     # Restart the computer
     Restart-Computer -Force
 }
 else {
     Write-Host "EnableLinkedConnections registry value is already configured. No action taken."
 }
$User = "$DomainNetbiosName\$User_Account"
$PWord = ConvertTo-SecureString -String "$AdminPD" -AsPlainText -Force
$Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, $PWord
net use * /delete /y
taskkill /f /IM explorer.exe
explorer.exe
# Mount a network drive
if ($siteName -eq "IT") {
  Write-Log -Message "Adding Shared Drives to Instances in $SiteName."
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.10.102\Share_Accounting" -Name "G" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.10.102\Share_Administrative" -Name "H" -Credential $Credentials -Persist -Scope Global
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.10.102\Share_Design" -Name "I" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.10.102\Share_Distribution" -Name "J" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.10.102\Share_Finance" -Name "K" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.10.102\Share_HR" -Name "L" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.10.102\Share_IT" -Name "M" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.10.102\Share_Marketing" -Name "N" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.10.102\Share_Operations" -Name "O" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.10.102\Share_Production" -Name "P" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.10.102\Share_Quality" -Name "Q" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.10.102\Share_RD" -Name "R" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.10.102\Share_Sales" -Name "S" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.10.102\Share_Stores" -Name "T" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.10.102\Share_Support" -Name "U" -Credential $Credentials -Persist -Scope Global 
} elseif ($siteName -eq "HQ") {
  Write-Log -Message "Adding Shared Drives to Instances in $SiteName."
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.20.102\Share_Accounting" -Name "G" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.20.102\Share_Administrative" -Name "H" -Credential $Credentials -Persist -Scope Global
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.20.102\Share_Design" -Name "I" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.20.102\Share_Distribution" -Name "J" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.20.102\Share_Finance" -Name "K" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.20.102\Share_HR" -Name "L" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.20.102\Share_IT" -Name "M" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.20.102\Share_Marketing" -Name "N" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.20.102\Share_Operations" -Name "O" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.20.102\Share_Production" -Name "P" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.20.102\Share_Quality" -Name "Q" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.20.102\Share_RD" -Name "R" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.20.102\Share_Sales" -Name "S" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.20.102\Share_Stores" -Name "T" -Credential $Credentials -Persist -Scope Global 
  New-PSDrive -PSProvider "FileSystem" -Root "\\10.0.20.102\Share_Support" -Name "U" -Credential $Credentials -Persist -Scope Global 
} else {
  Write-Log -Message "$SiteName is not in IT/HQ, no Shared Drives added."
}