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
    Write-Log -Message "Installing MRemoteNG"
    choco install mremoteng --force  -y
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
    Write-Log -Message "Installation completed successfully"
}
catch {
    Write-Error "An error occurred: $_"
}
finally {
    $ErrorActionPreference = "Continue"
}
$opensshServerState = (Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*').State
if ($opensshServerState -eq "Installed") {
  Write-Log -Message "OpenSSH Server is already installed."
} else {
  Write-Log -Message "OpenSSH Server is not installed."
  Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
  Start-Service sshd
  Set-Service -Name sshd -StartupType 'Automatic'
  New-NetFirewallRule -DisplayName "OpenSSH Server Port (TCP 22)" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 22 -Profile Domain,Private
}
$opensshClientState = (Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Client*').State
if ($opensshClientState -eq "Installed") {
  Write-Log -Message "OpenSSH Client is already installed."
} else {
  Write-Log -Message "OpenSSH Client is not installed."
  Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
  Start-Service sshd
  Set-Service -Name sshd -StartupType 'Automatic'
  New-NetFirewallRule -DisplayName "OpenSSH Server Port (TCP 22)" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 22 -Profile Domain,Private
} 
# #Install AWSCLI
# $awscliv2Path = Test-Path -Path "C:\Program Files\Amazon\AWSCLIV2\aws.exe" -PathType Leaf
# # Output result based on the check
# if ($awscliv2Path) {
#     Write-Log -Message "AWS CLI v2 (awscliv2) is installed."
#   } 
# else {
#     Write-Log -Message "AWS CLI v2 (awscliv2) is not installed."
#     Set-ExecutionPolicy UnRestricted -Force
#     $command = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12"
#     Invoke-Expression $command
#     Invoke-WebRequest -Uri "https://awscli.amazonaws.com/AWSCLIV2.msi" -Outfile C:\AWSCLIV2.msi
#     $arguments = "/i `"C:\AWSCLIV2.msi`" /quiet"
#     Start-Process msiexec.exe -ArgumentList $arguments -Wait
#     Write-Log -Message "AWS CLI v2 (awscliv2) is now installed."
# }

# #Install Firefox
# if (-not(Test-Path "C:\Program Files (x86)\Mozilla Firefox")) {
#     New-Item -Path "C:\s3-downloads" -Name "softwares" -ItemType "directory" -Force
#     $uri = "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US"
#     $out = "c:\s3-downloads\softwares\firefox.exe"
#     Invoke-WebRequest -uri $uri -OutFile $out
#     Start-Process -Wait -FilePath "c:\s3-downloads\softwares\firefox.exe" -ArgumentList "/S" -PassThru
# } else {
#     Write-Log -Message "Firefox already installed."
# }
# #Install Chrome
# if (-not(Test-Path "C:\Program Files\Google\Chrome")) {
#     $Path = $env:TEMP; $Installer = "chrome_installer.exe"; Invoke-WebRequest "https://dl.google.com/chrome/install/latest/chrome_installer.exe" -OutFile $Path$Installer; Start-Process -FilePath $Path$Installer -Args "/silent /install" -Verb RunAs -Wait; Remove-Item $Path$Installer 
#     } else {
#     Write-Log -Message "Chrome already installed."
# }
# #Install Moba
# if (-not(Test-Path "C:\Program Files (x86)\Mobatek\MobaXterm")) {
#     New-Item -Path "C:\s3-downloads" -Name "softwares" -ItemType "directory" -Force
#     $uri = "https://download.mobatek.net/2402024022512842/MobaXterm_Installer_v24.0.zip"
#     $out = "c:\s3-downloads\softwares\MobaXterm_Installer.zip"
#     Invoke-WebRequest -uri $uri -OutFile $out
#     Expand-Archive c:\s3-downloads\softwares\MobaXterm_Installer.zip -DestinationPath c:\s3-downloads\softwares\MobaXterm_Installer
#     msiexec /i c:\s3-downloads\softwares\MobaXterm_Installer\MobaXterm_installer_24.0.msi /l*v c:\s3-downloads\softwares\moba_installation.log /quiet
#     $command = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12"
#     Invoke-Expression $command
#     $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
#     aws s3 cp s3://$Bucket_Name/Jumpbox_Scripts/MobaXterm.ini C:\s3-downloads\softwares
#     $username = "$AdminUser"
#     $password = ConvertTo-SecureString "$AdminPD" -AsPlainText -Force
#     $psCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)
#     Start-Process "C:\Program Files (x86)\Mobatek\MobaXterm\MobaXterm.exe" -Credential $psCred
#     taskkill /IM "MobaXterm.exe" /F
#     Copy-Item "C:\s3-downloads\softwares\MobaXterm.ini" -Destination "C:\Users\mmoose\AppData\Roaming\MobaXterm\MobaXterm.ini" -Recurse -force
#     Copy-Item "C:\s3-downloads\softwares\MobaXterm.ini" -Destination "C:\Users\mmoose.JUMPBOX\AppData\Roaming\MobaXterm\MobaXterm.ini" -Recurse -force 
#     Write-Log -Message "Installation Mobaxterm completed"
# } else {
#     Write-Log -Message "Mobaxterm already installed."
# }

# #Install HashTab
# if (-not(Test-Path "C:\Program Files (x86)\HashTab")) {
#     New-Item -Path "C:\s3-downloads" -Name "softwares" -ItemType "directory" -Force
#     $uri = "https://implbits.com/wp-content/uploads/HashTab_v6.0.0.34_Setup.exe"
#     $out = "c:\s3-downloads\softwares\HashTab.exe"
#     Invoke-WebRequest -uri $uri -OutFile $out
#     msiexec /i c:\s3-downloads\softwares\HashTab.exe /l*v c:\s3-downloads\softwares\HashTab_installation.log /quiet
#     $command = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12"
#     Invoke-Expression $command
#     Write-Log -Message "Installation HashTab completed"
# } else {
#     Write-Log -Message "HashTab already installed."
# }

#Install FileLocator
if (-not(Test-Path "C:\Program Files\Mythicsoft\FileLocator Pro\")) {
    New-Item -Path "C:\s3-downloads" -Name "softwares" -ItemType "directory" -Force
    $uri = "https://download.mythicsoft.com/flp/3425/filelocator_3425.exe"
    $out = "c:\s3-downloads\softwares\filelocator.exe"
    Invoke-WebRequest -uri $uri -OutFile $out
    msiexec /i c:\s3-downloads\softwares\filelocator.exe /l*v c:\s3-downloads\softwares\filelocator_installation.log REG_DETAILS="Rapid7=selabs@rapid7.com=" /quiet
    $command = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12"
    Invoke-Expression $command
    Write-Log -Message "Installation FileLocator completed"
} else {
    Write-Log -Message "FileLocator already installed."
}

# #Install NPP
# if (-not(Test-Path "C:\Program Files\Notepad++")) {
#     New-Item -Path "C:\s3-downloads" -Name "softwares" -ItemType "directory" -Force
#     $uri = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.6.4/npp.8.6.4.Installer.x64.exe"
#     $out = "c:\s3-downloads\softwares\npp.Installer.x64.exe"
#     Invoke-WebRequest -uri $uri -OutFile $out
#     msiexec /i c:\s3-downloads\softwares\npp.Installer.x64.exe /l*v c:\s3-downloads\softwares\npp_installation.log /quiet
#     $command = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12"
#     Invoke-Expression $command
#     Write-Log -Message "Installation NPP completed"
# } else {
#     Write-Log -Message "NPP already installed."
# }