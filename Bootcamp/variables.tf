#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                       Bootcamp Variables Definitions                                                                          #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  AWS Region                                                                                                                                                                                                                                                                   
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "AWS_Region" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Environement                                                                                                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "Owner_Email" {}
variable "JIRA_ID" {}
variable "VR_Agent_File" {}
variable "Tenant" {}
variable "R7_Region" {}
variable "DomainName" {}
variable "Password" {}
variable "TimeZoneID" {}
variable "BTCP_Token" {}
variable "AdminUser" {}
variable "AdminPD" {}
variable "SiteName" {}
variable "SiteName_RODC" {}
variable "R7vpn_List" {}
variable "Acl_Value" {}
variable "Iam_Policy_Name" {}
variable "Role_Name" {}
variable "PhishingName" {}
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Features                                                                                                                                                                                                                                                         
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "use_route53_hz" {}
variable "InsightVM_Dummy_Data" {}
variable "InsightIDR_Module" {}
variable "InsightIDR_Dummy_Data" {}
variable "InsightConnect_Module" {}
variable "NetworkSensor_Module" {}
variable "Honeypot_Module" {}
variable "InsightVM_Module" {}
variable "Metasploit_Module" {}
variable "Agent_Type" {}
variable "SEOPS_VR_Install" {}
variable "Deployment_Mode" {}
variable "Routing_Type" {}
variable "Module_BootCamps_IDR" {}
variable "Module_BootCamps_IVM" {}
variable "Module_BootCamps_ICON" {}
variable "Module_BootCamps_IAS" {}
variable "BTCP_VRM_Console_Ubu" {}
variable "BTCP_VRM_Console_Win" {}
variable "BTCP_VRM_Scan_engine_Win" {}
variable "BTCP_VRM_Scan_engine_Ubu" {}
variable "BTCP_VRM_Target_Win_IPs" {}
variable "BTCP_VRM_Target_Ubu_IPs" {}
variable "BTCP_VRM_SiteName" {}
variable "BTCP_VRM_ServerName_Scan_Target_Ubu" {}
variable "BTCP_VRM_Dummy_Data" {}
variable "BTCP_VRM_AWSGW" {}
variable "BTCP_VRM_GW" {}
variable "BTCP_VRM_Mask" {}
variable "BTCP_VRM_Console_Win_IP2" {}
variable "BTCP_VRM_ServerName_Console_Ubu" {}
variable "BTCP_VRM_ServerName_Scan_engine_Win" {}
variable "BTCP_VRM_Console_Ubu_IP2" {}
variable "BTCP_VRM_ServerName_Scan_Target_Win" {}
variable "BTCP_VRM_Engine_Win_IP" {}
variable "BTCP_VRM_Engine_Ubu_IP" {}
variable "BTCP_VRM_ServerName_Console_Win" {}
variable "BTCP_VRM_Console_Ubu_IP1" {}
variable "BTCP_VRM_Console_Win_IP1" {}
variable "BTCP_VRM_ServerName_Scan_Engine_Ubu" {}
variable "BTCP_VRM_Target_Win" {}
variable "BTCP_VRM_Target_Ubu" {}
variable "BTCP_IDR_Orchestrator" {}
variable "BTCP_IDR_NSensor" {}
variable "BTCP_IDR_Collector_Ubu" {}
variable "BTCP_IDR_Collector_Win" {}
variable "BTCP_IDR_Honeypot" {}
variable "BTCP_IDR_SiteName" {}
variable "BTCP_IDR_Loggen" {}
variable "BTCP_IDR_Target_Ubu_IPs" {}
variable "BTCP_IDR_Target_Ubu" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  AMIs                                                                                                                                                                                                                                                         
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "ami_windows_10" {}
variable "ami_windows_11" {}
variable "ami_windows_2k19" {}
variable "ami_windows_2k22" {}
variable "ami_ubuntu_20" {}
variable "ami_ubuntu_22" {}
variable "ami_centos_8" {}
variable "ami_debian_12" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   S3 Module (S3 Bucket, Files)                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "Bucket_Name" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   Bootcamp                                                                                                                                                                                                                                                                                          
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "Lab_Number" {}
variable "ZoneName" {}
variable "Zone_ID" {}
variable "Keyboard_Layout" {}
variable "Public_IP_Access" {}


