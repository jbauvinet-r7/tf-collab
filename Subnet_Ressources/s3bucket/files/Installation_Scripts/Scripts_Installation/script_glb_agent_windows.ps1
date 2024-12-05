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

if ($SEOPS_VR_Install) {
    $service = Get-Service -Name Velociraptor -ErrorAction SilentlyContinue
    if($service -eq $null){
        New-Item -Path "C:\s3-downloads\" -Name "VR_Agent" -ItemType "directory"
        Write-Log -Message "Created VR_Agent folder to store Locations files."
        Write-Log -Message "Getting VR_Agent files from S3 Bucket."
        Set-ExecutionPolicy UnRestricted -Force
        $command = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12"
        Invoke-Expression $command
        Invoke-WebRequest -Uri "https://awscli.amazonaws.com/AWSCLIV2.msi" -Outfile C:\AWSCLIV2.msi
        $arguments = "/i `"C:\AWSCLIV2.msi`" /quiet"
        Start-Process msiexec.exe -ArgumentList $arguments -Wait
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
        aws s3 cp s3://$Bucket_Name/VRAgent/$VR_Agent_File C:\s3-downloads\VR_Agent\
        msiexec /i c:\s3-downloads\VR_Agent\$VR_Agent_File /l*v c:\s3-downloads\VR_Agent\installation.log /quiet 
        Write-Log -Message "Installation VR Agent"
    } else {
        Write-Log -Message "VR Agent already installed."
    }
  } else {
    # Handle the case where $SEOPS_VR_Install is false or empty
    Write-Log -Message "SEOPS VR installation not detected. Skipping actions."
  }
if ($Agent_Type -eq "ngav") {
    $service = Get-Service -Name ir_agent -ErrorAction SilentlyContinue
    if ($service -eq $null) {
      New-Item -Path "C:\s3-downloads\" -Name "agent_folder" -ItemType "directory"
      Write-Log -Message "Created agent_folder folder to store Agent files."
      [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls, [Net.SecurityProtocolType]::Tls11, [Net.SecurityProtocolType]::Tls12, [Net.SecurityProtocolType]::Ssl3
      $uri = "https://us.storage.endpoint.ingress.rapid7.com/com.rapid7.razor.public/endpoint/agent/latest/windows/x86_64/rapid7_ngav_x64.zip"
      $out = "c:\s3-downloads\agent_folder\rapid7_ngav_x64.zip"
      Invoke-WebRequest -Uri $uri -OutFile $out
      Expand-Archive -Path $out -DestinationPath "c:\s3-downloads\agent_folder\rapid7_ngav_x64"
      Start-Sleep -Seconds 10
      if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
          Start-Process -FilePath "cmd.exe" -ArgumentList "/C `"`"C:\s3-downloads\agent_folder\rapid7_ngav_x64\rapid7_endpoint_prevention_installer.bat`" CUSTOMTOKEN=$Token`"" -Verb RunAs -WorkingDirectory "C:\s3-downloads\agent_folder\rapid7_ngav_x64\" -Wait
          Exit
      }
      Start-Process -FilePath "cmd.exe" -ArgumentList "/C `"`"C:\s3-downloads\agent_folder\rapid7_ngav_x64\rapid7_endpoint_prevention_installer.bat`" CUSTOMTOKEN=$Token`"" -Verb RunAs -WorkingDirectory "C:\s3-downloads\agent_folder\rapid7_ngav_x64\" -Wait
      Write-Log -Message "Installation NGAV Insight Agent for Token : $Token"
    } else {
      Write-Log -Message "Insight Agent already installed."
    }
  } elseif ($Agent_Type -eq "agent") {
    $service = Get-Service -Name ir_agent -ErrorAction SilentlyContinue
    if($service -eq $null){
      New-Item -Path "C:\s3-downloads\" -Name "agent_folder" -ItemType "directory"
      Write-Log -Message "Created agent_folder folder to store Agent files."
      [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls, [Net.SecurityProtocolType]::Tls11, [Net.SecurityProtocolType]::Tls12, [Net.SecurityProtocolType]::Ssl3
      [Net.ServicePointManager]::SecurityProtocol = "Tls, Tls11, Tls12, Ssl3"   
      $uri = "https://s3.amazonaws.com/com.rapid7.razor.public/endpoint/agent/latest/windows/x86_64/PyForensicsAgent-x64.msi"
      $out = "c:\s3-downloads\agent_folder\PyForensicsAgent-x64.msi"
      Invoke-WebRequest -uri $uri -OutFile $out
      msiexec /i c:\s3-downloads\agent_folder\PyForensicsAgent-x64.msi /l*v c:\s3-downloads\agent_folder\installation.log CUSTOMTOKEN=$Token /quiet 
      Write-Log -Message "Installation Insight Agent for Token : $Token"
    } else {
      Write-Log -Message "Insight Agent already installed."
    }
  } else {
    Write-Log -Message "No installation required for $Agent_Type."
  }