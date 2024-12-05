#!/bin/bash
#Read input variables
default_value="Empty"
R7_Region=${1:-$default_value}
AWS_Region=${2:-$default_value}
ServerName=${3:-$default_value}
AD_IP=${4:-$default_value}
TimeZoneID=${5:-$default_value}
Bucket_Name=${6:-$default_value}
DomainName=${7:-$default_value}
DomainNetbiosName=${8:-$default_value}
Token=${9:-$default_value}
AdminUser=${10:-$default_value}
AdminPD=${11:-$default_value}
idr_service_account=${12:-$default_value}
idr_service_account_pwd=${13:-$default_value}
VR_Agent_File=${14:-$default_value}
Instance_IP1=${15:-$default_value}
Instance_IP2=${16:-$default_value}
Instance_Mask=${17:-$default_value}
Instance_GW=${18:-$default_value}
Instance_AWSGW=${19:-$default_value}
Agent_Type=${20:-$default_value}
SEOPS_VR_Install=${21:-$default_value}
Coll_IP=${22:-$default_value}
Orch_IP=${23-$default_value}
SiteName=${24:-$default_value}
SiteName_RODC=${25:-$default_value}
RODCServerName=${26:-$default_value}
RODC_IP=${27:-$default_value}
User_Account=${28:-$default_value}
Keyboard_Layout=${29:-$default_value}
MachineType=${30:-$default_value}
Tenant=${31:-$default_value}
VRM_License_Key=${32:-$default_value}
Dummy_Data=${33:-$default_value}
Routing_Type=${34:-$default_value}
Deployment_Mode=${35:-$default_value}
Scenario=${36:-$default_value}
ZoneName=${37:-$default_value}
PhishingName=${38:-$default_value}
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
echo "$timestamp - Changing Network Settings"
interface1=$(ip -o addr show | grep -E "inet ${Instance_IP1}/" | awk '{print $2}')
if ! grep -q '^DNS=$AD_IP$'  /etc/systemd/resolved.conf; then
    echo 'DNS=$AD_IP' >>  /etc/systemd/resolved.conf
fi
service systemd-resolved restart
# Check if interface found
if [ -z "$interface1" ] || [ ! -f "/etc/netplan/50-cloud-init.yaml" ]; then
  echo "$timestamp - Error: Either no active network interface found or netplan config file missing. Exiting..."
else
  cp /etc/netplan/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml.bak
  cat << EOF >> /etc/netplan/50-cloud-init.yaml
  network:
    version: 2
    renderer: networkd
    ethernets:
      $interface1:
        addresses: [$Instance_IP1/$Instance_Mask]
        gateway4: $Instance_AWSGW
        nameservers:
          addresses: [$Instance_AWSGW,$AD_IP]
  EOF
  sudo netplan apply
fi
echo "Static gateway configured for $interface1. IP: $Instance_IP1, Gateway: $Instance_AWSGW"
#interface2=$(ip -o addr show | grep -E "inet ${Instance_IP2}/" | awk '{print $2}')
# if [ -z "$interface2" ] || [ ! -f "/etc/netplan/50-cloud-init.yaml" ]; then
#   echo "Error: Either no active network interface found or netplan config file missing. Exiting..."
# else
#   cp /etc/netplan/50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml.bak
#   cat << EOF >> /etc/netplan/50-cloud-init.yaml
# network:
#   version: 2
#   renderer: networkd
#   ethernets:
#     $interface2:
#       addresses: [$Instance_IP2/$Instance_Mask]
#       gateway4: $Instance_AWSGW
#       nameservers:
#         addresses: [$Instance_GW,$AD_IP]
# EOF
#   sudo netplan apply
#   # sudo netplan try (optional, for verification)
# fi
# echo "Static gateway configured for $interface2. IP: $Instance_IP2, Gateway: $Instance_AWSGW"
echo "Network Settings Changed"
else
  echo "AWS Arch no pre configuration needed"
fi