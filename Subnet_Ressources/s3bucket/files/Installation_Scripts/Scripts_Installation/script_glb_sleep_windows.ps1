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
$FilePath = "c:\UserDataLog\sleep_done.txt"
#Check if file exists in given path
If (Test-Path -path $FilePath -PathType Leaf) {
    Write-Log -Message "Sleep Already Done"
} Else {
    Write-Log -Message "Sleep Time"
    if ($SiteName -eq "AD") {
      Start-Sleep -Seconds 300
      Write-Log -Message "Sleep Time AD 5m"
    } elseif ($SiteName -eq "IT") {
      Start-Sleep -Seconds 1800
      Write-Log -Message "Sleep Time IT 30m"
    } elseif ($SiteName -eq "RODC") {
      Start-Sleep -Seconds 2700
      Write-Log -Message "Sleep Time RODC 45m"  
    } elseif ($SiteName -eq "HQ") {
      Start-Sleep -Seconds 3600
      Write-Log -Message "Sleep Time HQ 60m"  
    } elseif ($SiteName -eq "R7") {
      Start-Sleep -Seconds 300
      Write-Log -Message "Sleep Time R7 60m"  
    } elseif ($SiteName -eq "DMZ") {
      Write-Log -Message "No Sleep Time DMZ"  
    } elseif ($SiteName -eq "JUMPBOX") {
      Start-Sleep -Seconds 300
      Write-Log -Message "Sleep Time JUMPBOX 5m"
    } elseif ($SiteName -eq "BOOTCAMP") {
      Write-Log -Message "No Sleep Time BOOTCAMP"  
    } elseif ($SiteName -eq "BTCP_VRM") {
      Write-Log -Message "No Sleep Time BTCP_VRM"  
    } elseif ($SiteName -eq "BTCP_IDR") {
      Start-Sleep -Seconds 1800
      Write-Log -Message "Sleep Time BTCP_IDR 30m"  
    } else {
      Write-Log -Message "No SiteName - Sleep Time skipped"
    }
    New-Item -Path "c:\UserDataLog\sleep_done.txt" -ItemType File
}
Write-Host "Sleep Time Script Completed"