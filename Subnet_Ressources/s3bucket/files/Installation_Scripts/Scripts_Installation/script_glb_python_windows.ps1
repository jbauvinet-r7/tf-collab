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

$hasPython = (Test-Path -Path "C:\Python\")  # Adjust path if needed
if (!$hasPython) {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    choco install python313 --pre --params "/InstallDir:C:\Python" -y
    pip3 install string --force-reinstall
    pip3 install datetime --force-reinstall
    pip3 install time --force-reinstall
    pip3 install webbrowser --force-reinstall
    pip3 install os --force-reinstall
    pip3 install random --force-reinstall
    pip3 install subprocess --force-reinstall
    pip3 install ldap3 --force-reinstall
    pip3 install sys --force-reinstall
    pip3 install logging --force-reinstall
    pip3 install pythonw --force-reinstall
    pip install string --force-reinstall
    pip install datetime --force-reinstall
    pip install time --force-reinstall
    pip install webbrowser --force-reinstall
    pip install os --force-reinstall
    pip install random --force-reinstall
    pip install subprocess --force-reinstall
    pip install ldap3 --force-reinstall
    pip install sys --force-reinstall
    pip install logging --force-reinstall
    pip install pythonw --force-reinstall
    Write-Log -Message "Python installed successfully!"
} else {
    Write-Log -Message "Python is already installed."
} 
Write-Log -Message "Installing Python Dependencies."
setx.exe PATH "%PATH%;C:\Python\Scripts"
pip3 install string --force-reinstall
pip3 install datetime --force-reinstall
pip3 install time --force-reinstall
pip3 install webbrowser --force-reinstall
pip3 install os --force-reinstall
pip3 install random --force-reinstall
pip3 install subprocess --force-reinstall
pip3 install ldap3 --force-reinstall
pip3 install sys --force-reinstall
pip3 install logging --force-reinstall
pip3 install pythonw --force-reinstall
pip install string --force-reinstall
pip install datetime --force-reinstall
pip install time --force-reinstall
pip install webbrowser --force-reinstall
pip install os --force-reinstall
pip install random --force-reinstall
pip install subprocess --force-reinstall
pip install ldap3 --force-reinstall
pip install sys --force-reinstall
pip install logging --force-reinstall
pip install pythonw --force-reinstall
Write-Log -Message "Python dependencies installed."