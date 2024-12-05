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
Write-Host "Collector Installation in progress"
if ($R7_Region -eq "us1") {
  New-Item -Path "C:\s3-downloads\" -Name "Collector" -ItemType "directory"
  Set-ExecutionPolicy UnRestricted -Force
  $command = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12"
  Invoke-Expression $command
  Invoke-WebRequest -Uri "https://s3.amazonaws.com/com.rapid7.razor.public/InsightSetup-Windows64.exe" -Outfile C:\s3-downloads\Collector\InsightSetup-Windows64.exe
  $arguments = "/i `"C:\s3-downloads\Collector\InsightSetup-Windows64.exe`" /l*v c:\s3-downloads\Collector\installation.log /quiet"
  Start-Process msiexec.exe -ArgumentList $arguments -Wait
  Write-Log -Message "Collector installed in Region us1"
} elseif ($R7_Region -eq "us2") {
  New-Item -Path "C:\s3-downloads\" -Name "Collector" -ItemType "directory"
  Set-ExecutionPolicy UnRestricted -Force
  $command = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12"
  Invoke-Expression $command
  Invoke-WebRequest -Uri "https://s3.us-east-2.amazonaws.com/public.razor-prod-5.us-east-2.insight.rapid7.com/InsightSetup-Windows64.exe" -Outfile C:\s3-downloads\Collector\InsightSetup-Windows64.exe
  $arguments = "/i `"C:\s3-downloads\Collector\InsightSetup-Windows64.exe`" /l*v c:\s3-downloads\Collector\installation.log /quiet"
  Start-Process msiexec.exe -ArgumentList $arguments -Wait
  Write-Log -Message "Collector installed in Region us2"
} elseif ($R7_Region -eq "us3") {
  New-Item -Path "C:\s3-downloads\" -Name "Collector" -ItemType "directory"
  Set-ExecutionPolicy UnRestricted -Force
  $command = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12"
  Invoke-Expression $command
  Invoke-WebRequest -Uri "https://s3.us-west-2.amazonaws.com/public.razor-prod-6.us-west-2.insight.rapid7.com/InsightSetup-Windows64.exe" -Outfile C:\s3-downloads\Collector\InsightSetup-Windows64.exe
  $arguments = "/i `"C:\s3-downloads\Collector\InsightSetup-Windows64.exe`" /l*v c:\s3-downloads\Collector\installation.log /quiet"
  Start-Process msiexec.exe -ArgumentList $arguments -Wait
  Write-Log -Message "Collector installed in Region us3"
} elseif ($R7_Region -eq "eu") {
  New-Item -Path "C:\s3-downloads\" -Name "Collector" -ItemType "directory"
  Set-ExecutionPolicy UnRestricted -Force
  $command = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12"
  Invoke-Expression $command
  Invoke-WebRequest -Uri "https://s3.eu-central-1.amazonaws.com/public.razor-prod-0.eu-central-1.insight.rapid7.com/InsightSetup-Windows64.exe" -Outfile C:\s3-downloads\Collector\InsightSetup-Windows64.exe
  $arguments = "/i `"C:\s3-downloads\Collector\InsightSetup-Windows64.exe`" /l*v c:\s3-downloads\Collector\installation.log /quiet"
  Start-Process msiexec.exe -ArgumentList $arguments -Wait
  Write-Log -Message "Collector installed in Region eu"
} elseif ($R7_Region -eq "ap") {
  New-Item -Path "C:\s3-downloads\" -Name "Collector" -ItemType "directory"
  Set-ExecutionPolicy UnRestricted -Force
  $command = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12"
  Invoke-Expression $command
  Invoke-WebRequest -Uri "https://s3.ap-northeast-1.amazonaws.com/public.razor-prod-2.ap-northeast-1.insight.rapid7.com/InsightSetup-Windows64.exe" -Outfile C:\s3-downloads\Collector\InsightSetup-Windows64.exe
  $arguments = "/i `"C:\s3-downloads\Collector\InsightSetup-Windows64.exe`" /l*v c:\s3-downloads\Collector\installation.log /quiet"
  Start-Process msiexec.exe -ArgumentList $arguments -Wait
  Write-Log -Message "Collector installed in Region ap"
} elseif ($R7_Region -eq "ca") {
  New-Item -Path "C:\s3-downloads\" -Name "Collector" -ItemType "directory"
  Set-ExecutionPolicy UnRestricted -Force
  $command = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12"
  Invoke-Expression $command
  Invoke-WebRequest -Uri "https://s3.ca-central-1.amazonaws.com/public.razor-prod-3.ca-central-1.insight.rapid7.com/InsightSetup-Windows64.exe" -Outfile C:\s3-downloads\Collector\InsightSetup-Windows64.exe
  $arguments = "/i `"C:\s3-downloads\Collector\InsightSetup-Windows64.exe`" /l*v c:\s3-downloads\Collector\installation.log /quiet"
  Start-Process msiexec.exe -ArgumentList $arguments -Wait
  Write-Log -Message "Collector installed in Region ca"
} elseif ($R7_Region -eq "au") {
  New-Item -Path "C:\s3-downloads\" -Name "Collector" -ItemType "directory"
  Set-ExecutionPolicy UnRestricted -Force
  $command = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12"
  Invoke-Expression $command
  Invoke-WebRequest -Uri "https://s3.ap-southeast-2.amazonaws.com/public.razor-prod-4.ap-southeast-2.insight.rapid7.com/InsightSetup-Windows64.exe" -Outfile C:\s3-downloads\Collector\InsightSetup-Windows64.exe
  $arguments = "/i `"C:\s3-downloads\Collector\InsightSetup-Windows64.exe`" /l*v c:\s3-downloads\Collector\installation.log /quiet"
  Start-Process msiexec.exe -ArgumentList $arguments -Wait
  Write-Log -Message "Collector installed in Region au"
} else {
  Write-Log -Message "No R7 Region - Collector Installation skipped"
}
Write-Host "Collector Installation Completed"
Write-Log -Message "Opening TCP / UDP Ports in the Firewall"
New-NetFirewallRule -DisplayName "Allow All TCP Ports" -Direction Inbound -Protocol TCP -Action Allow
New-NetFirewallRule -DisplayName "Allow All UDP Ports" -Direction Inbound -Protocol UDP -Action Allow