#Execution Policy
Set-ExecutionPolicy Bypass -Force
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
Set-ExecutionPolicy -Scope CurrentUser Bypass -Force
Set-ExecutionPolicy -Scope LocalMachine Bypass -Force 

#Install default users + pwd
Start-Sleep -s 180
start-service ADWS 
Import-Module ActiveDirectory
$password = ConvertTo-SecureString "6r%V@FmSGVny" -AsPlainText -Force
Set-LocalUser -Name Administrator -Password $password
$NewPassword = ConvertTo-SecureString "6r%V@FmSGVny" -AsPlainText -Force
Set-ADAccountPassword -Identity Administrator -NewPassword $NewPassword -Reset
New-ADUser -Name "Rapid7" -GivenName "Rapid7" -Surname "Rapid7" -SamAccountName "Rapid7" -AccountPassword(ConvertTo-SecureString "6r%V@FmSGVny" -AsPlainText -force) -Enabled $true
Add-ADGroupMember -Identity "Domain Admins" -Members Rapid7

#BasicUser
New-ADUser -Name "Zinedine Zidane" -GivenName "Zinedine" -Surname "Zidane" -SamAccountName "zzidane" -AccountPassword(ConvertTo-SecureString "6r%V@FmSGVny" -AsPlainText -force) -Enabled $false


#AgentInstallation
$uri = "https://s3.amazonaws.com/com.rapid7.razor.public/endpoint/agent/latest/windows/x86_64/PyForensicsAgent-x64.msi"
$out = "c:\s3-downloads\agent_folder\PyForensicsAgent-x64.msi"
Invoke-WebRequest -uri $uri -OutFile $out

#Script Folder
New-Item -Path "C:\" -Name "scripts" -ItemType "directory"

#Install and configure winRM
$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
powershell.exe -ExecutionPolicy ByPass -File $file