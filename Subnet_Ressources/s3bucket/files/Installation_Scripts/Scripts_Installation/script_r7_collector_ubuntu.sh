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
echo "$timestamp - Installing Collector"
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
echo "$timestamp - Collector Installed"