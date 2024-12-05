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

$ErrorActionPreference = "Stop"
function Install-WindowsFeatureIfNotInstalled {
    param (
        [string]$featureName
    )
    $feature = Get-WindowsFeature -Name $featureName
    if (!$feature.Installed) {
        Install-WindowsFeature -Name $featureName
    } else {
        Write-Log -Message "$featureName is already installed"
    }
}
function Install-ChocolateyPackageIfNotInstalled {
    param (
        [string]$packageName
    )
    $package = Get-Package -Name $packageName -ErrorAction SilentlyContinue
    if (!$package) {
        choco install $packageName -y
    } else {
        Write-Log -Message "$packageName is already installed"
    }
}
try {
    Write-Log -Message "Installing IIS defaults plus a few extras"
    Install-WindowsFeatureIfNotInstalled "Web-Server" # (defaults)
    Install-WindowsFeatureIfNotInstalled "Web-App-Dev"
    Install-WindowsFeatureIfNotInstalled "Web-Net-Ext45"
    Install-WindowsFeatureIfNotInstalled "Web-Asp-Net45"
    Install-WindowsFeatureIfNotInstalled "Web-Http-Redirect"
    Install-WindowsFeatureIfNotInstalled "Web-Log-Libraries"
    Write-Log -Message "Installing remote web management service"
    Install-WindowsFeatureIfNotInstalled "Web-Mgmt-Service"
    Write-Log -Message "Enabling and configuring remote web management service"
    $enableRemoteCmd = @"
    REGEDIT4
    [HKEY_LOCAL_MACHINE\Software\Microsoft\WebManagement\Server]
    "EnableRemoteManagement"=dword:00000001
"@
    Set-Content -Path "enableRemoteWebAdmin.reg" -Value $enableRemoteCmd
    reg import .\enableRemoteWebAdmin.reg
    Set-Service -Name WMSVC -StartupType Auto
    net start WMSVC
    netsh advfirewall firewall add rule name="IIS Remote Management" dir=in action=allow service=WMSVC
    Write-Log -Message "Installing Web Deploy"
    Install-ChocolateyPackageIfNotInstalled "webdeploy"
    Write-Log -Message "Installing URLRewrite"
    Install-ChocolateyPackageIfNotInstalled "urlrewrite"
    Write-Log -Message "Installing DAC Framework"
    Install-ChocolateyPackageIfNotInstalled "sql2016-dacframework"
    Write-Log -Message "Installing DAC SqlDom"
    Install-ChocolateyPackageIfNotInstalled "sql2016-sqldom"
    Write-Log -Message "Installing SQLCMD"
    Install-ChocolateyPackageIfNotInstalled "sqlserver-cmdlineutils"
    Write-Log -Message "Installing dotnetcore-windowshosting"
    Install-ChocolateyPackageIfNotInstalled "dotnetcore-windowshosting" --version=2.1.7
    Write-Log -Message "Installing Dot Net Framework 4.7.1"
    Install-ChocolateyPackageIfNotInstalled "dotnet4.7.1"
    Write-Log -Message "Installing Dot Net Framework 4.7.2"
    Install-ChocolateyPackageIfNotInstalled "dotnet4.7.2"
    Write-Log -Message "Installation completed successfully"
}
catch {
    Write-Error "An error occurred: $_"
}
finally {
    $ErrorActionPreference = "Continue"
}