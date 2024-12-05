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
echo "$timestamp - Adding InsightVM Assets"
if [ "$Dummy_Data" == "yes" ]; then
   echo "$timestamp - Deploying Dummy Data"
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
   aws s3 cp s3://$Bucket_Name/IVM_Scripts/Asset_Data.py /tmp/
   cd /tmp/
   python3 Asset_Data.py
else
   echo "$timestamp - Not Deploying Dummy Data"
fi
echo "$timestamp - Restarting the console now.."
systemctl restart nexposeconsole