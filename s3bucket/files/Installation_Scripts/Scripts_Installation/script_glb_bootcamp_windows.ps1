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
if (-not(Test-Path "C:\BootCamp\BootCamp-Internal.pem"))
{
    Remove-Item -Path "C:\BootCamp\BootCamp.txt"
    New-Item -Path "C:\" -Name "BootCamp" -ItemType "directory"
    Write-Log -Message "Created BootCamp folder."
    $multiLineText = @"
################WELCOME TO OUR RAPID7 BOOTCAMP################

You are using the "$AdminUser" lab ! 

Here is a list of you instances : 

InsightPlatform : 
    - Username : bootcamp+bc$AdminUser@rapid7.com
    - Password : (1Password - BootCamp Vault)
    - InsightAgent Token : $Token

InsightVM Module : 
    - VRM Console Ubuntu : 10.0.7.100
    - VRM Console Windows : 10.0.7.101
    - VRM Scan Engine Ubuntu : 10.0.7.102
    - VRM Scan Engine Windows : 10.0.7.103
    - VRM Scan Target 1 Windows : 10.0.7.200
    - VRM Scan Target 2 Windows : 10.0.7.201
    - VRM Scan Target 3 Windows : 10.0.7.202
    - VRM Scan Target 4 Ubuntu : 10.0.7.203
    - VRM Licenses ["InsightVM","Nexpose"]  : [$VRM_License_Key]

InsightIDR Module :
    - IDR Active Directory : 10.0.17.100
    - IDR Collector Ubuntu : 10.0.17.101
    - IDR Orchestrator Ubuntu : 10.0.17.102
    - IDR Collector Windows : 10.0.17.103
    - IDR Network Sensor Ubuntu : 10.0.17.104 (Management) 
    - IDR Network Sensor Ubuntu : 10.0.17.105 (Traffic)
    - IDR Honeypot : 10.0.17.106
    - IDR Target 1 Windows : 10.0.17.200
    - IDR Target 2 Ubuntu : 10.0.17.210

Windows Targets (Windows 11) - RDP : 
    - Username : $DomainNetbiosName\$AdminUser
    - Password : $AdminPD
    - Local User : Rapid7
    - Password : Rapid7!

Windows Server (Windows Server 2022) - RDP :
    - Local User : Administrator
    - Password : $AdminPD
    - Domain User : $DomainNetbiosName\$idr_service_account
    - Password : $AdminPD

Ubuntu Server (Ubuntu 22.04) - SSH :
    - Ubuntu Instances username : ubuntu
    - No Password => Certificate 

To access these servers/workstations:
    1 - Open mRemoteNG
    2 - Click on File, Open Connection File..
    3 - Go to C:\BootCamp
    4 - Open BootCamp-mRemoteNG.xml

Don't engage in any activities that could compromise participants' 
data security or violate legal and ethical standards, 
such as running ransomware or sharing personal information.

Thank you and have fun !! 

"@
    $multiLineText | Add-Content -Path "C:\BootCamp\BootCamp.txt"
    Copy-Item "C:\s3-downloads\Scripts_Installation\BootCamp-mRemoteNG.xml" -Destination "C:\BootCamp" -Force
    Copy-Item "C:\s3-downloads\Scripts_Installation\PuTTYNG.exe" -Destination "C:\Program Files (x86)\mRemoteNG" -Force
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
    aws s3 cp s3://$Bucket_Name/$User_Account-BootCamp_Lab_Internal.pem C:\BootCamp\BootCamp-Internal.pem
    reg import "C:\s3-downloads\Scripts_Installation\BootCamp-putty.reg"
    winscp.com /keygen C:\BootCamp\BootCamp-Internal.pem /output=C:\BootCamp\BootCamp-Internal.ppk
} else {
    reg import "C:\s3-downloads\Scripts_Installation\BootCamp-putty.reg"
    Copy-Item "C:\s3-downloads\Scripts_Installation\BootCamp-mRemoteNG.xml" -Destination "C:\BootCamp" -Force
    Copy-Item "C:\s3-downloads\Scripts_Installation\PuTTYNG.exe" -Destination "C:\Program Files (x86)\mRemoteNG" -Force
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
    Write-Log -Message "BootCamp Folder already exists."
}