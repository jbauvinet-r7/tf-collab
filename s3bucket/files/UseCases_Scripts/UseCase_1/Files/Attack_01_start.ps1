#Set-MpPreference -DisableRealtimeMonitoring 1
#Sleep 20
param (
    [string]$Coll_IP,
    [string]$Instance_IP1,
    [string]$User_Account,
    [string]$ZoneName,
    [string]$DomainName,
    [string]$DomainNetbiosName,
    [string]$ServerName,
    [string]$PhishingName
    )
Start-Process PowerShell.exe -ArgumentList "-File 'C:\s3-downloads\UseCases_Scripts\UseCase_1\Files\Attack_01.ps1' -Coll_IP $Coll_IP -Instance_IP1 $Instance_IP1 -User_Account $User_Account -ZoneName $ZoneName -DomainName $DomainName -DomainNetbiosName $DomainNetbiosName -ServerName $ServerName -PhishingName $PhishingName"