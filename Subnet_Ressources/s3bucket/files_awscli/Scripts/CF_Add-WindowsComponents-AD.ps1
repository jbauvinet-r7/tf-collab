Add-WindowsFeature -Name RSAT-AD-PowerShell
Add-WindowsFeature -Name AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools
Add-WindowsFeature -Name DNS -IncludeAllSubFeature -IncludeManagementTools
Add-WindowsFeature -Name GPMC -IncludeAllSubFeature -IncludeManagementTools