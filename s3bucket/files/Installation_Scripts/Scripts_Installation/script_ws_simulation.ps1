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
Write-Log -Message "Starting User Simulation"

if ($SiteName -eq "IT") {
    $Login_IP = $AD_IP
    Write-Log -Message "Active Directory Logging IP is $Login_IP"
} elseif ($SiteName -eq "HQ") {
    $Login_IP = $RODC_IP
    Write-Log -Message "Active Directory Logging IP is $Login_IP"
} else {
    $Login_IP = $RODC_IP
    Write-Log -Message "Active Directory Logging IP is $Login_IP"
} 
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "AutoAdminLogon" -Value "1"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultUserName" -Value "$User_Account"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultPassword" -Value "$AdminPD"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" -Name "DefaultDomainName" -Value "$DomainNetbiosName"
$targetUser = "$DomainNetbiosName\$User_Account"
$scriptPath = "C:\s3-downloads\Scripts_Installation\user-simulation.py"
$exePath = "C:\s3-downloads\Scripts_Installation\user-simulation.exe"
$pythonInterpreter = "C:\Python\pythonw.exe"
$securePassword = ConvertTo-SecureString $AdminPD -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($targetUser, $securePassword)
$A = New-ScheduledTaskAction -Execute "$exePath" -Argument "$exePath $DomainNetbiosName $User_Account $AdminPD $Login_IP $SiteName"
$T = New-ScheduledTaskTrigger -AtStartup
$D = "User Simulation"
$S = New-ScheduledTaskSettingsSet -MultipleInstances Parallel -ExecutionTimeLimit 0
$processName = "user-simulation"
$P = New-ScheduledTaskPrincipal -UserId "$targetUser" -LogonType Interactive
# Register the scheduled task
Register-ScheduledTask -TaskName "$processName" -Action $A -Trigger $T -Principal $P -Settings $S -Description $D -Force
# Check if the process exists
$process = Get-Process -Name $processName
if ($process) {
  # Process is running
  Write-Log -Message "Process '$processName' is running (PID: $($process.Id))"
} else {
  # Process is not running
  Write-Log -Message "Process '$processName' is not running."
  Start-ScheduledTask -TaskName "User-Simulation"
} 
$LockWorkStation = Add-Type -Name "Win32LockWorkStation" -PassThru -MemberDefinition @"
    [DllImport("user32.dll")]
    public static extern int LockWorkStation();
"@ 
$PostMessage = Add-Type -Name "Win32PostMessage" -PassThru -MemberDefinition @"
    [DllImport("user32.dll")]
    public static extern int PostMessage(int hWnd, int hMsg, int wParam, int lParam);
"@
# lock workstation
Write-Information -MessageData "Locking workstation" -InformationAction Continue
if (0 -eq $LockWorkStation::LockWorkStation()) {
    throw 'Failed to lock workstation'
}