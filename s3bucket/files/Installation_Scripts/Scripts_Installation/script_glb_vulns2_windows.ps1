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


Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
try {
    Write-Log -Message "Installing firefox"
    choco install firefox --force  -y
    Write-Log -Message "Installing googlechrome"
    choco install googlechrome --force  -y
    Write-Log -Message "Installing HashTab"
    choco install hashtab --force  -y
    Write-Log -Message "Installing notepadplusplus"
    choco install notepadplusplus --force  -y
    Write-Log -Message "Installing mobaxterm"
    choco install mobaxterm --force  -y
    Write-Log -Message "Installing office365business"
    choco install office365business --force  -y
    Write-Log -Message "Installing VSCode"
    choco install vscode --force  -y
    Write-Log -Message "Installing Putty"
    choco install putty --force  -y
    Write-Log -Message "Installing Qbittorrent"
    choco install qbittorrent --force  -y
    Write-Log -Message "Installing Steam"
    choco install steam --force  -y 
    Write-Log -Message "Installing Dropbox"
    choco install kb2919355 --force  -y  
    choco install dropbox --force  -y  
    Write-Log -Message "Installing Winscp"
    choco install winscp --force  -y  
    Write-Log -Message "Installing Glary"
    choco install glaryutilities-free --force  -y  
    Write-Log -Message "Installing Keepass"
    choco install keepass --force  -y  
    Write-Log -Message "Installing Teamviewer"
    choco install teamviewer --force  -y  
    Write-Log -Message "Installing Skypeforbusiness"
    choco install skypeforbusiness --force  -y  
    Write-Log -Message "Installing Thunderbird"
    choco install thunderbird --force  -y  
    Write-Log -Message "Installing Opera"
    choco install opera --force  -y 
    Write-Log -Message "Installing OneDrive"
    choco install onedrive --force  -y 
    Write-Log -Message "Installing GoogleDrive"
    choco install googledrive --force  -y 
    Write-Log -Message "Installing Zoom"
    choco install zoom --force  -y 
    Write-Log -Message "Installing Winrar"
    choco install winrar --force  -y 
    Write-Log -Message "Installing VLC"
    choco install vlc --force  -y 
    Write-Log -Message "Installing VNC-Viewer"
    choco install vnc-viewer --force  -y
    Write-Log -Message "Installing Itunes"
    choco install itunes --force  -y
    Write-Log -Message "Installing FoxitPDFReader"
    choco install foxitreader --force  -y
    Write-Log -Message "Installing Filezilla"
    choco install filezilla --force  -y
    Write-Log -Message "Installing 7zip"
    choco install 7zip --force  -y
    Write-Log -Message "Installing mremoteng"
    choco install mremoteng --force  -y
    Write-Log -Message "Installation completed successfully"
}
catch {
    Write-Error "An error occurred: $_"
}
finally {
    $ErrorActionPreference = "Continue"
}