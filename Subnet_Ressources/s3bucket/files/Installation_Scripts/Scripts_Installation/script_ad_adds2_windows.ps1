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
  if (-not(Test-Path "C:\ADDS"))
{
    New-Item -Path "C:\" -Name "ADDS" -ItemType "directory"
    Write-Log -Message "Created ADDS folder to store log file."
} else {
    Write-Log -Message "ADDS Folder already exists."
}
  Set-ExecutionPolicy Bypass -Scope Process -Force
  $Password = "$AdminPD" | ConvertTo-SecureString -AsPlainText -Force
  # Remote Desktop Variable
  $enablerdp = 'yes' # to enable RDP, set this variable to yes. to disable RDP, set this variable to no
  # Disable IE Enhanced Security Configuration Variable
  $disableiesecconfig = 'yes' # to disable IE Enhanced Security Configuration, set this variable to yes. to leave enabled, set this variable to no
  $globalsubnet = '10.0.10.0/24' # Global Subnet will be used in DNS Reverse Record and AD Sites and Services Subnet
  $subnetlocation = 'Boston'
  # Set RDP
  Try{
      IF ($enablerdp -eq "yes")
          {
          Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server'-name "fDenyTSConnections" -Value 0 -ErrorAction Stop
          Enable-NetFirewallRule -DisplayGroup "Remote Desktop" -ErrorAction Stop
          Write-Log -Message "RDP Successfully enabled"
          }
      }
  Catch{
       Write-Log -Message $("Failed to enable RDP. Error: "+ $_.Exception.Message)
       Break;
       }
  
  IF ($enablerdp -ne "yes")
      {
      Write-Log -Message "RDP remains disabled"
      }
  
  # Disable IE Enhanced Security Configuration 
  Try{
      IF ($disableiesecconfig -eq "yes")
          {
          Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}' -name IsInstalled -Value 0 -ErrorAction Stop
          Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}' -name IsInstalled -Value 0 -ErrorAction Stop
          Write-Log -Message "IE Enhanced Security Configuration successfully disabled for Admin and User"
          }
      }
  Catch{
       Write-Log -Message $("Failed to disable Ie Security Configuration. Error: "+ $_.Exception.Message)
       Break;
       }
  
  If ($disableiesecconfig -ne "yes")
      {
      Write-Log -Message "IE Enhanced Security Configuration remains enabled"
      }
  # Install Active Directory Services
  Try{
      Add-WindowsFeature AD-Domain-Services -ErrorAction Stop
      Install-WindowsFeature RSAT-ADDS -ErrorAction Stop
      Write-Log -Message "Active Directory Domain Services installed successfully"
      }
  Catch{
       Write-Log -Message $("Failed to install Active Directory Domain Services. Error: "+ $_.Exception.Message)
       Break;
       }
  
  # Configure Active Directory
  Try{
      Set-ExecutionPolicy Bypass -Scope Process -Force
      Import-Module ADDSDeployment
      Install-ADDSForest -DomainName $DomainName -SafeModeAdministratorPassword $Password -ErrorAction Stop -NoRebootOnCompletion -Force
      Write-Log -Message "Active Directory Domain Services have been configured successfully"
      }
  Catch{
       Write-Log -Message $("Failed to configure Active Directory Domain Services. Error: "+ $_.Exception.Message)
       Break;
       }
  Sleep 30
  # Add DNS Reverse Record
  Try{
      Add-DnsServerPrimaryZone -NetworkId $globalsubnet -DynamicUpdate Secure -ReplicationScope Domain -ErrorAction Stop
      Write-Log -Message "Successfully added in $($globalsubnet) as a reverse lookup within DNS"
      }
  Catch{
       Write-Log -Message $("Failed to create reverse DNS lookups zone for network $($globalsubnet). Error: "+ $_.Exception.Message)
       Break;
       }
  
  # Add DNS Scavenging
  Set-DnsServerScavenging -ScavengingState $true -ScavengingInterval 7.00:00:00 -Verbose
  Set-DnsServerZoneAging $DomainName -Aging $true -RefreshInterval 7.00:00:00 -NoRefreshInterval 7.00:00:00 -Verbose
  Set-DnsServerZoneAging 10.0.10.in-addr.arpa -Aging $true -RefreshInterval 7.00:00:00 -NoRefreshInterval 7.00:00:00 -Verbose
  Get-DnsServerScavenging
  
  # Create Active Directory Sites and Services Subnet
  Try{
      New-ADReplicationSubnet -Name $globalsubnet -Site "$Tenant" -Location $subnetlocation -ErrorAction Stop
      Write-Log -Message "Successfully added Subnet $($globalsubnet) with location $($subnetlocation) in AD Sites and Services"
      }
  Catch{
       Write-Log -Message $("Failed to create Subnet $($globalsubnet) in AD Sites and Services. Error: "+ $_.Exception.Message)
       Break;
       }
  Try{
      Restart-Computer -ComputerName $env:computername -ErrorAction Stop
      Write-Log -Message "Rebooting Now!!"
      }
  Catch{
      Write-Log -Message $("Failed to restart computer $($env:computername). Error: "+ $_.Exception.Message)
      Break;
      } 
  