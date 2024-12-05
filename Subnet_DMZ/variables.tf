#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                             DMZ Subnet Variables                                                                              #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Environement                                                                                                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "Owner_Email" {}
variable "Tenant" {}
variable "JIRA_ID" {}
variable "DomainName" {}
variable "TimeZoneID" {}
variable "Token" {}
variable "R7_Region" {}
variable "AdminUser" {}
variable "AdminPD_ID" {}
variable "ZoneName" {}
variable "selected_Zone_ID" {}
variable "VR_Agent_File" {}
variable "SiteName" {}
variable "SiteName_EXTRODC" {}
variable "SiteName_AD" {}
variable "SiteName_DMZ" {}
variable "Deployment_Mode" {}
variable "AWS_Region" {}
variable "PhishingName" {}
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Features                                                                                                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "External_Collector_Linux_Module" {}
variable "External_Collector_Windows_Module" {}
variable "POVAgent_Module" {}
variable "Hosted_Console_Mode" {}
variable "InsightVM_Dummy_Data_HCIVM" {}
variable "use_route53_hz" {}
variable "Agent_Type" {}
variable "SEOPS_VR_Install" {}
variable "Keyboard_Layout" {}
variable "Routing_Type" {}
variable "External_AD_Module" {}
variable "External_IASEngine_Module" {}
variable "External_Orch_Module" {}
variable "External_InsightVM_Module" {}
variable "External_InsightVM_Lockdown" {}
variable "External_NetworkSensor_Module" {}
variable "External_Win11_Module" {}
variable "External_Win22_Module" {}
variable "Jumpbox_Module" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   IAM Module (IAM Role, Instance Profile, Policy, Instance Certificates)                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "Key_Name_External" {}
variable "Key_Name_Internal" {}
variable "Instance_Profile_Name" {}
variable "Instance_Profile_Name_AWSAMILINUX" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  User Lists                                                                                                                                                                                                                                        
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "User_Lists" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Scripts Lists                                                                                                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "ScriptList_LINUXCOLLECTOR" {}
variable "ScriptList_VRM_CONSOLE_UBU" {}
variable "ScriptList_ADDS01" {}
variable "ScriptList_IASENGINE" {}
variable "ScriptList_ORCHESTRATOR" {}
variable "ScriptList_NSENSOR" {}
variable "ScriptList_WIN11" {}
variable "ScriptList_IDR_WINCOLLECTOR" {}
variable "ScriptList_LINUXAWS" {}
variable "ScriptList_WIN22" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   S3 Module (S3 Bucket, Files)                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "Bucket_Name" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   Networking                                                                                                                                                                                                                                                                                  
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "sg_dmz_id" {}
variable "sg_dmz_ivm_id" {}
variable "sg_dmz_ivm_ltd_id" {}
variable "subnet_dmz_id" {}
variable "vpc_id" {}
variable "sg_jumpbox_id" {}
variable "ExtNLB_Private_IP" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   ALB                                                                                                                                                                                                                                                                                  
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "aws_lb_listener_ivm443_id" {}
variable "aws_lb_alb_ivm_dnsname" {}
variable "aws_lb_alb_ivm_zoneid" {}
variable "HCIVM_Priority" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   DMZ Subnet Module                                                                                                                                                                                                                                                                                        
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Global #############  
variable "Instance_Mask" {}
variable "Instance_GW" {}
variable "Instance_AWSGW" {}

############# External Collector #############  
variable "ServerName_EXTCOLLECTOR" {}
variable "Instance_Type_EXTCOLLECTOR" {}
variable "vol_size_EXTCOLLECTOR" {}
variable "ExtLinuxCollector_IP" {}
variable "ExtWinCollector_IP" {}

############# External AWS Linux #############  
variable "ServerName_EXTAWS" {}
variable "Instance_Type_EXTAWS" {}
variable "vol_size_EXTAWS" {}
variable "ExtLinuxAWS_IP" {}

############# External IVM Hosted Console #############    
variable "IVM_Hosted_Console_IP" {}
variable "IVM_Hosted_Console_Port" {}
variable "ServerName_HCIVM" {}
variable "Instance_Type_HCIVM" {}
variable "vol_size_HCIVM" {}
variable "Password_ID" {}
variable "VRM_License_Key" {}
variable "MachineType" {}
variable "VRM_ENGINE_IP" {}
variable "ServerName_VRM_ENGINE" {}

############# External ADDS01 #############
variable "Instance_Type_AD" {}
variable "Volume_Size_AD" {}
variable "ServerName_EXTAD" {}
variable "ForestMode" {}
variable "DomainMode" {}
variable "DatabasePath" {}
variable "SYSVOLPath" {}
variable "LogPath" {}
variable "AdminSafeModePassword_ID" {}
variable "idr_service_account" {}
variable "idr_service_account_pwd_ID" {}
variable "ExtAD_IP" {}
variable "ServerName_EXTRODC" {}
variable "ExtRODC_IP" {}

############# External IASEngine #############
variable "Instance_Type_IASENGINE" {}
variable "Volume_Size_IASENGINE" {}
variable "ExtIASEngine_IP" {}
variable "ServerName_EXTIASENGINE" {}

############# External Orchestrator #############
variable "Instance_Type_ORCHESTRATOR" {}
variable "Volume_Size_ORCHESTRATOR" {}
variable "ExtOrch_IP" {}
variable "ServerName_EXTORCHESTRATOR" {}

############# External Network Sensor #############
variable "Instance_Type_NSENSOR" {}
variable "Volume_Size_NSENSOR" {}
variable "ExtNSensor_IP1" {}
variable "ExtNSensor_IP2" {}
variable "ServerName_EXTNSENSOR" {}

############# External Windows 11 #############
variable "ServerName_EXTWIN11" {}
variable "Instance_Type_WIN11" {}
variable "Volume_Size_WIN11" {}
variable "User_List_EXTWIN11" {}

############# External Windows 22 #############
variable "ServerName_EXTWIN22" {}
variable "Instance_Type_WIN22" {}
variable "Volume_Size_WIN22" {}
variable "User_List_EXTWIN22" {}

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
variable "ami_aws_linux" {}
