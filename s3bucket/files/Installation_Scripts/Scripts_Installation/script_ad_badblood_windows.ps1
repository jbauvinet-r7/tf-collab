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

if (-not(Test-Path 'C:\adusers_list.csv'))
{
    New-Item -Path "C:\s3-downloads\" -Name "BadBlood" -ItemType "directory"
    aws s3 cp s3://$Bucket_Name/BadBlood/BadBlood.zip C:\s3-downloads\
    Expand-Archive C:\s3-downloads\BadBlood.zip -DestinationPath C:\s3-downloads\BadBlood
    c:\s3-downloads\BadBlood\BadBlood\invoke-badblood.ps1
    $ExportPath = 'c:\adusers_list.csv'
    Get-ADUser -Filter * | Select-object DistinguishedName,Name,UserPrincipalName | Export-Csv -NoType $ExportPath
    aws s3 cp s3://$Bucket_Name/BadBlood/transform_data_2.ps1 C:\s3-downloads\
    c:\s3-downloads\transform_data_2.ps1
     # Set the distinguished name (DN) of the container where computers are located
    $containerDN = "CN=Computers,DC=$DomainNetbiosName,DC=$DomainExt"
    $computersInFolder = Get-ADComputer -Filter * -SearchBase $containerDN | Select-Object -ExpandProperty Name
    $allComputers = Get-ADComputer -Filter * | Select-Object -ExpandProperty Name
    $computersToDelete = Compare-Object -ReferenceObject $allComputers -DifferenceObject $computersInFolder |
                        Where-Object { $_.SideIndicator -eq '<=' } |
                        Select-Object -ExpandProperty InputObject
    foreach ($computerName in $computersToDelete) {
        Write-Host "Deleting computer: $computerName"
        Remove-ADComputer -Identity $computerName -Confirm:$false
    } 
    $computers = Import-Csv -Path "C:\users.csv"
    foreach ($computer in $computers) {
        $computerName = $computer.userworkstation
        Write-Host "Creating computer: $computerName"
        New-ADComputer -Name $computerName
} 
} else {
    Write-Log -Message "BadBlood already installed"
}
Remove-ADGroupMember -Identity "Protected Users" -Members $idr_service_account -Confirm:$false 
Remove-ADGroupMember -Identity "Protected Users" -Members $AdminUser -Confirm:$false 
Remove-ADGroupMember -Identity "Protected Users" -Members "Administrator" -Confirm:$false
Remove-ADGroupMember -Identity "Protected Users" -Members $User_Account -Confirm:$false


