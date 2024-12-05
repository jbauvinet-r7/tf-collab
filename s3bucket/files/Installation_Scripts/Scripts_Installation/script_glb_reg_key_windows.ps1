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

#Function to store log data
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
auditpol /set /category:"Object Access" /success:enable /failure:enable 
Set-MpPreference -DisableRealtimeMonitoring $true
# Get the registry key
$regKey = Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -Name "fSingleSessionPerUser"
echo $regKey
# Check if the value exists
if ($regKey -ne $null -and $regKey.fSingleSessionPerUser -ne $null) {
  # Set the value to 0 (disable single session)
  Write-Host "fSingleSessionPerUser value already set to 0 (disabled)"
} else {
  Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" -Name "fSingleSessionPerUser" -Value 0
  Write-Host "fSingleSessionPerUser value not found. Multiple sessions might already be allowed."
} 
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t REG_DWORD /d 0 /f
Reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v DisableRealtimeMonitoring /t REG_DWORD /d 1 /f
Reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SpynetReporting /t REG_DWORD /d 0 /f
Reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent /t REG_DWORD /d 3 /f
Reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\PassportForWork" /v Enabled /t REG_DWORD /d 0 /f /reg:64
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowSignInOptions" /v value /t REG_DWORD /d 0 /f /reg:64
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v AllowDomainPINLogon /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\PassportForWork" /v DisablePostLogonProvisioning /t REG_DWORD /d 1 /f
reg add "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\system" /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f
 # Path to the registry key
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\system"

# Name of the registry value
$regName = "LocalAccountTokenFilterPolicy"

# Value to set (1 to enable, 0 to disable)
$regValue = 1

# Check if the registry key exists, if not, create it
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force
}
else {
    Write-Host "LocalAccountTokenFilterPolicy already configured"
}
# Set the registry value
Set-ItemProperty -Path $regPath -Name $regName -Value $regValue
# Verify the change
if ((Get-ItemProperty -Path $regPath -Name $regName).$regName -eq $regValue) {
    Write-Host "LocalAccountTokenFilterPolicy successfully set to $regValue"
} else {
    Write-Host "Failed to set LocalAccountTokenFilterPolicy"
}
$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key Hidden 1
Set-ItemProperty $key HideFileExt 0
#Set-ItemProperty $key ShowSuperHidden 1
#while($true) { if( Test-Path C:\UserDataLog\UserDataLogFile.log ) { Get-Content C:\UserDataLog\UserDataLogFile.log -Wait -Tail 1 -ErrorAction SilentlyContinue} }