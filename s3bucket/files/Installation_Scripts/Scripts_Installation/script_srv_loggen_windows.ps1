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
Write-Log -Message "Installing Log Generator"
Set-ExecutionPolicy Bypass -Scope Process -Force
$lgexepath = 'C:\s3-downloads\Log_Generator\Log_Generator_Selabs\log_generator.exe'
if (-not(Test-Path $lgexepath))
{
    New-Item -Path "C:\s3-downloads\" -Name "Log_Generator" -ItemType "directory"
    aws s3 cp s3://$Bucket_Name/Log_Generator/Log_Generator_Selabs.zip C:\s3-downloads\Log_Generator
    Expand-Archive C:\s3-downloads\Log_Generator\Log_Generator_Selabs.zip -DestinationPath C:\s3-downloads\Log_Generator
    Remove-Item -Path "C:\s3-downloads\Log_Generator\Log_Generator_Selabs.zip"
} else {
    Write-Log -Message "Log Generator already installed"
}
# Define the process name
$processName = "log_generator"
# Get all processes with the specified name
$processes = Get-Process -Name $processName -ErrorAction SilentlyContinue
# Check if any processes were found
if ($processes) {
    # Stop all processes with the specified name
    Stop-Process -Name $processName -Force
    Write-Host "All processes named '$processName.exe' have been terminated."
} else {
    Write-Host "No processes named '$processName.exe' are currently running."
}
# Define the task name and action
$taskName = "LogGenerator"
# Check if the scheduled task exists
$task = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($task) {
    # Unregister (delete) the task if it exists
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
    Write-Host "Scheduled task '$taskName' has been deleted."
} else {
    Write-Host "Scheduled task '$taskName' does not exist."
}
# Define the task name and action
$action = New-ScheduledTaskAction -Execute "C:\s3-downloads\Log_Generator\Log_Generator_Selabs\log_generator.exe" -Argument "--useroverwrite domain=$DomainName,bypassdomain=nc.com --overwrite domain=$DomainName,collector=$Coll_IP,bypassdomain=nc.com --autoload type=profiles"
$trigger = New-ScheduledTaskTrigger -AtStartup # Trigger the task at system startup

# Define the principal to run as a specific user (replace with the actual username)
$user = "$DomainNetbiosName\$idr_service_account"
$principal = New-ScheduledTaskPrincipal -UserId $user -LogonType Password -RunLevel Highest

# Define the task settings (without stopping the task if it runs too long)
$settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit 0

# Check if the scheduled task exists
if (-not (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue)) {
    # Register the task if it doesn't exist
    $Task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings -Principal $principal
    $Task | Register-ScheduledTask -TaskName $taskName -User $user -Password $idr_service_account_pwd  
    #Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $taskName -Description "Starts Log Generator at startup" -Settings $settings -User $user -Password $SecureAdminSafeModePassword
    Write-Host "Scheduled task '$taskName' has been created."
    # Start the task
    Start-ScheduledTask -TaskName $taskName
    Write-Host "Scheduled task '$taskName' has been started."
} else {
    Write-Host "Scheduled task '$taskName' already exists."
}
Write-Log -Message "Log Generator Started"