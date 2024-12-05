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
echo "$timestamp - Installing Agent"
if [[ "$Agent_Type" == "ngav" ]]; then
    [ ! -d /opt/temp ] && mkdir /opt/temp
    cd /opt/temp/
    apt-get install tar -y
    wget https://s3.amazonaws.com/com.rapid7.razor.public/endpoint/agent/latest/linux/x86_64/rapid7-insight-agent_4.0.10.72-1_amd64.deb
    wget https://s3.amazonaws.com/com.rapid7.razor.public/endpoint/armor360_linux/2.0.0.97/linux/x86_64/rapid7-armor360_2.0.0.97-1_amd64.deb
    wget https://s3.amazonaws.com/com.rapid7.razor.public/endpoint/armor_linux/2.0.0.118/linux/x86_64/rapid7-armor_2.0.0.118-1_amd64.deb
    chmod +x rapid7-insight-agent_4.0.10.72-1_amd64.deb
    apt-get install ./rapid7-insight-agent_4.0.10.72-1_amd64.deb
    cd /opt/rapid7/ir_agent/components/insight_agent/4.0.10.72/
    ./configure_agent.sh --token $Tokend -v --start
    cd /opt/temp/
    chmod +x rapid7-armor360_2.0.0.97-1_amd64.deb
    chmod +x rapid7-armor_2.0.0.118-1_amd64.deb
    dpkg -i rapid7-armor_2.0.0.118-1_amd64.deb rapid7-armor360_2.0.0.97-1_amd64.deb
    echo "$timestamp - Auditd Configuration for the Agent"
    aws s3 cp s3://$Bucket_Name/R7Agent/af_unix.conf /opt/temp/
    \cp -fr af_unix.conf /etc/audisp/plugins.d/af_unix.conf
    aws s3 cp s3://$Bucket_Name/R7Agent/audispd.conf /opt/temp/
    \cp -fr audispd.conf /etc/audisp/audispd.conf
    aws s3 cp s3://$Bucket_Name/R7Agent/audit.conf /opt/temp/
    \cp -fr audit.conf /opt/rapid7/ir_agent/components/insight_agent/common/audit.conf
    aws s3 cp s3://$Bucket_Name/R7Agent/audit.rules /opt/temp/
    \cp -fr audit.rules /etc/audit/audit.rules
    service auditd restart
    auditctl -l
    setenforce 0
    echo "$timestamp - Installation NGAV Insight Agent for Token : $Tokend"
elif [[ "$Agent_Type" == "agent" ]]; then
    wget https://s3.amazonaws.com/com.rapid7.razor.public/endpoint/agent/latest/linux/x86_64/agent_control_latest.sh
    chmod +x agent_control_latest.sh
    ./agent_control_latest.sh install_start --token $Token --agent_option
    echo "$timestamp - Auditd Configuration for the Agent"
    aws s3 cp s3://$Bucket_Name/R7Agent/af_unix.conf /opt/temp/
    \cp -fr af_unix.conf /etc/audisp/plugins.d/af_unix.conf
    aws s3 cp s3://$Bucket_Name/R7Agent/audispd.conf /opt/temp/
    \cp -fr audispd.conf /etc/audisp/audispd.conf
    aws s3 cp s3://$Bucket_Name/R7Agent/audit.conf /opt/temp/
    \cp -fr audit.conf /opt/rapid7/ir_agent/components/insight_agent/common/audit.conf
    aws s3 cp s3://$Bucket_Name/R7Agent/audit.rules /opt/temp/
    \cp -fr audit.rules /etc/audit/audit.rules
    service auditd restart
    auditctl -l
    setenforce 0
    echo "$timestamp - Installation Insight Agent for Token : $Token"
else
    echo "$timestamp - No installation required for $Agent_Type."
fi