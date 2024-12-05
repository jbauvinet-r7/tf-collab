#!/bin/bash
#Variables
First_Name=${First_Name}
Last_Name=${Last_Name}
Company=${Company}
UserID=${UserID}
pass=${pass}
License_Key=${License_Key}
MachineType=${MachineType}
WorkDir=${WorkDir}
Dummy_Data=${Dummy_Data}
Tenant=${Tenant}
Token=${Token}
AdminUser=${AdminUser}
AdminPD=${AdminPD}
Bucket_Name=${Bucket_Name}
Instance_IP=${Instance_IP}
Instance_Mask=${Instance_Mask}
Instance_GW=${Instance_GW}
Instance_AWSGW=${Instance_AWSGW}
Agent_Type=${Agent_Type}
#Script to install insightvm console
#sleep 30m
apt install auditd -y
service auditd start
systemctl enable auditd
if $Agent_Type == "agent" or $Agent_Type == "ngav"; then
  echo "Installing Agent"
  wget https://s3.amazonaws.com/com.rapid7.razor.public/endpoint/agent/latest/linux/x86_64/agent_control_latest.sh
  chmod +x agent_control_latest.sh
  ./agent_control_latest.sh install_start --token $Token
else
  echo "No Agent installed"
fi
if [ "$MachineType" == "console" ]; then
   echo "Installing Console"
   echo "Step 1 - retrieve latest installer"
   cd /tmp/
   wget -c http://download2.rapid7.com/download/InsightVM/Rapid7Setup-Linux64.bin
   chmod +x Rapid7Setup-Linux64.bin
   echo "Step 2 - run the installer"
   echo "Running command : $WorkDir/$$/Rapid7Setup-Linux64.bin -q -Vfirstname=$First_Name -Vlastname=$Last_Name -VCompany=$Company -Vusername=$UserID -Vpassword1=$pass -Vpassword2=$pass"
   ./Rapid7Setup-Linux64.bin -q -Vfirstname=$First_Name -Vlastname=$Last_Name -VCompany=$Company -Vusername=$UserID -Vpassword1=$pass -Vpassword2=$pass
   echo "Step 3 - starting up the InsightVM console"
   systemctl start nexposeconsole
   echo "	waiting for one minute for startup to begin"
   sleep 120
   if ( systemctl status nexposeconsole )
   then
      echo "System appears to be starting up !!"
   else
      echo "ERROR, startup may have had an issue, check logs"
   fi
   sleep 120
   echo "Step 4 - Adding license key"
   IP=`hostname -I|sed 's/ //g'`
   echo "Running : curl  -k -X POST  --user "$UserID:$pass" -F "key=$License_Key" --url https://$IP:3780/api/3/administration/license"
   curl  -k -X POST  --user "$UserID:$pass" -F "key=$License_Key" --url https://$IP:3780/api/3/administration/license
   if [ $? -eq 0 ];then
      echo "license key was added successfully"
   else
      echo "possible error loading key, try to add manually, key is $License_Key"
   fi
   if [ "$Dummy_Data" == true ]; then
      echo "Deploying Dummy Data"
      apt install unzip -y
      apt install awscli -y
      apt install -y software-properties-common
      add-apt-repository -y ppa:deadsnakes/ppa
      apt update -y
      apt upgrade -y
      snap install aws-cli --classic
      apt install build-essential checkinstall libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev -y
      apt-get install python3.11 -y
      apt install -y python3-pip
      pip3 install os
      pip3 install getpass
      pip3 install requests
      pip3 install json
      pip3 install socket
      pip3 install urllib3
      pip3 install random
      aws s3 cp s3://$Bucket_Name/IVM_Scripts/dummy_data.py /tmp/
      cd /tmp/
      python3 Dummy_Data.py $Bucket_Name $UserID $pass
   else
      echo "Not Deploying Dummy Data"
   fi
   echo "Restarting the console now.."
   systemctl restart nexposeconsole
elif [ "$MachineType" == "engine" ]; then
   echo "Installing Scan Engine"
else
   echo "Asset Only"
fi
echo "Adding $AdminUser"
useradd -m -d /home/$AdminUser -s /bin/bash -G sudo $AdminUser -p $(openssl passwd -1 "$AdminPD")
sh -c "echo root:$AdminPD | chpasswd"