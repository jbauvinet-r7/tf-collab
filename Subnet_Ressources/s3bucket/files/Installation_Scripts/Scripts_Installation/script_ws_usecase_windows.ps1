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
Set-ExecutionPolicy Bypass -Scope Process -Force
$ScenarioArray = $Scenario -split ',' 
if ($null -eq $Scenario -or $Scenario.Count -eq 0 -or $Scenario -eq "0") {
    Write-Log -Message "No Use Case launched"
} else {
    foreach ($Scenario_Value in $ScenarioArray) {
        Write-Log -Message "Installing Use Case $Scenario_Value"
        Write-Log -Message "Executing Use Case because Scenario is not 0"
        $lgexepath = "C:\s3-downloads\UseCases_Scripts\UseCase_$Scenario_Value\Attack_0${Scenario_Value}_start.ps1"
        if (-not(Test-Path $lgexepath))
        {
            New-Item -Path "C:\s3-downloads\" -Name "UseCases_Scripts" -ItemType "directory"
            aws s3 cp s3://$Bucket_Name/UseCases_Scripts/UseCase_$Scenario_Value.zip C:\s3-downloads\UseCases_Scripts
            Expand-Archive C:\s3-downloads\UseCases_Scripts\UseCase_$Scenario_Value.zip -DestinationPath C:\s3-downloads\UseCases_Scripts -Force 
            Remove-Item -Path "C:\s3-downloads\UseCases_Scripts\UseCase_$Scenario_Value.zip"
        } else {
            Write-Log -Message "Use Case $Scenario_Value already extracted"
        }
        # Define the task name and action
        $taskName = "Attack scenario $Scenario_Value"
        # Check if the scheduled task exists
        $task = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
        if ($task) {
            # Unregister (delete) the task if it exists
            Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
            Write-Log -Message "Scheduled task '$taskName' has been deleted."
        } else {
            Write-Log -Message "Scheduled task '$taskName' does not exist."
        }
        # Define the task name and action
        $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File 'C:\s3-downloads\UseCases_Scripts\UseCase_$Scenario_Value\Files\Attack_0${Scenario_Value}_start.ps1'  -Coll_IP $Coll_IP -Instance_IP1 $Instance_IP1 -User_Account $User_Account -ZoneName $ZoneName -DomainName $DomainName -DomainNetbiosName $DomainNetbiosName -ServerName $ServerName -PhishingName $PhishingName"
        if ($Scenario_Value -eq "1") {
            $trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At "08:00AM"
        } elseif ($Scenario_Value -eq "2") {
            $trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Tuesday -At "08:00AM"
        } elseif ($Scenario_Value -eq "3") {
            $trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Thursday -At "08:00AM"
        } elseif ($Scenario_Value -eq "4") {
            $trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At "08:00AM"
        } else {
            Write-Host "No valid scenario selected. No trigger created."
        }
        # Define the principal to run as a specific user (replace with the actual username)
        $user = "$DomainNetbiosName\$User_Account"
        $principal = New-ScheduledTaskPrincipal -UserId $user -LogonType Password -RunLevel Highest
        # Define the task settings (without stopping the task if it runs too long)
        $settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit 0
        # Check if the scheduled task exists
        if (-not (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue)) {
            # Register the task if it doesn't exist
            $Task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings -Principal $principal
            $Task | Register-ScheduledTask -TaskName $taskName -User $user -Password $idr_service_account_pwd  
            #Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $taskName -Description "Starts Log Generator at startup" -Settings $settings -User $user -Password $SecureAdminSafeModePassword
            Write-Log -Message "Scheduled task '$taskName' has been created."
            # Start the task
            Start-ScheduledTask -TaskName $taskName
            Write-Log -Message "Scheduled task '$taskName' has been started."
        } else {
            Write-Log -Message "Scheduled task '$taskName' already exists."
        }
        $taskName = "Trigger FIM"
        # Check if the scheduled task exists
        $task = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
        if ($task) {
            # Unregister (delete) the task if it exists
            Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
            Write-Log -Message "Scheduled task '$taskName' has been deleted."
        } else {
            Write-Log -Message "Scheduled task '$taskName' does not exist."
        }
        # Define the task name and action
        $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File 'C:\s3-downloads\UseCases_Scripts\UseCase_$Scenario_Value\Files\FIM_event.ps1'"
        $trigger = New-ScheduledTaskTrigger -Daily -At "09:00AM"
        # Define the principal to run as a specific user (replace with the actual username)
        $user = "$DomainNetbiosName\$User_Account"
        $principal = New-ScheduledTaskPrincipal -UserId $user -LogonType Password -RunLevel Highest
        # Define the task settings (without stopping the task if it runs too long)
        $settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit 0
        # Check if the scheduled task exists
        if (-not (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue)) {
            # Register the task if it doesn't exist
            $Task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings -Principal $principal
            $Task | Register-ScheduledTask -TaskName $taskName -User $user -Password $idr_service_account_pwd  
            #Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $taskName -Description "Starts Log Generator at startup" -Settings $settings -User $user -Password $SecureAdminSafeModePassword
            Write-Log -Message "Scheduled task '$taskName' has been created."
            # Start the task
            Start-ScheduledTask -TaskName $taskName
            Write-Log -Message "Scheduled task '$taskName' has been started."
        } else {
            Write-Log -Message "Scheduled task '$taskName' already exists."
        }
        $taskName = "Trigger FIM Finance"
        # Check if the scheduled task exists
        $task = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
        if ($task) {
            # Unregister (delete) the task if it exists
            Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
            Write-Log -Message "Scheduled task '$taskName' has been deleted."
        } else {
            Write-Log -Message "Scheduled task '$taskName' does not exist."
        }
        # Define the task name and action
        $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File 'C:\s3-downloads\UseCases_Scripts\UseCase_$Scenario_Value\Files\FIM_event_finance.ps1'"
        $trigger = New-ScheduledTaskTrigger -Daily -At "02:00PM"
        # Define the principal to run as a specific user (replace with the actual username)
        $user = "$DomainNetbiosName\$User_Account"
        $principal = New-ScheduledTaskPrincipal -UserId $user -LogonType Password -RunLevel Highest
        # Define the task settings (without stopping the task if it runs too long)
        $settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit 0
        # Check if the scheduled task exists
        if (-not (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue)) {
            # Register the task if it doesn't exist
            $Task = New-ScheduledTask -Action $action -Trigger $trigger -Settings $settings -Principal $principal
            $Task | Register-ScheduledTask -TaskName $taskName -User $user -Password $idr_service_account_pwd  
            #Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $taskName -Description "Starts Log Generator at startup" -Settings $settings -User $user -Password $SecureAdminSafeModePassword
            Write-Log -Message "Scheduled task '$taskName' has been created."
            # Start the task
            Start-ScheduledTask -TaskName $taskName
            Write-Log -Message "Scheduled task '$taskName' has been started."
        } else {
            Write-Log -Message "Scheduled task '$taskName' already exists."
        }
        
    }
}