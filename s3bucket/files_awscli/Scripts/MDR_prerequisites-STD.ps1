#ExecutionPolicy
Set-ExecutionPolicy Bypass -Force
Set-ExecutionPolicy -Scope Process Bypass -Force
Set-ExecutionPolicy -Scope CurrentUser Bypass -Force
Set-ExecutionPolicy -Scope LocalMachine Bypass -Force 

#BasicUsers+WinRM
New-LocalUser -AccountNeverExpires:$true -Password ( ConvertTo-SecureString -AsPlainText -Force "6r%V@FmSGVny") -Name "Rapid7" | Add-LocalGroupMember -Group Administrators
$password = ConvertTo-SecureString "6r%V@FmSGVny" -AsPlainText -Force
Set-LocalUser -Name Administrator -Password $password
$NewPassword = ConvertTo-SecureString "6r%V@FmSGVny" -AsPlainText -Force
Set-ADAccountPassword -Identity Administrator -NewPassword $NewPassword -Reset

#AgentInstallation
New-Item "c:\agent_folder" -itemType Directory
New-Item -ItemType File -Path 'C:\agent_folder' -Name installation.bat
$uri = "https://s3.amazonaws.com/com.rapid7.razor.public/endpoint/agent/latest/windows/x86_64/PyForensicsAgent-x64.msi"
$out = "c:\agent_folder\PyForensicsAgent-x64.msi"
Invoke-WebRequest -uri $uri -OutFile $out

#PhishingScript
New-Item -ItemType File -Path 'C:\Users\Public\Documents\' -Name system.ps1

#REvilScript
New-Item -Path "C:\Users\Administrator" -Name "%TMP%" -ItemType "directory"
New-Item -ItemType File -Path 'C:\Users\Administrator\%TMP%\' -Name mppreference_status.txt