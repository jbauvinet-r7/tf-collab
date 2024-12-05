#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                       Rapid7 Subnet Variables Definitions                                                                     #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  AWS Region                                                                                                                                                                                                                                                                   
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "AWS_Region" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Features                                                                                                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "InsightAppSec_Module" {}
variable "InsightAppSec_IAS_engine" {}
variable "InsightVM_Module" {}
variable "InsightVM_Dummy_Data" {}
variable "InsightIDR_Module" {}
variable "Honeypot_Module" {}
variable "InsightIDR_Dummy_Data" {}
variable "InsightConnect_Module" {}
variable "NetworkSensor_Module" {}
variable "Deployment_Mode" {}
variable "Routing_Type" {}
variable "Metasploit_Module" {}
variable "Agent_Type" {}
variable "SEOPS_VR_Install" {}
variable "use_route53_hz" {}
variable "Keyboard_Layout" {}
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Environement                                                                                                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "Owner_Email" {}
variable "R7_Region" {}
variable "R7vpn_List" {}
variable "vpc_id" {}
variable "VR_Agent_File" {}
variable "Tenant" {}
variable "JIRA_ID" {}
variable "TimeZoneID" {}
variable "DomainName" {}
variable "Token" {}
variable "Token_HONEYPOT" {}
variable "AdminUser" {}
variable "AdminPD_ID" {}
variable "PhishingName" {}
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Networking                                                                                                                                                                                                            
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "subnet_rapid7_id" {}
variable "sg_rapid7_id" {}
variable "eni_dmz_public_id" {}
variable "eni_fw_int_id" {}
variable "sg_fw_id" {}
variable "sg_fw_public_id" {}
variable "sg_dmz_id" {}
variable "sg_hq_id" {}
variable "sg_it_id" {}
variable "sg_jumpbox_id" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Scripts Lists                                                                                                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "ScriptList_VRM_CONSOLE_UBU" {}
variable "ScriptList_NSENSOR" {}
variable "ScriptList_LINUXCOLLECTOR" {}
variable "ScriptList_METASPLOIT" {}
variable "ScriptList_ORCHESTRATOR" {}
variable "ScriptList_LOGGEN" {}
variable "ScriptList_IASENGINE" {}



#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   IAM Module (IAM Role, Instance Profile, Policy, Instance Certificates)                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "Key_Name_Internal" {}
variable "Key_Name_External" {}
variable "Instance_Profile_Name" {}
variable "Iam_Policy_Name" {}
variable "Role_Name" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   S3 Module (S3 Bucket, Files)                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "Bucket_Name" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  AMIs                                                                                                                                                                                                                                                         
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "ami_ubuntu_20" {}
variable "ami_ubuntu_22" {}
variable "ami_debian_12" {}
variable "ami_windows_2k22" {}
variable "ami_centos_8" {}
variable "ami_windows_11" {}
variable "ami_windows_10" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  User Lists                                                                                                                                                                                                                                        
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "User_Lists" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   Subnet IT & HQ                                                                                                                                                                                                                                                                                              
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# IT #############
variable "AD_IP" {}
variable "idr_service_account" {}
variable "idr_service_account_pwd_ID" {}
variable "SiteName_R7" {}
variable "SiteName_RODC" {}
variable "AdminSafeModePassword_ID" {}

############# HQ #############
variable "ServerName_RODC_HQ" {}
variable "RODC_IP" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   Rapid7 Subnet Module (Orchestrator, Collector, InsightVM, IAS Engine, Network-Sensor, Honeypot, Log Generator)                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Global #############
variable "Rapid7_AWSGW" {}
variable "NLB_Private_IP" {}

############# Orchestrator #############
variable "Orch_IP" {}
variable "Orch_Mask" {}
variable "Orch_GW" {}
variable "Instance_Type_ORCHESTRATOR" {}
variable "Volume_Size_ORCHESTRATOR" {}
variable "ServerName_ORCHESTRATOR" {}

############# Collector #############
variable "Coll_IP" {}
variable "Coll_Mask" {}
variable "Coll_GW" {}
variable "Instance_Type_COLLECTOR" {}
variable "Volume_Size_COLLECTOR" {}
variable "ServerName_COLLECTOR" {}

############# IAS Engine #############
variable "IASEngine_IP" {}
variable "IASEngine_Mask" {}
variable "IASEngine_GW" {}
variable "ServerName_IASENGINE" {}
variable "Instance_Type_IASENGINE" {}
variable "Volume_Size_IASENGINE" {}

############# Metasploit #############
variable "Metasploit_IP" {}
variable "Metasploit_Mask" {}
variable "Metasploit_GW" {}
variable "Instance_Type_METASPLOIT" {}
variable "Volume_Size_METASPLOIT" {}
variable "ServerName_METASPLOIT" {}

############# Honeypot #############
variable "Honeypot_IP" {}
variable "aws_ami_honeypot" {}
variable "Instance_Type_HONEYPOT" {}
variable "Volume_Size_HONEYPOT" {}
variable "ServerName_HONEYPOT" {}

############# InsightVM #############
variable "IVM_IP1" {}
variable "IVM_IP2" {}
variable "IVM_Mask" {}
variable "IVM_GW" {}
variable "Instance_Type_VRM_Console" {}
variable "Volume_Size_VRM_Console" {}
variable "ServerName_IVM" {}
variable "Password_ID" {}
variable "VRM_License_Key" {}
variable "MachineType" {}
variable "VRM_ENGINE_IP" {}
variable "ServerName_VRM_ENGINE" {}
variable "ivm_target_group_arn" {}
variable "IVM_Console_Port" {}

############# Log Generator #############
variable "Loggen_IP" {}
variable "Loggen_Mask" {}
variable "Loggen_GW" {}
variable "ServerName_LOGGEN" {}
variable "Instance_Type_LOGGEN" {}
variable "Volume_Size_LOGGEN" {}

############# Network Sensor #############
variable "NSensor_IP1" {}
variable "NSensor_IP2" {}
variable "NSensor_Mask" {}
variable "NSensor_GW" {}
variable "Instance_Type_NSENSOR" {}
variable "Volume_Size_NSENSOR" {}
variable "ServerName_NSENSOR" {}
