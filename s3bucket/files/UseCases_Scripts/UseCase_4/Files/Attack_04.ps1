
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
    
# Create a UDP Client Object
$UDPCLient = New-Object System.Net.Sockets.UdpClient
#Type of encoding that will be used for the syslog
$Encoding = [System.Text.Encoding]::ASCII
#UTM logs site 1
#Firewall log
    $Timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $Timestamp2 = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    $UnixTimestamp = [int][double]::Parse((Get-Date).ToUniversalTime().Subtract((Get-Date "1970-01-01")).TotalSeconds)
    # Assemble the full syslog formatted message
    $IP="172.232.21.144"
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
    $IP="172.232.21.144"
    $Port="443"
    $URL="tiktok.com"
    $FullSyslogMessage = "T$UnixTimestamp <14>$Timestamp ${DomainNetbiosName}_PA 1,$Timestamp2,000000000707,THREAT,url,7,$Timestamp2,$Instance_IP1,$IP,$IP,$IP,DynamicDefault,$User_Account,,web-browsing,vsys1,Trust,Untrust,ethernet1/2,ethernet1/1,default,$Timestamp2,976,1,1126,$Port,38931,80,0x40,tcp,block-url,$URL,-9999,blocked-sites,informational,0,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, "
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20003)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
#DNS log
    #Define the message    
    $URL="tiktok.com"
    $DNSDomain = "tiktok.com"
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
    Sleep 10

#UTM logs site 2
#Firewall log
    $Timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $Timestamp2 = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    $UnixTimestamp = [int][double]::Parse((Get-Date).ToUniversalTime().Subtract((Get-Date "1970-01-01")).TotalSeconds)
    # Assemble the full syslog formatted message
    $IP="45.143.138.243"
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
    $IP="45.143.138.243"
    $Port="443"
    $URL="worksafe.tiktok.com"
    $FullSyslogMessage = "T$UnixTimestamp <14>$Timestamp ${DomainNetbiosName}_PA 1,$Timestamp2,000000000707,THREAT,url,7,$Timestamp2,$Instance_IP1,$IP,$IP,$IP,DynamicDefault,$User_Account,,web-browsing,vsys1,Trust,Untrust,ethernet1/2,ethernet1/1,default,$Timestamp2,976,1,1126,$Port,38931,80,0x40,tcp,block-url,$URL,-9999,blocked-sites,informational,0,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, "
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20003)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
#DNS log
    #Define the message    
    $URL="worksafe.tiktok.com"
    $DNSDomain = "worksafe.tiktok.com"
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
    Sleep 10

#UTM logs site 3
#Firewall log
    $Timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $Timestamp2 = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    $UnixTimestamp = [int][double]::Parse((Get-Date).ToUniversalTime().Subtract((Get-Date "1970-01-01")).TotalSeconds)
    # Assemble the full syslog formatted message
    $IP="80.255.3.85"
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
    $IP="80.255.3.85"
    $Port="443"
    $URL="webdisk.tiktokanalytics.net"
    $FullSyslogMessage = "T$UnixTimestamp <14>$Timestamp ${DomainNetbiosName}_PA 1,$Timestamp2,000000000707,THREAT,url,7,$Timestamp2,$Instance_IP1,$IP,$IP,$IP,DynamicDefault,$User_Account,,web-browsing,vsys1,Trust,Untrust,ethernet1/2,ethernet1/1,default,$Timestamp2,976,1,1126,$Port,38931,80,0x40,tcp,block-url,$URL,-9999,blocked-sites,informational,0,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, "
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20003)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
#DNS log
    #Define the message    
    $URL="webdisk.tiktokanalytics.net"
    $DNSDomain = "webdisk.tiktokanalytics.net"
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
    Sleep 50
#FIM
Set-Content -Path C:\s3-downloads\UseCases_Scripts\UseCase_4\Files\msoffice.bat -Value (Get-Date)
Sleep 150

#Disable system restore
powershell.exe Disable-ComputerRestore -Drive "C:\"
Sleep 50

#Delete shadow copies
#powershell.exe vssadmin delete shadows /all
vssadmin delete shadows /for=c: /oldest
Sleep 5
vssadmin delete shadows /for=c: /oldest
Sleep 5
vssadmin delete shadows /for=c: /oldest
Sleep 50

#MSOffice-Crypt (Encryption)
for($i=1;$i -lt 12;$i++){
start-process "cmd.exe" "/c C:\s3-downloads\UseCases_Scripts\UseCase_4\Files\msoffice.bat"
sleep 1
}
Sleep 100

#Honeypot
nmap -sV -T4 -O -F --version-light 10.0.14.0/24
Sleep 2000

#Re-enable system restore
Enable-ComputerRestore -Drive "C:\"