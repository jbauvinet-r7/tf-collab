Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/sh
R7_Region="${R7_Region}"
AWS_Region="${AWS_Region}"
ServerName="${ServerName}"
AD_IP="${AD_IP}"
TimeZoneID="${TimeZoneID}"
Bucket_Name="${Bucket_Name}"
DomainName="${DomainName}"
DomainNetbiosName=$DomainName
Token="${Token}"
AdminUser="${AdminUser}"
AdminPD_ID="${AdminPD_ID}"
idr_service_account="${idr_service_account}"
idr_service_account_pwd_ID="${idr_service_account_pwd_ID}"
VR_Agent_File="${VR_Agent_File}"
Instance_IP1="${Instance_IP1}"
Instance_IP2="${Instance_IP2}"
Instance_Mask="${Instance_Mask}"
Instance_GW="${Instance_GW}"
Instance_AWSGW="${Instance_AWSGW}"
Agent_Type="${Agent_Type}"
SEOPS_VR_Install=${SEOPS_VR_Install}
Coll_IP="${Coll_IP}"
Orch_IP="${Orch_IP}"
SiteName="${SiteName}"
SiteName_RODC="${SiteName_RODC}"
RODCServerName="${RODCServerName}"
RODC_IP="${RODC_IP}"
ScriptList="${join(",", "${ScriptList}")}"
User_Account="${User_Account}"
Keyboard_Layout="${Keyboard_Layout}"
MachineType="${MachineType}"
Tenant="${Tenant}"
VRM_License_Key="${VRM_License_Key}"
Dummy_Data=${Dummy_Data}
Routing_Type="${Routing_Type}"
Deployment_Mode="${Deployment_Mode}"
Scenario="${join(",", "${Scenario}")}"
ZoneName="${ZoneName}"
PhishingName="${PhishingName}"
output_file="/var/log/terraform_script_output.log"
IFS=','
timestamp=$(date +"%Y-%m-%d %H:%M:%S")
echo "<<<<<<<<<<<<<<<==================================================================================================================================================================================================>>>>>>>>>>>>>>>" >> $output_file
echo "$timestamp - Starting User Data installation" >> $output_file
echo "$timestamp - Installing Requirements" >> $output_file
FILE=/opt/sleep_done.txt
if test -f "$FILE"; then
    echo "$timestamp - $FILE exists."
else
    echo "$timestamp - $FILE doesn't exist."
    echo "Sleep Time 10 minutes, please wait.."
    sleep 600
fi
apt update -y
apt upgrade -y
apt install snapd -y
apt install awscli -y
apt install dos2unix -y
apt install unzip -y 
apt-get install unzip -y
snap install aws-cli --classic
apt install software-properties-common -y
add-apt-repository -y ppa:deadsnakes/ppa
sudo mkdir /opt/temp
cd /opt/temp
echo "$timestamp - Requirements Installed" >> $output_file
echo "$timestamp - Downloading Scripts Installation" >> $output_file
aws s3 cp s3://$Bucket_Name/Installation_Scripts/Scripts_Installation.zip /opt/temp/
echo "$timestamp - Scripts Installation Downloading" >> $output_file
sudo unzip -o Scripts_Installation.zip
cd Scripts_Installation
sudo chmod +x *
sudo dos2unix *
echo "$timestamp - Installing Scripts Installation" >> $output_file
idr_service_account_pwd=$(aws secretsmanager get-secret-value --output text --query SecretString --region $AWS_Region --secret-id $idr_service_account_pwd_ID)
AdminPD=$(aws secretsmanager get-secret-value --output text --query SecretString --region $AWS_Region --secret-id $AdminPD_ID)
for script in $ScriptList ; do
    script_with_extension="$script.sh"
    echo "======================================================================================================================================================================================================================================" >> $output_file
    echo "$timestamp - Running $script_with_extension..." >> $output_file
    bash $script_with_extension \
        $R7_Region \
        $AWS_Region \
        $ServerName \
        $AD_IP \
        $TimeZoneID \
        $Bucket_Name \
        $DomainName \
        $DomainNetbiosName \
        $Token \
        $AdminUser \
        $AdminPD \
        $idr_service_account \
        $idr_service_account_pwd \
        $VR_Agent_File \
        $Instance_IP1 \
        $Instance_IP2 \
        $Instance_Mask \
        $Instance_GW \
        $Instance_AWSGW \
        $Agent_Type \
        $SEOPS_VR_Install \
        $Coll_IP \
        $Orch_IP \
        $SiteName \
        $SiteName_RODC \
        $RODCServerName \
        $RODC_IP \
        $User_Account \
        $Keyboard_Layout \
        $MachineType \
        $Tenant \
        $VRM_License_Key \
        $Dummy_Data \
        $Routing_Type \
        $Deployment_Mode \
        $Scenario \
        $ZoneName \
        $PhishingName \
        >> $output_file 2>&1
    wait
    echo "======================================================================================================================================================================================================================================" >> $output_file
done
unset IFS
echo "$timestamp - End of the Installation Script" >> $output_file
--//--