#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   IAM Module (IAM Role, Instance Profile, Policy, Instance Certificates)                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "Instance_Profile_Name" {}
variable "Key_Name_Internal" {}
variable "Key_Name_External" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   Scripts List                                                                                                                                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "ScriptList_ADDS01" {}
variable "ScriptList_2K19" {}
variable "ScriptList_2K22" {}
variable "ScriptList_DHCP" {}
variable "ScriptList_FILESERVER" {}
variable "ScriptList_WEBSERVER" {}
variable "ScriptList_WIN10" {}
variable "ScriptList_WIN11" {}
variable "ScriptList_JUMPBOX" {}
variable "ScriptList_LOGGEN" {}
variable "ScriptList_LINUXCOLLECTOR" {}
variable "ScriptList_ORCHESTRATOR" {}
variable "ScriptList_VRM_CONSOLE_UBU" {}
variable "ScriptList_VRM_CONSOLE_WIN" {}
variable "ScriptList_METASPLOIT" {}
variable "ScriptList_NSENSOR" {}
variable "ScriptList_LINUX" {}
variable "ScriptList_VRM_ENGINE_WIN" {}
variable "ScriptList_VRM_ENGINE_UBU" {}
variable "ScriptList_VRM_TARGET_WIN" {}
variable "ScriptList_VRM_TARGET_UBU" {}
variable "ScriptList_IDR_WINCOLLECTOR" {}
variable "ScriptList_IDR_TARGET_WIN" {}
variable "ScriptList_IDR_TARGET_UBU" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Jumpbox                                                                                                                                                                                                                                      
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "BTCP_Jumpbox_IP" {}
variable "BTCP_JMP_Mask" {}
variable "BTCP_JMP_GW" {}
variable "BTCP_JMP_AWSGW" {}
variable "ServerName_JUMPBOX" {}
variable "Instance_Type_JUMPBOX" {}
variable "Volume_Size_JUMPBOX" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Windows Server (ADDS01 + SRV2K19 + SRV2K22)                                                                                                                                                                                                                                      
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# ADDS01 #############
variable "Instance_Type_AD" {}
variable "Volume_Size_AD" {}
variable "ServerName_AD" {}
variable "ForestMode" {}
variable "DomainMode" {}
variable "DatabasePath" {}
variable "SYSVOLPath" {}
variable "LogPath" {}
variable "AdminSafeModePassword" {}
variable "idr_service_account" {}
variable "idr_service_account_pwd" {}
variable "BTCP_IDR_DC_IP" {}

############# 2K19 #############
variable "ServerName_2K19" {}
variable "win2K19_ip" {}

############# VRM Engine #############
variable "VRM_ENGINE_IP" {}
variable "Instance_Type_VRM_ENGINE" {}
variable "Volume_Size_VRM_ENGINE" {}
variable "ServerName_VRM_ENGINE" {}

############# VRM Target #############
variable "Instance_Type_VRM_TARGET" {}
variable "Volume_Size_VRM_TARGET" {}

############# 2K22 #############
variable "ServerName_2K22" {}
variable "win2K22_ip" {}

############# FileServer #############
variable "ServerName_FILESERVER" {}
variable "fileserver_ip" {}

############# WebServer #############
variable "ServerName_WEBSERVER" {}
variable "webserver_ip" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  User Lists                                                                                                                                                                                                                                        
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "User_Lists" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Linux                                                                                                                                                                                                                                         
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "Instance_Count_LINUX" {}
variable "Instance_Type_LINUX" {}
variable "Volume_Size_LINUX" {}
variable "ServerName_LINUX" {}
variable "User_List_LINUX" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Windows 10                                                                                                                                                                                                                                         
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "Instance_Count_WIN10" {}
variable "Instance_Type_WIN10" {}
variable "Volume_Size_WIN10" {}
variable "ServerName_WIN10" {}
variable "User_List_WIN10" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Windows 11                                                                                                                                                                                                                                         
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "Instance_Count_WIN11" {}
variable "Instance_Type_WIN11" {}
variable "Volume_Size_WIN11" {}
variable "ServerName_WIN11" {}
variable "User_List_WIN11" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   Rapid7 Module (Orchestrator, Collector, InsightVM, IAS Engine, Network-Sensor, Honeypot, Log Generator)                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Global #############
variable "BTCP_IDR_AWSGW" {}
variable "BTCP_IDR_GW" {}
variable "BTCP_IDR_Mask" {}

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

############# IAS Engine #############
variable "BTCP_IASEngine_IP" {}
variable "ServerName_IASENGINE" {}
variable "Instance_Type_IASENGINE" {}
variable "Volume_Size_IASENGINE" {}

############# Honeypot #############
variable "BTCP_Token_HONEYPOT" {}
variable "BTCP_IDR_Honeypot_IP" {}
variable "aws_ami_honeypot" {}
variable "Instance_Type_HONEYPOT" {}
variable "Volume_Size_HONEYPOT" {}
variable "BTCP_IDR_ServerName_Honeypot" {}

############# InsightVM #############
variable "BTCP_IVM_IP1" {}
variable "BTCP_IVM_IP2" {}
variable "ivm_target_group_arn" {}
variable "IVM_Console_Port" {}
variable "Instance_Type_VRM_Console" {}
variable "Volume_Size_VRM_Console" {}
variable "ServerName_IVM" {}
variable "BTCP_VRM_License_Key" {}
variable "MachineType" {}

############# Metasploit #############
variable "BTCP_MS_IP" {}
variable "Instance_Type_METASPLOIT" {}
variable "Volume_Size_METASPLOIT" {}
variable "ServerName_METASPLOIT" {}

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
variable "NLB_Private_IP" {}


############# ADDS01 #############
variable "BTCP_IDR_ADDS01" {}
variable "SiteName_AD" {}

############# Target #############
variable "BTCP_IDR_Target_Win_IPs" {}
variable "BTCP_IDR_ServerName_Target_Win" {}
variable "BTCP_IDR_Target_Win" {}
variable "BTCP_IDR_ServerName_ADDS01" {}
variable "BTCP_IDR_ServerName_Target_Ubu" {}
