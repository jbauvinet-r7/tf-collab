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
FILE=/opt/sleep_done.txt
if test -f "$FILE"; then
  echo "$timestamp - $FILE exists."
else
  echo "$timestamp - $FILE doesn't exist."
  echo "$timestamp - Starting Time Sleep."
  if [[ "$SiteName" == "AD" ]]; then
    sleep 300s
    echo "$timestamp - Sleep Time AD: 5 minutes"  # Use echo instead of Write-Log
  elif [[ "$SiteName" == "IT" ]]; then
    sleep 1800s
    echo "$timestamp - Sleep Time IT: 30 minutes"
  elif [[ "$SiteName" == "RODC" ]]; then
    sleep 2700s
    echo "$timestamp - Sleep Time RODC: 45 minutes"
  elif [[ "$SiteName" == "HQ" ]]; then
    sleep 3600s
    echo "$timestamp - Sleep Time HQ: 60 minutes"
  elif [[ "$SiteName" == "R7" ]]; then
    #sleep 60s
    echo "$timestamp - Sleep Time R7: 0 minutes"
  elif [[ "$SiteName" == "DMZ" ]]; then
    echo "$timestamp - No Sleep Time DMZ"
  elif [[ "$SiteName" == "BOOTCAMP" ]]; then
    echo "$timestamp - No Sleep Time BOOTCAMP"
  else
    echo "$timestamp - No SiteName - Sleep Time skipped"
  fi
  touch $FILE
fi
echo "$timestamp - Sleep Time Script Completed"