#!/bin/bash
#Read input variables
ServerName=${ServerName}
TimeZoneID=${TimeZoneID}
DomainName=${DomainName}
Token=${Token}
Tenant=${Tenant}
R7_Region=${R7_Region}
AdminUser=${AdminUser}
AdminPD=${AdminPD}
Bucket_Name=${Bucket_Name}
Instance_IP=${Instance_IP}
Instance_Mask=${Instance_Mask}
Instance_GW=${Instance_GW}
Instance_AWSGW=${Instance_AWSGW}
Agent_Type=${Agent_Type}
echo "Changing hostname"
interface=$(ip -o addr show | grep -E "inet ${Instance_IP}/" | awk '{print $2}')
# Check if interface found
if [ -z "$interface" ] || [ ! -f "/etc/netplan/50-cloud-init.yaml" ]; then
  echo "Error: Either no active network interface found or netplan config file missing. Exiting..."
else
  cp /etc/netplan/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml.bak
  cat << EOF > /etc/netplan/50-cloud-init.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    $interface:
      addresses: [$Instance_IP/$Instance_Mask]
      gateway4: $Instance_AWSGW
      nameservers:
        addresses: [$Instance_GW]
EOF
  sudo netplan apply
  # sudo netplan try (optional, for verification)
fi
echo "Static gateway configured for $interface. IP: $Instance_IP, Gateway: $Instance_AWSGW"
sleep 10m
hostnamectl set-hostname $ServerName.$DomainName
echo "Ubuntu Updates"
apt update -y
apt upgrade -y
apt install awscli -y
apt install unzip -y
apt install wget -y
echo "Installing Collector"
mkdir /home/ubuntu/Locations
mkdir /opt/temp/
cd /opt/temp/
if [ $R7_Region = "us1" ]; then
   wget -c --no-verbose https://s3.amazonaws.com/com.rapid7.razor.public/InsightSetup-Linux64.sh -O /opt/temp/InsightSetup-Linux64.sh
elif [ $R7_Region = "us2" ]; then
   wget -c --no-verbose https://s3.us-east-2.amazonaws.com/public.razor-prod-5.us-east-2.insight.rapid7.com/InsightSetup-Linux64.sh -O /opt/temp/InsightSetup-Linux64.sh
elif [ $R7_Region = "us3" ]; then
   wget -c --no-verbose https://s3.us-west-2.amazonaws.com/public.razor-prod-6.us-west-2.insight.rapid7.com/InsightSetup-Linux64.sh -O /opt/temp/InsightSetup-Linux64.sh
elif [ $R7_Region = "eu" ]; then
   wget -c --no-verbose https://s3.eu-central-1.amazonaws.com/public.razor-prod-0.eu-central-1.insight.rapid7.com/InsightSetup-Linux64.sh -O /opt/temp/InsightSetup-Linux64.sh
elif [ $R7_Region = "ap" ]; then
   wget -c --no-verbose https://s3.ap-northeast-1.amazonaws.com/public.razor-prod-2.ap-northeast-1.insight.rapid7.com/InsightSetup-Linux64.sh -O /opt/temp/InsightSetup-Linux64.sh
elif [ $R7_Region = "ca" ]; then
   wget -c --no-verbose https://s3.ca-central-1.amazonaws.com/public.razor-prod-3.ca-central-1.insight.rapid7.com/InsightSetup-Linux64.sh -O /opt/temp/InsightSetup-Linux64.sh
elif [ $R7_Region = "au" ]; then
   wget -c --no-verbose https://s3.ap-southeast-2.amazonaws.com/public.razor-prod-4.ap-southeast-2.insight.rapid7.com/InsightSetup-Linux64.sh -O /opt/temp/InsightSetup-Linux64.sh
else
   echo "No R7 Region match"
fi
chmod +x /opt/temp/InsightSetup-Linux64.sh
./InsightSetup-Linux64.sh -q 
service collector start 
agent_key=$(head -1 /opt/rapid7/collector/agent-key/Agent_Key.html | sed -e 's/Login/<Login/g' |sed -e 's/<[^>]*>//g' | sed -e 's/Agent KeyAgent key/Agent Key/g' | sed 's/[\w \W \s]*http[s]*[a-zA-Z0-9 : \. \/ ; % " \W]*/ /g')
echo $agent_key
if $Agent_Type == "agent" or $Agent_Type == "ngav"; then
  echo "Installing Agent"
  wget https://s3.amazonaws.com/com.rapid7.razor.public/endpoint/agent/latest/linux/x86_64/agent_control_latest.sh
  chmod +x agent_control_latest.sh
  ./agent_control_latest.sh install_start --token $Token
else
  echo "No Agent installed"
fi
echo "Changing SSH Configuration"
aws s3 cp s3://$Bucket_Name/Linux_Scripts/sshd.sh /opt/temp/
chmod +x /opt/temp/sshd.sh
./sshd.sh
echo "Adding $AdminUser"
useradd -m -d /home/$AdminUser -s /bin/bash -G sudo $AdminUser -p $(openssl passwd -1 "$AdminPD")
sh -c "echo root:$AdminPD | chpasswd"
interface=$(ip -o addr show | grep -E "inet ${Instance_IP}/" | awk '{print $2}')
# Check if interface found
if [ -z "$interface" ] || [ ! -f "/etc/netplan/50-cloud-init.yaml" ]; then
  echo "Error: Either no active network interface found or netplan config file missing. Exiting..."
else
  cp /etc/netplan/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml.bak
  cat << EOF > /etc/netplan/50-cloud-init.yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    $interface:
      addresses: [$Instance_IP/$Instance_Mask]
      gateway4: $Instance_GW
      nameservers:
        addresses: [$Instance_GW]
EOF
  sudo netplan apply
  # sudo netplan try (optional, for verification)
fi
echo "Static gateway configured for $interface. IP: $Instance_IP, Gateway: $Instance_GW"