#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                       Global Variables Definitions                                                                            #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  AWS Region                                                                                                                                                                                                                                                                   
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
provider "aws" {
  region = var.AWS_Region
}
variable "AWS_Region" {
  description = "AWS Region"
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  AMIs                                                                                                                                                                                                                                                         
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
data "aws_ami" "pfsense" {
  owners      = ["679593333241"]
  most_recent = true
  filter {
    name   = "name"
    values = ["pfSense-plus-ec2-*.*.*-RELEASE-*"]
  }
}
data "aws_ami" "windows11" {
  owners      = ["739423076117"]
  most_recent = true
  filter {
    name   = "name"
    values = ["SELABS-Win11-RDP-V2"]
  }
}

data "aws_ami" "linux_metasploitable" {
  owners      = ["739423076117"]
  most_recent = true
  filter {
    name   = "name"
    values = ["SELABS-Ubuntu-Metasploitable-V1"]
  }
}

data "aws_ami" "windows_metasploitable" {
  owners      = ["739423076117"]
  most_recent = true
  filter {
    name   = "name"
    values = ["SELABS-Windows7-Metasploitable-V1"]
  }
}

data "aws_ami" "windows2k22" {
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["801119661308"]
}
data "aws_ami" "windows2k19" {
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["801119661308"]
}
data "aws_ami" "debian12" {
  most_recent = true
  filter {
    name   = "name"
    values = ["debian-12-amd64-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["136693071363"]
}
data "aws_ami" "ubuntu20" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}
data "aws_ami" "ubuntu22" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}
data "aws_ami" "awslinux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}
# data "aws_ami" "centos8" {
#   owners      = ["679593333241"]
#   most_recent = true
#   filter {
#     name   = "name"
#     values = ["CentOS-8*"]
#   }
# }
data "aws_ami" "windows10" {
  owners      = ["739423076117"]
  most_recent = true
  filter {
    name   = "name"
    values = ["SEOPS-Win10-RDP-v1"]
  }
}
data "aws_ami" "honeypot" {
  owners      = ["113181853977"]
  most_recent = true
  filter {
    name   = "name"
    values = ["Rapid7-InsightIDR-AWS-Honeypot-*"]
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Features                                                                                                                                                                                                                                                                   
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Global Mode #############
variable "Agent_Type" {
  type        = string
  description = "Agent Type (none, ngav or agent)"
}
variable "SEOPS_VR_Install" {
  type        = bool
  description = "Agent Type (none, ngav or agent)"
}
variable "Routing_Type" {
  type        = string
  description = "Routing Type (AWS, pfSense)"
}
variable "Deployment_Mode" {
  type        = string
  description = "Deployment Mode (full or partial (DMZ+IT Only))"
}
variable "InsightAppSec_Module" {
  type        = bool
  description = "Install InsightAppSec components (WebApps(ECS)+Sunets)"
}
variable "InsightAppSec_IAS_engine" {
  type        = bool
  description = "Install InsightAppSec component (Engine)"
}
variable "InsightVM_Module" {
  type        = bool
  description = "Install InsightVM components (IVM Console)"
}
variable "InsightVM_Dummy_Data" {
  type        = bool
  description = "Install InsightVM Dummy Data (Sites + Asset Groups + Tags + Reports)"
}
variable "InsightIDR_Module" {
  type        = bool
  description = "Install InsightIDR components (Collectors(Int+Ext)+ Honeypot)"
}
variable "Metasploit_Module" {
  type        = bool
  description = "Install Metasploit"
}
variable "Honeypot_Module" {
  type        = bool
  description = "Install InsightIDR Honeypot"
}
variable "InsightIDR_Dummy_Data" {
  type        = bool
  description = "Install InsightIDR Dummy Data (Log Generator)"
}
variable "InsightConnect_Module" {
  type        = bool
  description = "Install InsightConnect components (Orchestrator)"
}
variable "NetworkSensor_Module" {
  type        = bool
  description = "Install Network Sensor components (Network Sensor + Traffic Mirroring + NLB)"
}
variable "Jumpbox_Module" {
  type        = bool
  description = "Install a Jumpbox"
}
variable "External_Collector_Linux_Module" {
  type        = bool
  description = "Install an External Linux Collector"
}
variable "External_Collector_Windows_Module" {
  type        = bool
  description = "Install an External Windows Collector"
}
variable "POVAgent_Module" {
  type        = bool
  description = "Install an POVAgent_Module"
}
variable "External_IASEngine_Module" {
  type        = bool
  description = "Install an External IAS Engine"
}
variable "External_InsightVM_Module" {
  type        = bool
  description = "Install an External IVM Engine"
}
variable "External_InsightVM_Lockdown" {
  type        = bool
  description = "Lock outbound IVM Engine"
}
variable "External_NetworkSensor_Module" {
  type        = bool
  description = "Install an External Network Sensor Engine"
}
variable "External_Orch_Module" {
  type        = bool
  description = "Install an External Orchestrator"
}
variable "External_Win11_Module" {
  type        = bool
  description = "Install External Win11"
}
variable "External_Win22_Module" {
  type        = bool
  description = "Install External Win22"
}
variable "External_AD_Module" {
  type        = bool
  description = "Install an External AD"
}
variable "use_route53_hz" {
  type        = bool
  description = "Use Route 53 Hosted Zone"
}
variable "Public_Access_ALB" {
  type        = bool
  description = "Access to ALB with 0.0.0.0/0"
}
variable "FileServer_HQ_Module" {
  type        = bool
  description = "Install FileServer HQ components"
}
variable "FileServer_IT_Module" {
  type        = bool
  description = "Install FileServer IT components"
}
variable "WebServer_HQ_Module" {
  type        = bool
  description = "Install WebServer HQ components"
}
variable "WebServer_IT_Module" {
  type        = bool
  description = "Install WebServer IT components"
}
variable "Win2K19_HQ_Module" {
  type        = bool
  description = "Install Win2k19 HQ components"
}
variable "Win2K19_IT_Module" {
  type        = bool
  description = "Install Win2k19 IT components"
}
variable "Win2K22_HQ_Module" {
  type        = bool
  description = "Install Win2k22 HQ components"
}
variable "Win2K22_IT_Module" {
  type        = bool
  description = "Install Win2k22 IT components"
}
variable "Win10_HQ_Module" {
  type        = bool
  description = "Install Win10 HQ components"
}
variable "Win10_IT_Module" {
  type        = bool
  description = "Install Win10 IT components"
}
variable "Win11_HQ_Module" {
  type        = bool
  description = "Install Win11 HQ components"
}
variable "Win11_IT_Module" {
  type        = bool
  description = "Install Win11 IT components"
}
variable "Ubu_HQ_Module" {
  type        = bool
  description = "Install Ubu HQ components"
}
variable "Ubu_IT_Module" {
  type        = bool
  description = "Install Ubu IT components"
}
variable "DHCP_Module" {
  type        = bool
  description = "Install DHCP IT components"
}
variable "AD_Module" {
  type        = bool
  description = "Install AD components"
}
variable "RODC_Module" {
  type        = bool
  description = "Install RODC components"
}
variable "Public_IP_Access" {
  type        = string
  description = "Public IP Address"
}
variable "Hosted_Console_Mode" {
  type        = bool
  description = "insightVM Hosted Console Only"
}
variable "SurfaceCommand_Module" {
  type        = bool
  description = "Install Outpost components"
}
variable "IVMEngine_Module" {
  type        = bool
  description = "Install IVM Engine components"
}
variable "MSBLE_Ubu_Module" {
  type        = bool
  description = "Install Metasploitable Ubuntu components"
}
variable "MSBLE_Win_Module" {
  type        = bool
  description = "Install Metasploitable Windows components"
}
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Scripts Lists                                                                                                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "ScriptList_JUMPBOX" {
  type        = list(string)
  description = "ScriptList JUMPBOX"
}
variable "ScriptList_ADDS01" {
  type        = list(string)
  description = "ScriptList ADDS01"
}
variable "ScriptList_RODC" {
  type        = list(string)
  description = "ScriptList RODC"
}
variable "ScriptList_2K19" {
  type        = list(string)
  description = "ScriptList 2K19"
}
variable "ScriptList_2K22" {
  type        = list(string)
  description = "ScriptList 2K22"
}
variable "ScriptList_WIN11" {
  type        = list(string)
  description = "ScriptList WIN11"
}
variable "ScriptList_OUTPOST" {
  type        = list(string)
  description = "ScriptList Outpost"
}
variable "ScriptList_IVMENGINE" {
  type        = list(string)
  description = "ScriptList IVMENgine"
}
variable "ScriptList_WIN10" {
  type        = list(string)
  description = "ScriptList WIN10"
}
variable "ScriptList_FILESERVER" {
  type        = list(string)
  description = "ScriptList FILESERVER"
}
variable "ScriptList_WEBSERVER" {
  type        = list(string)
  description = "ScriptList WEBSERVER"
}
variable "ScriptList_DHCP" {
  type        = list(string)
  description = "ScriptList DHCP"
}
variable "ScriptList_LOGGEN" {
  type        = list(string)
  description = "ScriptList LOGGEN"
}
variable "ScriptList_LINUXCOLLECTOR" {
  type        = list(string)
  description = "ScriptList Linux COLLECTOR"
}
variable "ScriptList_IDR_WINCOLLECTOR" {
  type        = list(string)
  description = "ScriptList Windows COLLECTOR"
}
variable "ScriptList_IDR_TARGET_WIN" {
  type        = list(string)
  description = "ScriptList_IDR_TARGET_WIN"
}
variable "ScriptList_IDR_TARGET_UBU" {
  type        = list(string)
  description = "ScriptList_IDR_TARGET_UBU"
}
variable "ScriptList_VRM_CONSOLE_UBU" {
  type        = list(string)
  description = "ScriptList IVM"
}
variable "ScriptList_VRM_CONSOLE_WIN" {
  type        = list(string)
  description = "ScriptList IVM"
}
variable "ScriptList_NSENSOR" {
  type        = list(string)
  description = "ScriptList NSENSOR"
}
variable "ScriptList_IASENGINE" {
  type        = list(string)
  description = "ScriptList IASENGINE"
}
variable "ScriptList_LINUXAWS" {
  type        = list(string)
  description = "ScriptList LINUXAWS"
}
variable "ScriptList_METASPLOIT" {
  type        = list(string)
  description = "ScriptList METASPLOIT"
}
variable "ScriptList_ORCHESTRATOR" {
  type        = list(string)
  description = "ScriptList ORCHESTRATOR"
}
variable "ScriptList_LINUX" {
  type        = list(string)
  description = "ScriptList LINUX"
}
variable "ScriptList_VRM_ENGINE_UBU" {
  type        = list(string)
  description = "ScriptList VRM_ENGINE_UBU"
}
variable "ScriptList_VRM_ENGINE_WIN" {
  type        = list(string)
  description = "ScriptList VRM_ENGINE_WIN"
}
variable "ScriptList_VRM_TARGET_WIN" {
  type        = list(string)
  description = "ScriptList VRM_TARGET_WIN"
}
variable "ScriptList_VRM_TARGET_UBU" {
  type        = list(string)
  description = "ScriptList VRM_TARGET_UBU"
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Environement                                                                                                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "Owner_Email" {
  description = "Owner Email"
}
variable "Account_Type" {
  type        = string
  description = "Account Type (SELabs, Partners, Customers-POC,Customers-POVcm"
}
variable "VR_Agent_File" {
  type = string
}
variable "R7_Region" {
  description = "R7 Region us1/us2/us3/eu/ca/ap/au"
}
variable "Tenant" {
  type        = string
  description = "the name of the tenant"
}
variable "ZoneName" {
  type        = string
  description = "the name of the Route 53 DNS Zone"
}
variable "DomainName" {
  type        = string
  description = "Specifies the fully qualified domain name (FQDN) for the root domain in the forest. "
  sensitive   = true
}
variable "PhishingName" {
  type        = string
  description = "Specifies the fully qualified domain name (FQDN) for the root domain in the forest. "
  sensitive   = true
}
variable "Zone_ID" {
  type        = string
  description = "Zone_ID"
  sensitive   = true
}
variable "JIRA_ID" {
  type        = string
  description = "JIRA_ID"
  sensitive   = true
}
variable "Token" {
  type        = string
  description = "Insight Token for Agents"
}
variable "Token_HONEYPOT" {
  description = "Honeypot Token"
  type        = string
}
variable "TimeZoneID" {
  type        = string
  description = "the system time zone to a specified time zone."
}
variable "R7vpn_List" {
  type        = map(any)
  description = "R7 VPNs"
}
variable "R7office_List" {
  type        = map(any)
  description = "R7 Offices"
}
variable "IASEngine_List" {
  description = "IAS Cloud Engine IPs"
  type        = map(any)
}
variable "Keyboard_Layout" {
  description = "Keyboard_Layout"
  type        = string
}


#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   S3 Module (S3 Bucket, Files)                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "Bucket_Name" {
  type = string
}
variable "Bucket_Name_Agent" {
  type = string
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   IAM Module (IAM Role, Instance Profile, Policy, Instance Certificates)                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "Acl_Value" {
}
variable "Instance_Profile_Name" {
  type = string
}

variable "Iam_Policy_Name" {
  type = string
}
variable "Role_Name" {
  type = string
}
variable "Key_Name_Internal" {
  description = "The AWS key pair to use for resources. This have to be change to match your own key"
}
variable "Key_Name_External" {
  description = "The AWS key pair to use for resources. This have to be change to match your own key"
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   Firewall Subnet Module (External Firewall + Internal Firewall (pfSense))                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "Instance_Count_FIREWALL" {
  description = "The number of ami instances to spin up."
  type        = number
}
variable "Instance_Type_FIREWALL" {
  description = "The name of the instance type."
  type        = string
}
variable "Volume_Size_FIREWALL" {
  description = "Volume Size"
  type        = string
}
variable "ServerName_FIREWALL" {
  type        = string
  description = "the name of the server. Example ws-test1"
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   Jumpbox Subnet Module (Jumpbox)                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "ServerName_JUMPBOX" {
  type        = string
  description = "the name of the server. Example SRV-ADDS01"
}
variable "Instance_Type_JUMPBOX" {
  description = "The name of the instance type."
  type        = string
}
variable "Volume_Size_JUMPBOX" {
  description = "Volume Size"
  type        = string
}
variable "Jump_IP" {
  type        = string
  description = "the ip of the Jumpbox"
}
variable "Jump_Mask" {
  type        = string
  description = "the mask of the Jumpbox network"
}
variable "Jump_GW" {
  type        = string
  description = "the gw of the Jumpbox network"
}
variable "Jump_AWSGW" {
  type        = string
  description = "the awsgw of the Jumpbox network"
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   DMZ Subnet Module (External Collector)                                                                                                                                                                                                                                                                                               
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "Instance_Type_EXTAWS" {
  description = "The name of the instance type."
  type        = string
}
variable "Volume_Size_EXTAWS" {
  description = "Volume Size"
  type        = string
}
variable "ServerName_EXTAWS" {
  type        = string
  description = "the name of the server. Example ws-test1"
}
variable "ExtLinuxAWS_IP" {
  type        = string
  description = "the EXT collector Linux ip"
}
variable "Instance_Type_EXTCOLLECTOR" {
  description = "The name of the instance type."
  type        = string
}
variable "Volume_Size_EXTCOLLECTOR" {
  description = "Volume Size"
  type        = string
}
variable "ServerName_EXTCOLLECTOR" {
  type        = string
  description = "the name of the server. Example ws-test1"
}
variable "ExtLinuxCollector_IP" {
  type        = string
  description = "the EXT collector Linux ip"
}
variable "ExtWinCollector_IP" {
  type        = string
  description = "the EXT collector Windows ip"
}
variable "ExtCollector_ICSIP" {
  type        = list(string)
  description = "the EXT collector ICS ip"
}
variable "DMZ_Mask" {
  type        = string
  description = "the extcollector mask"
}
variable "DMZ_GW" {
  type        = string
  description = "the extcollector gateway"
}
variable "DMZ_AWSGW" {
  type        = string
  description = "the extcollector aws gateway"
}
variable "IVM_Hosted_Console_IP" {
  type        = string
  description = "the ivm hosted console ip"
}
variable "IVM_Hosted_Console_Port" {
  type        = string
  description = "the ivm hosted console port"
}
variable "Instance_Type_HCIVM" {
  description = "The name of the instance type."
  type        = string
}
variable "HCIVM_Priority" {
  type        = string
  description = "the ivm hosted priority"
}
variable "Metasploit_Priority" {
  type        = string
  description = "the Metasploit priority"
}
variable "Volume_Size_HCIVM" {
  description = "Volume Size"
  type        = string
}
variable "ServerName_HCIVM" {
  type        = string
  description = "the name of the server. Example ws-test1"
}
variable "InsightVM_Dummy_Data_HCIVM" {
  type        = bool
  description = "Install InsightVM Dummy Data (Sites + Asset Groups + Tags + Reports)"
}
variable "ExtAD_IP" {
  type        = string
  description = "the ext AD ip"
}
variable "ExtRODC_IP" {
  type        = string
  description = "the ext RODC ip"
}
variable "ServerName_EXTRODC" {
  type        = string
  description = "the name of the server. Example ws-test1"
}
variable "ServerName_EXTAD" {
  type        = string
  description = "the name of the server. Example ws-test1"
}
variable "ServerName_EXTORCHESTRATOR" {
  type        = string
  description = "the name of the server. Example ws-test1"
}
variable "ExtOrch_IP" {
  type        = string
  description = "the ext Orch ip"
}
variable "ServerName_EXTIASENGINE" {
  type        = string
  description = "the name of the server. Example ws-test1"
}
variable "ExtIASEngine_IP" {
  type        = string
  description = "the ext IAS Engine ip"
}
variable "ExtNLB_Private_IP" {
  type        = string
  description = "the EXT NLB Private IP"
}
variable "ServerName_EXTNSENSOR" {
  type        = string
  description = "the EXT Network Sensor Server Name"
}
variable "ExtNSensor_IP1" {
  type        = string
  description = "the EXT Network Sensor Private IP1"
}
variable "ExtNSensor_IP2" {
  type        = string
  description = "the EXT Network Sensor Private IP2"
}
variable "ServerName_EXTWIN11" {
  type        = string
  description = "the EXT Win Server Name"
}
variable "User_List_EXTWIN11" {
  type = map(object({
    Name     = string
    Scenario = list(string)
  }))
}
variable "ServerName_EXTWIN22" {
  type        = string
  description = "the EXT Win Server Name"
}
variable "User_List_EXTWIN22" {
  type = map(object({
    Name     = string
    Scenario = list(string)
  }))
}
variable "ubu_Mestaploitable_ip" {
  type        = string
  description = "MSBLE Ubu IP"
}
variable "win_Mestaploitable_ip" {
  type        = string
  description = "MSBLE Win IP"
}
variable "ServerName_Metasploitable_Ubu" {
  type        = string
  description = "ServerName MSBLE Ubu"
}
variable "ServerName_Metasploitable_Win" {
  type        = string
  description = "ServerName MSBLE Win"
}
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   IT & HQ Subnets                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Global #############                                                                                                                                                                                                                                                                                   
variable "User_List_Malicious" {
  type = map(object({
    Name     = string
    Scenario = list(string)
  }))
}
############# Workstation : Linux #############                                                                                                                                                                                                                                                                                   
variable "Instance_Count_LINUX" {
  description = "The number of ami instances to spin up."
  type        = number
}
variable "Instance_Type_LINUX" {
  description = "The name of the instance type."
  type        = string
}
variable "Volume_Size_LINUX" {
  description = "Volume Size"
  type        = string
}
variable "ServerName_LINUX_IT" {
  type        = string
  description = "the name of the server. Example ws-test1"
}
variable "ServerName_LINUX_HQ" {
  type        = string
  description = "the name of the server. Example ws-test1"
}
variable "User_List_LINUX_IT" {
  type = map(object({
    Name     = string
    Scenario = list(string)
  }))
}
variable "User_List_LINUX_HQ" {
  type = map(object({
    Name     = string
    Scenario = list(string)
  }))
}

############# Workstation : Windows 10 #############
variable "Instance_Count_WIN10" {
  description = "The number of ami instances to spin up."
  type        = number
}
variable "Instance_Type_WIN10" {
  description = "The name of the instance type."
  type        = string
}
variable "Volume_Size_WIN10" {
  description = "Volume Size"
  type        = string
}
variable "ServerName_WIN10_IT" {
  type        = string
  description = "the name of the server. Example ws-test1"
}
variable "ServerName_WIN10_HQ" {
  type        = string
  description = "the name of the server. Example ws-test1"
}
variable "User_List_WIN10_IT" {
  type = map(object({
    Name     = string
    Scenario = list(string)
  }))
}
variable "User_List_WIN10_HQ" {
  type = map(object({
    Name     = string
    Scenario = list(string)
  }))
}

############# Server Ext : Windows 22 #############
variable "Instance_Type_WIN22" {
  description = "The name of the instance type."
  type        = string
}
variable "Volume_Size_WIN22" {
  description = "Volume Size"
  type        = string
}
############# Workstation : Windows 11 #############
variable "Instance_Count_WIN11" {
  description = "The number of ami instances to spin up."
  type        = number
}
variable "Instance_Type_WIN11" {
  description = "The name of the instance type."
  type        = string
}
variable "Volume_Size_WIN11" {
  description = "Volume Size"
  type        = string
}
variable "ServerName_WIN11_IT" {
  type        = string
  description = "the name of the server. Example ws-test1"
}
variable "ServerName_WIN11_HQ" {
  type        = string
  description = "the name of the server. Example ws-test1"
}
variable "User_List_WIN11_IT" {
  type = map(object({
    Name     = string
    Scenario = list(string)
  }))
}
variable "User_List_WIN11_HQ" {
  type = map(object({
    Name     = string
    Scenario = list(string)
  }))
}

############# Servers : Naming #############
variable "ServerName_AD_IT" {
  type        = string
  description = "the name of the server. Example SRV-ADDS01"
}
variable "ServerName_RODC_HQ" {
  type        = string
  description = "the name of the server. Example SRV-ADDS01"
}
variable "ServerName_2K19_IT" {
  type        = string
  description = "the name of the server. Example SRV-2K19"
}
variable "ServerName_2K19_HQ" {
  type        = string
  description = "the name of the server. Example SRV-2K19"
}
variable "ServerName_2K22_IT" {
  type        = string
  description = "the name of the server. Example SRV-2K22"
}
variable "ServerName_2K22_HQ" {
  type        = string
  description = "the name of the server. Example SRV-2K22"
}
variable "ServerName_DHCP_IT" {
  type        = string
  description = "the name of the server. Example SRV-ADDS01"
}
variable "ServerName_DHCP_HQ" {
  type        = string
  description = "the name of the server. Example SRV-ADDS01"
}
variable "ServerName_FILESERVER_IT" {
  type        = string
  description = "the name of the server. Example SRV-FILESERVER"
}
variable "ServerName_FILESERVER_HQ" {
  type        = string
  description = "the name of the server. Example SRV-FILESERVER"
}
variable "ServerName_WEBSERVER_IT" {
  type        = string
  description = "the name of the server. Example SRV-WEBSERVER"
}
variable "ServerName_WEBSERVER_HQ" {
  type        = string
  description = "the name of the server. Example SRV-WEBSERVER"
}

############# Servers : ADDS01 + Domain #############
variable "Instance_Count_AD" {
  description = "The number of ami instances to spin up."
  type        = number
}
variable "Instance_Type_AD" {
  description = "The name of the instance type."
  type        = string
}
variable "Volume_Size_AD" {
  description = "Volume Size"
  type        = string
}
variable "ForestMode" {
  type        = string
  description = "Specifies the forest functional level for the new forest. "
}
variable "DomainMode" {
  type        = string
  description = "Specifies the domain functional level of the first domain in the creation of a new forest. "
}
variable "DatabasePath" {
  type        = string
  description = "Specifies the fully qualified, non-Universal Naming Convention (UNC) path to a directory on a fixed disk of the local computer that contains the domain database "
}
variable "SYSVOLPath" {
  type        = string
  description = "Specifies the fully qualified, non-UNC path to a directory on a fixed disk of the local computer where the Sysvol file is written. "
}
variable "LogPath" {
  type        = string
  description = "Specifies the fully qualified, non-UNC path to a directory on a fixed disk of the local computer where the log file for this operation is written. "
}
variable "AdminSafeModePassword" {
  type        = string
  description = "Supplies the password for the administrator account when the computer is started in Safe Mode or a variant of Safe Mode, such as Directory Services Restore Mode. "
  sensitive   = true
}
variable "idr_service_account" {
  type        = string
  description = "idr_service_account"
}
variable "idr_service_account_pwd" {
  type        = string
  description = "idr_service_account_pwd"
}
variable "Password" {
  type        = string
  description = "the default password for winrm connection"
  sensitive   = true
}
variable "AdminUser" {
  type        = string
  description = "the default username"
  sensitive   = true
}
variable "AdminPD" {
  type        = string
  description = "the default password"
  sensitive   = true
}
##GLOBAL##
variable "SiteName_HQ" {
  description = "HQ Site name"
  type        = string
}
variable "SiteName_POVAgent" {
  description = "POV Agent Site name"
  type        = string
}
variable "SiteName_AD" {
  description = "AD Site name"
  type        = string
}
variable "SiteName_RODC" {
  description = "RODC Site name"
  type        = string
}
variable "SiteName_IT" {
  description = "IT Site name"
  type        = string
}
variable "SiteName_R7" {
  description = "R7 Site name"
  type        = string
}
variable "SiteName_DMZ" {
  description = "DMZ Site name"
  type        = string
}
variable "SiteName_BOOTCAMP" {
  description = "BOOTCAMP Site name"
  type        = string
}
variable "SiteName_JUMPBOX" {
  description = "JUMPBOX Site name"
  type        = string
}
############# Servers : IP Plan #############
######IT
variable "AD_IP" {
  type        = string
  description = "the ip of the IT DC"
}
variable "DHCP_IP" {
  type        = string
  description = "the ip of the IT DHCP"
}
variable "FileServer_IP_IT" {
  type        = string
  description = "the ip of the IT FileServer"
}
variable "WebServer_IP_IT" {
  type        = string
  description = "the ip of the IT Webserver"
}
variable "Win2K22_IP_IT" {
  type        = string
  description = "the ip of the IT Win2K22"
}
variable "Win2K19_IP_IT" {
  type        = string
  description = "the ip of the IT Win2K19"
}
variable "IT_Mask" {
  type        = string
  description = "the Mask of the IT Network"
}
variable "IT_AWSGW" {
  type        = string
  description = "the AWS GW of the IT Network"
}
variable "IT_GW" {
  type        = string
  description = "the GW of the IT Network"
}

######HQ
variable "RODC_IP" {
  type        = string
  description = "the ip of the HQ RODC"
}
variable "FileServer_IP_HQ" {
  type        = string
  description = "the ip of the HQ FileServer"
}
variable "WebServer_IP_HQ" {
  type        = string
  description = "the ip of the HQ Webserver"
}
variable "Win2k22_IP_HQ" {
  type        = string
  description = "the ip of the HQ Win2K22"
}
variable "Win2k19_IP_HQ" {
  type        = string
  description = "the ip of the HQ Win2K19"
}
variable "HQ_Mask" {
  type        = string
  description = "the Mask of the IT Network"
}
variable "HQ_AWSGW" {
  type        = string
  description = "the AWS GW of the IT Network"
}
variable "HQ_GW" {
  type        = string
  description = "the GW of the IT Network"
}


#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   Rapid7 Subnet Module (Orchestrator, Collector, InsightVM, IAS Engine, Network-Sensor, Honeypot, Log Generator)                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Global #############
variable "Rapid7_AWSGW" {
  type        = string
  description = "the gw of the Rapid7 AWS Subnet"
}
variable "NLB_Private_IP" {
  type        = string
  description = "the NLB Private IP"
}

############# Orchestrator #############
variable "Orch_IP" {
  type        = string
  description = "the ip of the Orchestrator"
}
variable "Orch_GW" {
  type        = string
  description = "the gw of the Orchestrator"
}
variable "Orch_Mask" {
  type        = string
  description = "the mask of the Orchestrator"
}
variable "Instance_Type_ORCHESTRATOR" {
  description = "The name of the instance type."
  type        = string
}
variable "Volume_Size_ORCHESTRATOR" {
  description = "Volume Size"
  type        = string
}
variable "ServerName_ORCHESTRATOR" {
  type        = string
  description = "the name of the server. Example ws-test1"
}

############# IVMEngine #############
variable "IVMEngine_IP" {
  type        = string
  description = "the ip of the Orchestrator"
}
variable "Instance_Type_IVMEngine" {
  description = "The name of the instance type."
  type        = string
}
variable "Volume_Size_IVMEngine" {
  description = "Volume Size"
  type        = string
}
variable "ServerName_IVMEngine" {
  type        = string
  description = "the name of the server. Example ws-test1"
}

############# Outpost #############
variable "Outpost_IP" {
  type        = string
  description = "the ip of the Orchestrator"
}
variable "Instance_Type_OUTPOST" {
  description = "The name of the instance type."
  type        = string
}
variable "Volume_Size_OUTPOST" {
  description = "Volume Size"
  type        = string
}
variable "ServerName_OUTPOST" {
  type        = string
  description = "the name of the server. Example ws-test1"
}

############# Collector #############
variable "Coll_IP" {
  type        = string
  description = "the ip of the internal Collector"
}
variable "Coll_GW" {
  type        = string
  description = "the gw of the internal Collector"
}
variable "Coll_Mask" {
  type        = string
  description = "the mask of the internal Collector"
}
variable "Instance_Type_COLLECTOR" {
  description = "The name of the instance type."
  type        = string
}
variable "Volume_Size_COLLECTOR" {
  description = "Volume Size"
  type        = string
}
variable "ServerName_COLLECTOR" {
  type        = string
  description = "the name of the server. Example ws-test1"
}

############# Metasploit #############
variable "Metasploit_IP" {
  type        = string
  description = "the ip of the internal Metasploit"
}
variable "Metasploit_GW" {
  type        = string
  description = "the gw of the internal Metasploit"
}
variable "Metasploit_Mask" {
  type        = string
  description = "the mask of the internal Metasploit"
}
variable "Instance_Type_METASPLOIT" {
  description = "The name of the instance type."
  type        = string
}
variable "Volume_Size_METASPLOIT" {
  description = "Volume Size"
  type        = string
}
variable "ServerName_METASPLOIT" {
  type        = string
  description = "the name of the server. Example ws-test1"
}

############# IAS Engine #############
variable "IASEngine_IP" {
  type        = string
  description = "the ip of the IAS Engine"
}
variable "IASEngine_GW" {
  type        = string
  description = "the gw of the IAS Engine"
}
variable "IASEngine_Mask" {
  type        = string
  description = "the mask of the IAS Engine"
}
variable "ServerName_IASENGINE" {
  type        = string
  description = "the name of the server. Example SRV-ADDS01"
}
variable "Instance_Type_IASENGINE" {
  description = "The name of the instance type."
  type        = string
}
variable "Volume_Size_IASENGINE" {
  description = "Volume Size"
  type        = string
}

############# Honeypot #############
variable "Honeypot_IP" {
  type        = string
  description = "the ip of the Honeypot"
}
variable "Instance_Type_HONEYPOT" {
  description = "The name of the instance type."
  type        = string
}
variable "Volume_Size_HONEYPOT" {
  description = "Volume Size"
  type        = string
}
variable "ServerName_HONEYPOT" {
  description = "the name of the server. Example ws-test1"
  type        = string
}

############# InsightVM #############
variable "IVM_IP1" {
  type        = string
  description = "the ip of the InsighVM Console"
}
variable "IVM_IP2" {
  type        = string
  description = "the ip of the InsighVM Console"
}
variable "IVM_GW" {
  type        = string
  description = "the gw of the InsighVM Console"
}
variable "IVM_Mask" {
  type        = string
  description = "the mask of the InsighVM Console"
}
variable "Instance_Type_VRM_Console" {
  description = "The name of the instance type."
  type        = string
}
variable "Volume_Size_VRM_Console" {
  description = "Volume Size IVM"
  type        = string
}
variable "ServerName_IVM" {
  type        = string
  description = "the name of the server. Example ws-test1"
}
variable "MachineType" {
  description = "type of machine to build - engine, console or asset"
  type        = string
}
variable "VRM_License_Key" {
  description = "License key of console - used to install Insightvm"
  type        = string
}
variable "Instance_Type_VRM_ENGINE" {
  description = "Instance Type Engine"
  type        = string
}
variable "ServerName_VRM_ENGINE" {
  description = "Engine Name"
  type        = string
}
variable "Volume_Size_VRM_TARGET" {
  description = "Volume Size Target"
  type        = string
}
variable "Instance_Type_VRM_TARGET" {
  description = "Instance Type Target"
  type        = string
}
variable "ServerName_VRM_TARGET_Ubu" {
  description = "Target ubu Name"
  type        = string
}
variable "ServerName_VRM_TARGET_Win" {
  description = "Target Win Name"
  type        = string
}
variable "ServerName_IDR_TARGET_Ubu" {
  description = "Target ubu Name"
  type        = string
}
variable "ServerName_IDR_TARGET_Win" {
  description = "Target Win Name"
  type        = string
}
variable "Volume_Size_IDR_TARGET" {
  description = "Volume_Size_IDR_TARGET"
  type        = string
}
variable "Instance_Type_IDR_TARGET" {
  description = "Instance_Type_IDR_TARGET"
}
variable "VRM_ENGINE_IP" {
  description = "Engine IP"
  type        = string
}
variable "IVM_Console_Port" {
  description = "Console Web Port"
  type        = string
}
variable "Volume_Size_VRM_ENGINE" {
  description = "Volume_Size_VRM_ENGINE"
  type        = string
}
############# Log Generator #############
variable "Loggen_IP" {
  type        = string
  description = "the ip of the Log Generator"
}
variable "Loggen_GW" {
  type        = string
  description = "the gw of the Log Generator"
}
variable "Loggen_Mask" {
  type        = string
  description = "the mask of the Log Generator"
}
variable "ServerName_LOGGEN" {
  type        = string
  description = "the name of the server. Example SRV-ADDS01"
}
variable "Instance_Type_LOGGEN" {
  description = "The name of the instance type."
  type        = string
}
variable "Volume_Size_LOGGEN" {
  description = "Volume Size"
  type        = string
}

############# Network Sensor #############
variable "NSensor_IP1" {
  type        = string
  description = "the ip1 of the Network Sensor"
}
variable "NSensor_IP2" {
  type        = string
  description = "the ip2 of the Network Sensor"
}
variable "NSensor_GW" {
  type        = string
  description = "the gw of the Network Sensor"
}
variable "NSensor_Mask" {
  type        = string
  description = "the mask of the Network Sensor"
}
variable "Instance_Type_NSENSOR" {
  description = "The name of the instance type."
  type        = string
}
variable "Volume_Size_NSENSOR" {
  description = "Volume Size"
  type        = string
}
variable "ServerName_NSENSOR" {
  type        = string
  description = "the name of the server. Example ws-test1"
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   POV Agent                                                                                                                                                                                                                                                                                                   
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "POVAgent_EXT_AWSGW" {
  type        = string
  description = "the AWS GW of the POVAgent Network"
}
variable "POVAgent_EXT_GW" {
  type        = string
  description = "the GW of the POVAgent Network"
}
variable "POVAgent_EXT_Mask" {
  type        = string
  description = "the Mask of the POVAgent Network"
}
variable "SEOPS_Orch_IP" {
  type        = string
  description = "the ip1 of the SEOPS Orch"
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   WebAPPs Module for IAS WebApps (Webscantest..) and Global Apps (Jenkins..)                                                                                                                                                                                                                                                                                                   
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Global #############
variable "AWS_ECR_Repository_Name" {
  description = "AWS ECR Repo Name"
  type        = string
}

############# Juice Shop #############
variable "Juice_Shop_Image" {
  description = "Juice Shop AWS URI ECS Image"
  type        = string
}
variable "Juice_Shop_Port" {
  description = "Juice Shop Port"
  type        = string
}
variable "Juice_Shop_Priority" {
  description = "Juice Shop Priority"
  type        = string
}
variable "Juice_Shop_CPU" {
  description = "Juice Shop CPU"
  type        = string
}
variable "Juice_Shop_Memory" {
  description = "Juice Shop Memory"
  type        = string
}

############# Log4j #############
variable "Log4j_Image" {
  description = "Log4j AWS URI ECS Image"
  type        = string
}
variable "Log4j_Port" {
  description = "Log4j Port"
  type        = string
}
variable "Log4j_Priority" {
  description = "Log4j Priority"
  type        = string
}
variable "Log4j_CPU" {
  description = "Log4j CPU"
  type        = string
}
variable "Log4j_Memory" {
  description = "Log4j Memory"
  type        = string
}

############# Hackazon #############
variable "Hackazon_Image" {
  description = "HACKAZON AWS URI ECS Image"
  type        = string
}
variable "Hackazon_Port" {
  description = "hackazon Port"
  type        = string
}
variable "Hackazon_Priority" {
  description = "hackazon Priority"
  type        = string
}
variable "Hackazon_CPU" {
  description = "hackazon CPU"
  type        = string
}
variable "Hackazon_Memory" {
  description = "hackazon Memory"
  type        = string
}

############# GraphQL #############
variable "GraphQL_Image" {
  description = "GraphQL AWS URI ECS Image"
  type        = string
}
variable "GraphQL_Port" {
  description = "graphql Port"
  type        = string
}
variable "GraphQL_Priority" {
  description = "graphql Priority"
  type        = string
}
variable "GraphQL_CPU" {
  description = "graphql CPU"
  type        = string
}
variable "GraphQL_Memory" {
  description = "graphql Memory"
  type        = string
}

############# Docker #############
variable "Docker_IP" {
  description = "The IP of the instance."
  type        = string
}
variable "Instance_Type_DOCKER" {
  description = "The name of the instance type."
  type        = string
}
variable "Volume_Size_DOCKER" {
  description = "Volume Size"
  type        = string
}
variable "ServerName_DOCKER" {
  type        = string
  description = "the name of the server. Example ws-test1"
}

############# crAPI #############
variable "crAPI_Image" {
  description = "crAPI AWS URI ECS Image"
  type        = string
}
variable "crAPI_Port_8888" {
  description = "crapi Port 80"
  type        = string
}
variable "crAPI_Port_443" {
  description = "crapi Port 443"
  type        = string
}
variable "crAPI_Port_8025" {
  description = "crapi Port 5432"
  type        = string
}
variable "crAPI_Priority" {
  description = "crapi Priority"
  type        = string
}
variable "crAPI_CPU" {
  description = "crapi CPU"
  type        = string
}
variable "crAPI_Memory" {
  description = "crapi Memory"
  type        = string
}

############# Jenkins #############
variable "Jenkins_Image" {
  description = "jenkins AWS URI ECS Image"
  type        = string
}
variable "Jenkins_Port" {
  description = "jenkins Port"
  type        = string
}
variable "Jenkins_Priority" {
  description = "jenkins Priority"
  type        = string
}
variable "Jenkins_CPU" {
  description = "jenkins CPU"
  type        = string
}
variable "Jenkins_Memory" {
  description = "jenkins Memory"
  type        = string
}

############# PetClinic #############
variable "PetClinic_Image" {
  description = "petclinic AWS URI ECS Image"
  type        = string
}
variable "PetClinic_Port" {
  description = "petclinic Port"
  type        = string
}
variable "PetClinic_Priority" {
  description = "petclinic Priority"
  type        = string
}
variable "PetClinic_CPU" {
  description = "petclinic CPU"
  type        = string
}
variable "PetClinic_Memory" {
  description = "petclinic Memory"
  type        = string
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Bootcamp                                                                                                                                                                                                                                                                   
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Global Mode #############
############# Standalone Mode #############
variable "BootCamp_Mode" {
  type        = bool
  description = "BootCamp mode"
}
variable "Number_BootCamps" {
  type = list(number)
}
variable "Module_BootCamps_IDR" {
  type = bool
}
variable "Module_BootCamps_IAS" {
  type = bool
}
variable "Module_BootCamps_ICON" {
  type = bool
}
variable "Module_BootCamps_IVM" {
  type = bool
}
variable "BTCP_VRM_Console_Ubu" {
  type = bool
}
variable "BTCP_VRM_Console_Win" {
  type = bool
}
variable "BTCP_VRM_Target_Ubu" {
  type = bool
}
variable "BTCP_VRM_Target_Win" {
  type = bool
}
variable "BTCP_VRM_Scan_engine_Win" {
  type = bool
}
variable "BTCP_VRM_Scan_engine_Ubu" {
  type = bool
}
variable "BTCP_VRM_Target_Win_IPs" {
  type = list(string)
}
variable "BTCP_VRM_Target_Ubu_IPs" {
  type = list(string)
}
variable "BTCP_IDR_Target_Win_IPs" {
  type = list(string)
}
variable "BTCP_IDR_Target_Ubu_IPs" {
  type = list(string)
}
variable "BTCP_Jumpbox_IP" {
  type        = string
  description = "BootCamp Jumpbox IP Address"
}
variable "BTCP_IDR_DC_IP" {
  type        = string
  description = "BTCP_DC_IP IP Address"
}
variable "BTCP_IDR_GW" {
  type        = string
  description = "BootCamp GW Address"
}
variable "BTCP_IDR_Mask" {
  type        = string
  description = "BootCamp Mask Address"
}
variable "BTCP_IDR_AWSGW" {
  type        = string
  description = "BootCamp AWS Mask Address"
}
variable "BTCP_VRM_Console_Ubu_IP2" {
  type        = string
  description = "BootCamp AWS Mask Address"
}
variable "BTCP_VRM_ServerName_Scan_engine_Win" {
  type        = string
  description = "BTCP_VRM_ServerName_Scan_engine_Win"
}
variable "BTCP_VRM_ServerName_Scan_Engine_Ubu" {
  type        = string
  description = "BTCP_VRM_ServerName_Scan_Engine_Ubu"
}
variable "BTCP_VRM_Console_Win_IP2" {
  type        = string
  description = "BTCP_VRM_Console_Win_IP2"
}
variable "BTCP_VRM_ServerName_Scan_Target_Win" {
  type        = string
  description = "BTCP_VRM_ServerName_Scan_Target_Win"
}
variable "BTCP_VRM_ServerName_Scan_Target_Ubu" {
  type        = string
  description = "BTCP_VRM_ServerName_Scan_Target_Ubu"
}
variable "BTCP_JMP_Mask" {
  type        = string
  description = "BTCP_JMP_Mask"
}
variable "BTCP_JMP_GW" {
  type        = string
  description = "BTCP_JMP_GW"
}
variable "BTCP_JMP_AWSGW" {
  type        = string
  description = "BTCP_JMP_AWSGW"
}
variable "BTCP_VRM_Mask" {
  type        = string
  description = "BTCP_VRM_Mask"
}
variable "BTCP_VRM_Console_Win_IP1" {
  type        = string
  description = "BTCP_VRM_Console_Win_IP1"
}
variable "BTCP_VRM_GW" {
  type        = string
  description = "BTCP_VRM_GW"
}
variable "BTCP_VRM_Engine_Win_IP" {
  type        = string
  description = "BTCP_VRM_Engine_Win_IP"
}
variable "BTCP_VRM_Engine_Ubu_IP" {
  type        = string
  description = "BTCP_VRM_Engine_Ubu_IP"
}
variable "BTCP_VRM_AWSGW" {
  type        = string
  description = "BTCP_VRM_AWSGW"
}
variable "BTCP_VRM_Dummy_Data" {
  type        = string
  description = "BTCP_VRM_Dummy_Data"
}
variable "BTCP_VRM_ServerName_Console_Ubu" {
  type        = string
  description = "BTCP_VRM_ServerName_Console_Ubu"
}
variable "BTCP_VRM_ServerName_Console_Win" {
  type        = string
  description = "BTCP_VRM_ServerName_Console_Win"
}
variable "BTCP_VRM_SiteName" {
  type        = string
  description = "BTCP_VRM_SiteName"
}
variable "BTCP_VRM_Console_Ubu_IP1" {
  type        = string
  description = "BTCP_VRM_Console_Ubu_IP1"
}
variable "BTCP_IDR_Collector_Win" {
  type        = bool
  description = "BTCP_IDR_Collector_Win"
}
variable "BTCP_IDR_Collector_Ubu" {
  type        = bool
  description = "BTCP_IDR_Collector_Ubu"
}
variable "BTCP_IDR_ADDS01" {
  type        = bool
  description = "BTCP_IDR_ADDS01"
}
variable "BTCP_IDR_Orchestrator" {
  type        = bool
  description = "BTCP_IDR_Orchestrator"
}
variable "BTCP_IDR_NSensor" {
  type        = bool
  description = "BTCP_IDR_NSensor"
}
variable "BTCP_IDR_Target_Win" {
  type        = bool
  description = "BTCP_IDR_Target_Win"
}
variable "BTCP_IDR_Target_Ubu" {
  type        = bool
  description = "BTCP_IDR_Target_Ubu"
}
variable "BTCP_IDR_Loggen" {
  type        = bool
  description = "BTCP_IDR_Loggen"
}
variable "BTCP_IDR_Honeypot" {
  type        = bool
  description = "BTCP_IDR_Honeypot"
}
variable "BTCP_IDR_Orch_IP" {
  type        = string
  description = "BTCP_IDR_Orch_IP"
}
variable "BTCP_IDR_NSensor_IP2" {
  type        = string
  description = "BTCP_IDR_NSensor_IP2"
}
variable "BTCP_IDR_ServerName_Honeypot" {
  type        = string
  description = "BTCP_IDR_ServerName_Honeypot"
}
variable "BTCP_IDR_ServerName_Target_Ubu" {
  type        = string
  description = "BTCP_IDR_ServerName_Target_Ubu"
}
variable "BTCP_IDR_ServerName_ADDS01" {
  type        = string
  description = "BTCP_IDR_ServerName_ADDS01"
}
variable "BTCP_IDR_ServerName_Target_Win" {
  type        = string
  description = "BTCP_IDR_ServerName_Target_Win"
}
variable "BTCP_IDR_ServerName_Coll_Ubu" {
  type        = string
  description = "BTCP_IDR_ServerName_Coll_Ubu"
}
variable "BTCP_IDR_ServerName_Coll_Win" {
  type        = string
  description = "BTCP_IDR_ServerName_Coll_Win"
}
variable "BTCP_IDR_NLB_Private_IP" {
  type        = string
  description = "BTCP_IDR_NLB_Private_IP"
}
variable "BTCP_IDR_ServerName_NSensor" {
  type        = string
  description = "BTCP_IDR_ServerName_NSensor"
}
variable "BTCP_IDR_NSensor_IP1" {
  type        = string
  description = "BTCP_IDR_NSensor_IP1"
}
variable "BTCP_IDR_SiteName" {
  type        = string
  description = "BTCP_IDR_SiteName"
}
variable "BTCP_IDR_ServerName_Orch" {
  type        = string
  description = "BTCP_IDR_ServerName_Orch"
}
variable "BTCP_IDR_ServerName_Loggen" {
  type        = string
  description = "BTCP_IDR_ServerName_Loggen"
}
variable "BTCP_IDR_Coll_IP_Ubu" {
  type        = string
  description = "BTCP_IDR_Coll_IP_Ubu"
}
variable "BTCP_IDR_Coll_IP_Win" {
  type        = string
  description = "BTCP_IDR_Coll_IP_Win"
}
variable "BTCP_IDR_Honeypot_IP" {
  type        = string
  description = "BTCP_IDR_Honeypot_IP"
}
variable "BTCP_IDR_Loggen_IP" {
  type        = string
  description = "BTCP_IDR_Loggen_IP"
}
variable "BTCP_AdminUser" {
  type        = string
  description = "the default username"
  sensitive   = true
}
variable "BTCP_AdminPD" {
  type        = list(string)
  description = "the default password"
  sensitive   = true
}
variable "BTCP_idr_service_account" {
  type        = string
  description = "the default password"
  sensitive   = true
}
variable "BTCP_Public_IP_Access" {
  type        = string
  description = "Public IP Address"
}
variable "BTCP_Tokens" {
  type        = list(string)
  description = "Insight Token for Agents"
}
variable "BTCP_Tokens_HONEYPOT" {
  description = "Honeypot Token"
  type        = list(string)
}
variable "BTCP_VRM_License_Keys" {
  description = "License key of console - used to install Insightvm"
  type        = list(string)
}
