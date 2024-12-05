#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                       Bootcamp Module VRM Variables Definitions                                                                     #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  AWS Region                                                                                                                                                                                                                                                                   
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "AWS_Region" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Features                                                                                                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "Module_BootCamps_IVM" {}
variable "BTCP_VRM_Console_Ubu" {}
variable "BTCP_VRM_Console_Win" {}
variable "BTCP_VRM_Target_Ubu" {}
variable "BTCP_VRM_Target_Win" {}
variable "BTCP_VRM_Scan_engine_Win" {}
variable "BTCP_VRM_Scan_engine_Ubu" {}
variable "BTCP_VRM_Target_Win_IPs" {}
variable "BTCP_VRM_Target_Ubu_IPs" {}
variable "BTCP_VRM_SiteName" {}
variable "BTCP_VRM_Console_Ubu_IP1" {}
variable "BTCP_VRM_Console_Ubu_IP2" {}
variable "BTCP_VRM_Console_Win_IP1" {}
variable "BTCP_VRM_Console_Win_IP2" {}
variable "BTCP_VRM_ServerName_Console_Win" {}
variable "BTCP_VRM_ServerName_Console_Ubu" {}
variable "BTCP_VRM_ServerName_Scan_engine_Win" {}
variable "BTCP_VRM_ServerName_Scan_Engine_Ubu" {}
variable "BTCP_VRM_ServerName_Scan_Target_Ubu" {}
variable "BTCP_VRM_ServerName_Scan_Target_Win" {}
variable "BTCP_VRM_Engine_Ubu_IP" {}
variable "BTCP_VRM_Engine_Win_IP" {}
variable "BTCP_IDR_NSensor" {}
variable "BTCP_VRM_GW" {}
variable "BTCP_VRM_Mask" {}
variable "BTCP_VRM_AWSGW" {}
variable "SEOPS_VR_Install" {}
variable "Deployment_Mode" {}
variable "BTCP_VRM_Dummy_Data" {}
variable "Routing_Type" {}
variable "PhishingName" {}

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
variable "Agent_Type" {}
variable "Lab_Number" {}
variable "ZoneName" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Networking                                                                                                                                                                                                            
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "private_subnet_ivm_id" {}
variable "internal_sg_id" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Scripts Lists                                                                                                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "ScriptList_VRM_CONSOLE_UBU" {}
variable "ScriptList_VRM_CONSOLE_WIN" {}
variable "ScriptList_VRM_ENGINE_WIN" {}
variable "ScriptList_VRM_ENGINE_UBU" {}
variable "ScriptList_VRM_TARGET_WIN" {}
variable "ScriptList_VRM_TARGET_UBU" {}
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
#   Credentials                                                                                                                                                                                                                                                                                           
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Global #############
variable "idr_service_account" {}
variable "idr_service_account_pwd_ID" {}
variable "AdminSafeModePassword_ID" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   Credentials                                                                                                                                                                                                                                                                                           
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Global #############
variable "traffic_mirror_filter_id" {}
variable "traffic_mirror_target_id" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   Rapid7 Module (Orchestrator, Collector, InsightVM, IAS Engine, Network-Sensor, Honeypot, Log Generator)                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Global #############

############# InsightVM #############
variable "Instance_Type_VRM_Console" {}
variable "Volume_Size_VRM_Console" {}
variable "Password_ID" {}
variable "VRM_License_Key" {}
variable "MachineType" {}
variable "IVM_Console_Port" {}

############# VRM Engine #############
variable "VRM_ENGINE_IP" {}
variable "Instance_Type_VRM_ENGINE" {}
variable "Volume_Size_VRM_ENGINE" {}
variable "ServerName_VRM_ENGINE" {}

############# VRM Target #############
variable "Instance_Type_WIN11" {}
variable "Volume_Size_WIN11" {}
variable "Instance_Type_LINUX" {}
variable "Volume_Size_LINUX" {}

############# ADDS01 #############
variable "Instance_Type_AD" {}
variable "Volume_Size_AD" {}
variable "ForestMode" {}
variable "DomainMode" {}
variable "DatabasePath" {}
variable "SYSVOLPath" {}
variable "LogPath" {}
