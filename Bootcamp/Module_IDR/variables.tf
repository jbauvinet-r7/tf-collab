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
variable "Deployment_Mode" {}
variable "Routing_Type" {}
variable "Agent_Type" {}
variable "use_route53_hz" {}
variable "BTCP_IDR_Loggen" {}
variable "BTCP_IDR_Orchestrator" {}
variable "BTCP_IDR_NSensor" {}
variable "BTCP_IDR_Honeypot" {}
variable "BTCP_IDR_Collector_Ubu" {}
variable "BTCP_IDR_Collector_Win" {}
variable "BTCP_IDR_Target_Ubu" {}
variable "BTCP_IDR_Target_Win" {}
variable "BTCP_IDR_ADDS01" {}

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
variable "AdminUser" {}
variable "AdminPD_ID" {}
variable "Keyboard_Layout" {}
variable "Lab_Number" {}
variable "Password_ID" {}
variable "ZoneName" {}
variable "PhishingName" {}
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Networking                                                                                                                                                                                                            
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "private_subnet_idr_id" {}
variable "internal_sg_id" {}
variable "sg_jumpbox_id" {}
variable "NLB_Private_IP" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Scripts Lists                                                                                                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "ScriptList_NSENSOR" {}
variable "ScriptList_LINUXCOLLECTOR" {}
variable "ScriptList_IDR_WINCOLLECTOR" {}
variable "ScriptList_ORCHESTRATOR" {}
variable "ScriptList_LOGGEN" {}
variable "ScriptList_IDR_TARGET_UBU" {}
variable "ScriptList_IDR_TARGET_WIN" {}
variable "ScriptList_ADDS01" {}

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
#   BTCP                                                                                                                                                                                                                                                                                        
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# BTCP #############
variable "BTCP_IDR_DC_IP" {}
variable "BTCP_IDR_Mask" {}
variable "BTCP_IDR_GW" {}
variable "BTCP_IDR_AWSGW" {}
variable "idr_service_account" {}
variable "idr_service_account_pwd_ID" {}
variable "AdminSafeModePassword_ID" {}
variable "BTCP_IDR_SiteName" {}
variable "VRM_License_Key" {}

############# Orchestrator #############
variable "BTCP_IDR_Orch_IP" {}
variable "Instance_Type_ORCHESTRATOR" {}
variable "Volume_Size_ORCHESTRATOR" {}
variable "BTCP_IDR_ServerName_Orch" {}

############# Collector #############
variable "BTCP_IDR_Coll_IP_Ubu" {}
variable "BTCP_IDR_Coll_IP_Win" {}
variable "Instance_Type_COLLECTOR" {}
variable "Volume_Size_COLLECTOR" {}
variable "BTCP_IDR_ServerName_Coll_Ubu" {}
variable "BTCP_IDR_ServerName_Coll_Win" {}

############# Honeypot #############
variable "BTCP_IDR_Honeypot_IP" {}
variable "aws_ami_honeypot" {}
variable "Instance_Type_HONEYPOT" {}
variable "Volume_Size_HONEYPOT" {}
variable "BTCP_IDR_ServerName_Honeypot" {}
variable "Token_HONEYPOT" {}

############# Log Generator #############
variable "BTCP_IDR_Loggen_IP" {}
variable "BTCP_IDR_ServerName_Loggen" {}
variable "Instance_Type_LOGGEN" {}
variable "Volume_Size_LOGGEN" {}

############# Network Sensor #############
variable "BTCP_IDR_NSensor_IP1" {}
variable "BTCP_IDR_NSensor_IP2" {}
variable "Instance_Type_NSENSOR" {}
variable "Volume_Size_NSENSOR" {}
variable "BTCP_IDR_ServerName_NSensor" {}

############# IDR Target #############
variable "BTCP_IDR_Target_Win_IPs" {}
variable "BTCP_IDR_Target_Ubu_IPs" {}
variable "BTCP_IDR_ServerName_Target_Ubu" {}
variable "BTCP_IDR_ServerName_Target_Win" {}
variable "Instance_Type_WIN11" {}
variable "Volume_Size_WIN11" {}
variable "Instance_Type_LINUX" {}
variable "Volume_Size_LINUX" {}

############# Active Directory #############
variable "ForestMode" {}
variable "DomainMode" {}
variable "DatabasePath" {}
variable "SYSVOLPath" {}
variable "LogPath" {}
variable "Instance_Type_AD" {}
variable "Volume_Size_AD" {}
variable "BTCP_IDR_ServerName_ADDS01" {}
variable "SiteName_AD" {}
