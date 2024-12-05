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
Write-Log -Message "Loading the new Wallpapaer"
Set-ExecutionPolicy UnRestricted -Force
 # Path to the wallpaper image (ensure this path is accessible to all users)
$ec2wallpaperconf = "C:\s3-downloads\Scripts_Installation\agent-config.yml"
# Define where to store the new wallpaper with attributes
$ec2wallpaperconfPath = "C:\ProgramData\Amazon\EC2Launch\config\agent-config.yml"
Copy-Item -Path $wallpaperPath -Destination $newWallpaperPath -Force
$wallpaperPath = "C:\s3-downloads\Scripts_Installation\Ec2Wallpaper.jpg"
# Define where to store the new wallpaper with attributes
$newWallpaperPath = "C:\ProgramData\Amazon\EC2Launch\wallpaper\Ec2Wallpaper.jpg"
# Ensure the custom wallpaper exists
if (Test-Path -Path $wallpaperPath) {
    # Ensure the destination directory exists
    if (-Not (Test-Path -Path "C:\ProgramData\Amazon\EC2Launch\wallpaper")) {
        New-Item -Path "C:\ProgramData\Amazon\EC2Launch\wallpaper" -ItemType Directory
    }

    # Move the custom wallpaper to replace the old one
    Copy-Item -Path $wallpaperPath -Destination $newWallpaperPath -Force
    Copy-Item -Path $wallpaperPath -Destination $newWallpaperPath -Force
    # Verify if the file has been moved
    if (Test-Path -Path $newWallpaperPath) {
        Write-Log -Message "Wallpaper has been replaced."

        # Run EC2Launch.exe to add instance information
        Start-Process -FilePath "C:\Program Files\Amazon\EC2Launch\EC2Launch.exe" -ArgumentList @(
            "wallpaper",
            "--path", $newWallpaperPath,
            "--all-tags",
            "--attributes", "instanceId,privateIpAddress,instanceSize,memory"

        ) -Wait

        # Refresh the desktop to apply the new wallpaper
        RUNDLL32.EXE user32.dll, UpdatePerUserSystemParameters
    } else {
        Write-Log -Message "Failed to move the wallpaper."
    }
} else {
    Write-Log -Message "Custom wallpaper not found at $wallpaperPath"
} 
