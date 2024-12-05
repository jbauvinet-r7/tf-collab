<powershell>
#Read input variables
$R7_Region                      = "${R7_Region}"
$AWS_Region                     = "${AWS_Region}"
$ServerName                     = "${ServerName}"
$AD_IP                          = "${AD_IP}"
$TimeZoneID                     = "${TimeZoneID}"
$Bucket_Name                    = "${Bucket_Name}"
$DatabasePath                   = "${DatabasePath}"
$ZoneName                       = "${ZoneName}"
$ZoneNameNetbiosName            = $ZoneName.Split(".") | Select -First 1
$ZoneNameExt                    =  $ZoneName.Split(".")[1]
$DomainName                     = "${DomainName}"
$DomainNetbiosName              = $DomainName.Split(".") | Select -First 1
$DomainExt                      =  $DomainName.Split(".")[1]
$ForestMode                     = "${ForestMode}"
$DomainMode                     = "${DomainMode}"
$SYSVOLPath                     = "${SYSVOLPath}"
$LogPath                        = "${LogPath}"
$Token                          = "${Token}"
$AdminUser                      = "${AdminUser}"
$AdminPD_ID                     = "${AdminPD_ID}"
$idr_service_account            = "${idr_service_account}"
$idr_service_account_pwd_ID     = "${idr_service_account_pwd_ID}"
$AdminSafeModePassword_ID       = "${AdminSafeModePassword_ID}"
$VR_Agent_File                  = "${VR_Agent_File}"
$Instance_IP1                   = "${Instance_IP1}"
$Instance_IP2                   = "${Instance_IP2}"
$Instance_Mask                  = "${Instance_Mask}"
$Instance_GW                    = "${Instance_GW}"
$Instance_AWSGW                 = "${Instance_AWSGW}"
$Agent_Type                     = "${Agent_Type}"
$SEOPS_VR_Install               = "${SEOPS_VR_Install}"
if ($SEOPS_VR_Install -eq "true") {
    $SEOPS_VR_Install = $true
}
$Coll_IP                        = "${Coll_IP}"
$Orch_IP                        = "${Orch_IP}"
$SiteName                       = "${SiteName}"
$SiteName_RODC                  = "${SiteName_RODC}"
$RODCServerName                 = "${RODCServerName}"
$RODC_IP                        = "${RODC_IP}"
$Username                       = '$DomainNetbiosName\$idr_service_account'
$ScriptList                     = "${join(",", "${ScriptList}")}"
#$Scripts                       = $ScriptList | ConvertTo-Json
$Scripts                        = $ScriptList -split ',' 
$User_Account                   = "${User_Account}"
$Keyboard_Layout                = "${Keyboard_Layout}"
$Routing_Type                   = "${Routing_Type}"
$Deployment_Mode                = "${Deployment_Mode}"
$User_Lists                     = "${join(",", "${User_Lists}")}"
$VRM_License_Key                = "${VRM_License_Key}"
$Scenario                       = "${join(",", "${Scenario}")}"
$PhishingName                   = "${PhishingName}"

