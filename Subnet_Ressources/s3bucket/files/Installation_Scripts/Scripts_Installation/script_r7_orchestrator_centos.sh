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
echo "$timestamp - Installing Orchestrator"
cd /opt/temp/
if [ $R7_Region = "us1" ]; then
  wget -c --no-verbose https://us.downloads.connect.insight.rapid7.com/orchestrator/installers/r7-orchestrator-installer.sh -O /opt/temp/r7-orchestrator-installer.sh
elif [ $R7_Region = "us2" ]; then
  wget -c --no-verbose https://us2.downloads.connect.insight.rapid7.com/orchestrator/installers/r7-orchestrator-installer.sh -O /opt/temp/r7-orchestrator-installer.sh
elif [ $R7_Region = "us3" ]; then
  wget -c --no-verbose https://us3.downloads.connect.insight.rapid7.com/orchestrator/installers/r7-orchestrator-installer.sh -O /opt/temp/r7-orchestrator-installer.sh
elif [ $R7_Region = "eu" ]; then
  wget -c --no-verbose https://eu.downloads.connect.insight.rapid7.com/orchestrator/installers/r7-orchestrator-installer.sh -O /opt/temp/r7-orchestrator-installer.sh
elif [ $R7_Region = "ap" ]; then
  wget -c --no-verbose https://ap.downloads.connect.insight.rapid7.com/orchestrator/installers/r7-orchestrator-installer.sh -O /opt/temp/r7-orchestrator-installer.sh
elif [ $R7_Region = "ca" ]; then
  wget -c --no-verbose https://ca.downloads.connect.insight.rapid7.com/orchestrator/installers/r7-orchestrator-installer.sh -O /opt/temp/r7-orchestrator-installer.sh
elif [ $R7_Region = "au" ]; then
  wget -c --no-verbose https://au.downloads.connect.insight.rapid7.com/orchestrator/installers/r7-orchestrator-installer.sh -O /opt/temp/r7-orchestrator-installer.sh
else
  echo "$timestamp - No R7 Region match"
fi
chmod +x /opt/temp/r7-orchestrator-installer.sh
INTERACTIVE=0 ./r7-orchestrator-installer.sh
systemctl start rapid7-orchestrator
agent_key=$(head -1 /opt/rapid7/collector/agent-key/Agent_Key.html | sed -e 's/Login/<Login/g' |sed -e 's/<[^>]*>//g' | sed -e 's/Agent KeyAgent key/Agent Key/g' | sed 's/[\w \W \s]*http[s]*[a-zA-Z0-9 : \. \/ ; % " \W]*/ /g')
echo $agent_key
echo "$timestamp - Orchestrator Installed"