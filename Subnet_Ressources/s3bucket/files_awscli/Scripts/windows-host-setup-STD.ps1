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