#Function to store log data
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
if (-not(Test-Path "C:\UserDataLog"))
{
    Write-Log -Message "<<<<<<<<<<<<<<<===============================================>>>>>>>>>>>>>>>"
    Write-Log -Message "Starting Installation Script"
    Write-Log -Message "Userdata script is stored at : $PSScriptRoot"
    New-Item -ItemType directory -Path "C:\UserDataLog"
    Write-Log -Message "Created Log folder to store log file."
} else {
    Write-Log -Message "Starting Installation Script"
    Write-Log -Message "Userdata script is stored at : $PSScriptRoot"
    Write-Log -Message "Log Folder already exists."
}
Set-ExecutionPolicy Bypass -Scope Process -Force
$FilePath = "c:\UserDataLog\sleep_done.txt"
#Check if file exists in given path
If (Test-Path -path $FilePath -PathType Leaf) {
    Write-Log -Message "Sleep Already Done"
} Else {
    Write-Log -Message "Sleep Time 10 minutes, please wait.."
    Start-Sleep -Seconds 600;
}
# Check for awscliv2 executable existence
$awscliv2Path = Test-Path -Path "C:\Program Files\Amazon\AWSCLIV2\aws.exe" -PathType Leaf
# Output result based on the check
if ($awscliv2Path) {
    Write-Log -Message "AWS CLI v2 (awscliv2) is installed."
  } else {
    Write-Log -Message "AWS CLI v2 (awscliv2) is not installed."
    Set-ExecutionPolicy UnRestricted -Force
    $command = "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12"
    Invoke-Expression $command
    Invoke-WebRequest -Uri "https://awscli.amazonaws.com/AWSCLIV2.msi" -Outfile C:\AWSCLIV2.msi
    $arguments = "/i `"C:\AWSCLIV2.msi`" /quiet"
    Start-Process msiexec.exe -ArgumentList $arguments -Wait
    Write-Log -Message "AWS CLI v2 (awscliv2) is now installed."
  }
  if (-not(Test-Path "C:\s3-downloads\Scripts_Installation"))
  {
    #New-Item -Path "C:\s3-downloads\" -Name "Scripts_Installation" -ItemType "directory"
    Write-Log -Message "Created the Scripts Installation folder to store Installation Scripts."
    Write-Log -Message "Getting the Installation Scripts."
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
    aws s3 cp s3://$Bucket_Name/Installation_Scripts/Scripts_Installation.zip C:\s3-downloads\
    Expand-Archive C:\s3-downloads\Scripts_Installation.zip -DestinationPath C:\s3-downloads\ -Force
    Remove-Item C:\s3-downloads\Scripts_Installation.zip
    } else {
    Write-Log -Message "Scripts_Installation Folder already exists, overwrite in progress."
    Write-Log -Message "Getting the Installation Scripts."
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine")
    aws s3 cp s3://$Bucket_Name/Installation_Scripts/Scripts_Installation.zip C:\s3-downloads\
    Expand-Archive C:\s3-downloads\Scripts_Installation.zip -DestinationPath C:\s3-downloads\ -Force
    Remove-Item C:\s3-downloads\Scripts_Installation.zip
  } 
$idr_service_account_pwd=aws secretsmanager get-secret-value --output text --query SecretString --region $AWS_Region --secret-id $idr_service_account_pwd_ID
$AdminPD=aws secretsmanager get-secret-value --output text --query SecretString --region $AWS_Region --secret-id $AdminPD_ID
$AdminSafeModePassword=aws secretsmanager get-secret-value --output text --query SecretString --region $AWS_Region --secret-id $AdminSafeModePassword_ID
$SecureAdminSafeModePassword    = ConvertTo-SecureString -String $AdminSafeModePassword -AsPlainText -Force
$mycreds= New-Object System.Management.Automation.PSCredential ($idr_service_account, $SecureAdminSafeModePassword)
# Define the path to the child script directory (ensure it ends with a backslash)
$childScriptPath = "C:\s3-downloads\Scripts_Installation\"
# List of script names without the .ps1 extension (modify as needed)
# Loop through child scripts and execute them
foreach ($ScriptName in $Scripts) {
    Write-Log -Message "Launching $ScriptName"
    # Construct the full script path
    $fullPath = Join-Path $childScriptPath ($ScriptName + ".ps1")
    if (Test-Path $fullPath) {
        # Build argument list
        $arguments = @{}
        # Check and set arguments with non-empty values
        if ($R7_Region) { $arguments["R7_Region"] = $R7_Region }
        if ($AWS_Region) { $arguments["AWS_Region"] = $AWS_Region }
        if ($ServerName) { $arguments["ServerName"] = $ServerName }
        if ($AD_IP) { $arguments["AD_IP"] = $AD_IP }
        if ($TimeZoneID) { $arguments["TimeZoneID"] = $TimeZoneID }
        if ($Bucket_Name) { $arguments["Bucket_Name"] = $Bucket_Name }
        if ($DatabasePath) { $arguments["DatabasePath"] = $DatabasePath }
        if ($ZoneName) { $arguments["ZoneName"] = $ZoneName }
        if ($ZoneNameNetbiosName) { $arguments["ZoneNameNetbiosName"] = $ZoneNameNetbiosName }
        if ($ZoneNameExt) { $arguments["ZoneNameExt"] = $ZoneNameExt }
        if ($DomainName) { $arguments["DomainName"] = $DomainName }
        if ($DomainNetbiosName) { $arguments["DomainNetbiosName"] = $DomainNetbiosName }
        if ($DomainExt) { $arguments["DomainExt"] = $DomainExt }
        if ($ForestMode) { $arguments["ForestMode"] = $ForestMode }
        if ($DomainMode) { $arguments["DomainMode"] = $DomainMode }
        if ($SYSVOLPath) { $arguments["SYSVOLPath"] = $SYSVOLPath }
        if ($LogPath) { $arguments["LogPath"] = $LogPath }
        if ($Token) { $arguments["Token"] = $Token }
        if ($AdminUser) { $arguments["AdminUser"] = $AdminUser }
        if ($AdminPD) { $arguments["AdminPD"] = $AdminPD }
        if ($idr_service_account) { $arguments["idr_service_account"] = $idr_service_account }
        if ($idr_service_account_pwd) { $arguments["idr_service_account_pwd"] = $idr_service_account_pwd }
        if ($SecureAdminSafeModePassword) { $arguments["SecureAdminSafeModePassword"] = $SecureAdminSafeModePassword }
        if ($VR_Agent_File) { $arguments["VR_Agent_File"] = $VR_Agent_File }
        if ($Instance_IP1) { $arguments["Instance_IP1"] = $Instance_IP1 }
        if ($Instance_IP2) { $arguments["Instance_IP2"] = $Instance_IP2 }
        if ($Instance_Mask) { $arguments["Instance_Mask"] = $Instance_Mask }
        if ($Instance_GW) { $arguments["Instance_GW"] = $Instance_GW }
        if ($Instance_AWSGW) { $arguments["Instance_AWSGW"] = $Instance_AWSGW }
        if ($Agent_Type) { $arguments["Agent_Type"] = $Agent_Type }
        if ($SEOPS_VR_Install) { $arguments["SEOPS_VR_Install"] = $SEOPS_VR_Install }
        if ($Coll_IP) { $arguments["Coll_IP"] = $Coll_IP }
        if ($Orch_IP) { $arguments["Orch_IP"] = $Orch_IP }
        if ($mycreds) { $arguments["mycreds"] = $mycreds }
        if ($SiteName) { $arguments["SiteName"] = $SiteName }
        if ($SiteName_RODC) { $arguments["SiteName_RODC"] = $SiteName_RODC }
        if ($RODCServerName) { $arguments["RODCServerName"] = $RODCServerName }
        if ($RODC_IP) { $arguments["RODC_IP"] = $RODC_IP }
        if ($Username) { $arguments["Username"] = $Username }
        if ($User_Account) { $arguments["User_Account"] = $User_Account }
        if ($Keyboard_Layout) { $arguments["Keyboard_Layout"] = $Keyboard_Layout }
        if ($Routing_Type) { $arguments["Routing_Type"] = $Routing_Type }
        if ($Deployment_Mode) { $arguments["Deployment_Mode"] = $Deployment_Mode }
        if ($User_Lists) { $arguments["User_Lists"] = $User_Lists}
        if ($VRM_License_Key) { $arguments["VRM_License_Key"] = $VRM_License_Key}
        if ($Scenario) { $arguments["Scenario"] = $Scenario}
        if ($PhishingName) { $arguments["PhishingName"] = $PhishingName}
        # Debug output to check variables
        Write-Host "Script: $fullPath"
        foreach ($key in $arguments.Keys) {
            Write-Host "$key : $($arguments[$key])"
        }
        # Execute the script with arguments
        & $fullPath @arguments
        Write-Log -Message "$ScriptName Deployed"
    }
}
Write-Log -Message "GPUpdate"
gpupdate /force
# Final log message
Write-Log -Message "Installation Completed - Nothing To Do"
Write-Log -Message "<<<<<<<<<<<<<<<===============================================>>>>>>>>>>>>>>>"
</powershell>
<persist>true</persist>