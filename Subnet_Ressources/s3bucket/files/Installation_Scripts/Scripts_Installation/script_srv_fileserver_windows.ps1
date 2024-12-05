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


if (-not(Test-Path "C:\s3-downloads\FileServer"))
{   
    New-Item -Path "C:\s3-downloads\" -Name "FileServer" -ItemType "directory"
    Write-Log -Message "Created FileServer folder to store FileServer files."
    Write-Log -Message "Getting FileServer files from S3 Bucket."
    Set-ExecutionPolicy UnRestricted -Force
    $command = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12"
    Invoke-Expression $command
    Invoke-WebRequest -Uri "https://awscli.amazonaws.com/AWSCLIV2.msi" -Outfile C:\AWSCLIV2.msi
    $arguments = "/i `"C:\AWSCLIV2.msi`" /quiet"
    Start-Process msiexec.exe -ArgumentList $arguments -Wait
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
    aws s3 cp s3://$Bucket_Name/FilesServer_Scripts/sample_files_server.zip C:\s3-downloads\FileServer\
    Expand-Archive C:\s3-downloads\FileServer\sample_files_server.zip -DestinationPath C:\s3-downloads\FileServer\sample_files_server
} else {
    Write-Log -Message "FileServer Folder already exists."
}
# Check if File Server Role is installed
if (-not (Get-WindowsFeature -Name File-Services).Installed) {
    Install-WindowsFeature -Name File-Services -IncludeManagementTools
} else {
    Write-Log -Message "File Server Role is already installed."
}
$requiredFeatures = "FS-FileServer", "RSAT-File-Services"
foreach ($feature in $requiredFeatures) {
    if (-not (Get-WindowsFeature -Name $feature).Installed) {
        Install-WindowsFeature -Name $feature
        Write-Log -Message "$feature installed."
    } else {
        Write-Log -Message "$feature is already installed."
    }
}
$departments = @(
    "IT", "HR", "Finance", "RD", "Sales", "Marketing",
    "Administrative", "Accounting", "Production", "Support", 
    "Quality", "Operations", "Distribution", "Design", "Stores"
)
# Specify the base path for the shared folders
if (-not(Test-Path "C:\SharedFolders"))
{   
    New-Item -Path "C:\" -Name "SharedFolders" -ItemType "directory"
    Write-Log -Message "Created SharedFolders folder to store SharedFolders files."
} else {
    Write-Log -Message "SharedFolders Folder already exists."
}
$baseFolderPath = "C:\SharedFolders"
$sourceFolderPath = "C:\s3-downloads\FileServer\sample_files_server\sample_files_server"
foreach ($department in $departments) {
    $sourceDepartmentPath = Join-Path $sourceFolderPath $department
    $destinationFolderPath = Join-Path $baseFolderPath $department
    if (Test-Path $sourceDepartmentPath -PathType Container) {
        Write-Log -Message "Source folder $sourceDepartmentPath will be created."
        Copy-Item -Path $sourceDepartmentPath -Destination $destinationFolderPath -Recurse -Force
    } else {
        Write-Log -Message "Source folder $sourceDepartmentPath does not exist for department $department."
    }
    if (-not (Get-SmbShare -Name "Share_$department" -ErrorAction SilentlyContinue)) {
        Write-Log -Message "Share Share_$department will be created."
        New-SmbShare -Name "Share_$department" -Path $destinationFolderPath -FullAccess "Everyone"
    } else {
        Write-Log -Message "Share Share_$department already exists."
    }
}