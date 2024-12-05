#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                       Bootcamp Module VRM Main Definitions                                                                          #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Console Ubu                                                                                                                                                                                                                                            
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_Console_Ubu" {
  source                = "./compute/Console_Ubu"
  count                 = var.BTCP_VRM_Console_Ubu == true ? 1 : 0
  ami                   = var.ami_ubuntu_22
  internal_sg           = var.internal_sg_id
  internal_subnets      = var.private_subnet_ivm_id
  instance_type         = var.Instance_Type_VRM_Console
  vol_size              = var.Volume_Size_VRM_Console
  key_name              = var.Key_Name_Internal
  Tenant                = var.Tenant
  JIRA_ID               = var.JIRA_ID
  Instance_IP1          = var.BTCP_VRM_Console_Ubu_IP1
  Instance_IP2          = var.BTCP_VRM_Console_Ubu_IP2
  Instance_Profile_Name = var.Instance_Profile_Name
  IVM_Console_Port      = var.IVM_Console_Port
  Owner_Email           = var.Owner_Email
  ServerName            = var.BTCP_VRM_ServerName_Console_Ubu
  TimeZoneID            = var.TimeZoneID
  Lab_Number            = var.Lab_Number
  user_data = templatefile("Template_File/linux_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      ServerName                 = var.BTCP_VRM_ServerName_Console_Ubu
      AD_IP                      = "Null"
      TimeZoneID                 = var.TimeZoneID
      Bucket_Name                = var.Bucket_Name
      ZoneName                   = var.ZoneName
      DomainName                 = var.DomainName
      Token                      = var.Token
      AdminUser                  = var.AdminUser
      AdminPD_ID                 = var.AdminPD_ID
      idr_service_account        = var.idr_service_account
      idr_service_account_pwd_ID = var.idr_service_account_pwd_ID
      AdminSafeModePassword_ID   = var.AdminSafeModePassword_ID
      VR_Agent_File              = var.VR_Agent_File
      Instance_IP1               = var.BTCP_VRM_Console_Ubu_IP1
      Instance_IP2               = var.BTCP_VRM_Console_Ubu_IP2
      Instance_Mask              = var.BTCP_VRM_Mask
      Instance_GW                = var.BTCP_VRM_GW
      Instance_AWSGW             = var.BTCP_VRM_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Coll_IP                    = "Null"
      Orch_IP                    = "Null"
      SiteName                   = var.BTCP_VRM_SiteName
      SiteName_RODC              = "Null"
      RODCServerName             = "Null"
      RODC_IP                    = "Null"
      ScriptList                 = var.ScriptList_VRM_CONSOLE_UBU
      User_Account               = "Null"
      Keyboard_Layout            = var.Keyboard_Layout
      MachineType                = var.MachineType
      Tenant                     = var.Tenant
      VRM_License_Key            = var.VRM_License_Key
      Dummy_Data                 = var.BTCP_VRM_Dummy_Data
      Routing_Type               = var.Routing_Type
      Deployment_Mode            = var.Deployment_Mode
      Scenario                   = ["0"]
      PhishingName               = var.PhishingName


  })
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Console Win                                                                                                                                                                                                                                            
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_Console_Win" {
  source               = "./compute/Console_Win"
  count                = var.BTCP_VRM_Console_Win == true ? 1 : 0
  ami                  = var.ami_windows_2k22
  internal_sg          = var.internal_sg_id
  internal_subnets     = var.private_subnet_ivm_id
  instance_type        = var.Instance_Type_VRM_Console
  vol_size             = var.Volume_Size_VRM_Console
  key_name             = var.Key_Name_Internal
  Tenant               = var.Tenant
  iam_instance_profile = var.Instance_Profile_Name
  Instance_IP          = var.BTCP_VRM_Console_Win_IP1
  JIRA_ID              = var.JIRA_ID
  ServerName           = var.BTCP_VRM_ServerName_Console_Win
  Owner_Email          = var.Owner_Email
  Lab_Number           = var.Lab_Number
  user_data = templatefile("Template_File/windows_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      Password_ID                = var.Password_ID
      ServerName                 = var.BTCP_VRM_ServerName_Console_Win
      AD_IP                      = "Null"
      TimeZoneID                 = var.TimeZoneID
      ZoneName                   = var.ZoneName
      DomainName                 = var.DomainName
      ForestMode                 = var.ForestMode
      ZoneName                   = var.ZoneName
      DomainMode                 = var.DomainMode
      DatabasePath               = var.DatabasePath
      SYSVOLPath                 = var.SYSVOLPath
      LogPath                    = var.LogPath
      AdminSafeModePassword_ID   = var.AdminSafeModePassword_ID
      Token                      = var.Token
      AdminUser                  = var.AdminUser
      AdminPD_ID                 = var.AdminPD_ID
      idr_service_account        = var.idr_service_account
      idr_service_account_pwd_ID = var.idr_service_account_pwd_ID
      Coll_IP                    = "Null"
      Bucket_Name                = var.Bucket_Name
      VR_Agent_File              = var.VR_Agent_File
      Instance_IP1               = var.BTCP_VRM_Console_Win_IP1
      Instance_IP2               = var.BTCP_VRM_Console_Win_IP2
      Instance_Mask              = var.BTCP_VRM_Mask
      Instance_GW                = var.BTCP_VRM_GW
      Instance_AWSGW             = var.BTCP_VRM_AWSGW
      Agent_Type                 = var.Agent_Type
      SiteName                   = var.BTCP_VRM_SiteName
      SiteName_RODC              = "Null"
      RODCServerName             = "Null"
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Orch_IP                    = "Null"
      RODC_IP                    = "Null"
      ScriptList                 = var.ScriptList_VRM_CONSOLE_WIN
      User_Account               = "Null"
      Keyboard_Layout            = var.Keyboard_Layout
      Routing_Type               = var.Routing_Type
      Deployment_Mode            = var.Deployment_Mode
      User_Lists                 = var.User_Lists
      VRM_License_Key            = var.VRM_License_Key
      Scenario                   = ["0"]
      PhishingName               = var.PhishingName

  })
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Scan Engine Windows                                                                                                                                                                                                                                          
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_Scan_engine_Win" {
  count                = var.BTCP_VRM_Scan_engine_Win == true ? 1 : 0
  source               = "./compute/Engine_Win"
  ami                  = var.ami_windows_2k22
  internal_sg          = var.internal_sg_id
  internal_subnets     = var.private_subnet_ivm_id
  instance_type        = var.Instance_Type_VRM_ENGINE
  vol_size             = var.Volume_Size_VRM_ENGINE
  key_name             = var.Key_Name_Internal
  Tenant               = var.Tenant
  iam_instance_profile = var.Instance_Profile_Name
  Instance_IP          = var.BTCP_VRM_Engine_Win_IP
  JIRA_ID              = var.JIRA_ID
  ServerName           = var.BTCP_VRM_ServerName_Scan_engine_Win
  Owner_Email          = var.Owner_Email
  Lab_Number           = var.Lab_Number
  user_data = templatefile("Template_File/windows_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      Password_ID                = var.Password_ID
      ServerName                 = var.BTCP_VRM_ServerName_Scan_engine_Win
      AD_IP                      = "Null"
      TimeZoneID                 = var.TimeZoneID
      ZoneName                   = var.ZoneName
      DomainName                 = var.DomainName
      ForestMode                 = var.ForestMode
      ZoneName                   = var.ZoneName
      DomainMode                 = var.DomainMode
      DatabasePath               = var.DatabasePath
      SYSVOLPath                 = var.SYSVOLPath
      LogPath                    = var.LogPath
      AdminSafeModePassword_ID   = var.AdminSafeModePassword_ID
      Token                      = var.Token
      AdminUser                  = var.AdminUser
      AdminPD_ID                 = var.AdminPD_ID
      idr_service_account        = var.idr_service_account
      idr_service_account_pwd_ID = var.idr_service_account_pwd_ID
      Coll_IP                    = "Null"
      Bucket_Name                = var.Bucket_Name
      VR_Agent_File              = var.VR_Agent_File
      Instance_IP1               = var.BTCP_VRM_Engine_Win_IP
      Instance_IP2               = "Null"
      Instance_Mask              = var.BTCP_VRM_Mask
      Instance_GW                = var.BTCP_VRM_GW
      Instance_AWSGW             = var.BTCP_VRM_AWSGW
      Agent_Type                 = var.Agent_Type
      SiteName                   = var.BTCP_VRM_SiteName
      SiteName_RODC              = "Null"
      RODCServerName             = "Null"
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Orch_IP                    = "Null"
      RODC_IP                    = "Null"
      ScriptList                 = var.ScriptList_VRM_ENGINE_WIN
      User_Account               = "Null"
      Keyboard_Layout            = var.Keyboard_Layout
      Routing_Type               = var.Routing_Type
      Deployment_Mode            = var.Deployment_Mode
      User_Lists                 = var.User_Lists
      VRM_License_Key            = var.VRM_License_Key
      Scenario                   = ["0"]
      PhishingName               = var.PhishingName

  })
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Scan Engine ubu                                                                                                                                                                                                                                          
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_Scan_engine_Ubu" {
  count                = var.BTCP_VRM_Scan_engine_Ubu == true ? 1 : 0
  ami                  = var.ami_ubuntu_22
  source               = "./compute/Engine_Ubu"
  internal_sg          = var.internal_sg_id
  internal_subnets     = var.private_subnet_ivm_id
  Instance_IP          = var.BTCP_VRM_Engine_Ubu_IP
  instance_type        = var.Instance_Type_VRM_ENGINE
  vol_size             = var.Volume_Size_VRM_ENGINE
  key_name             = var.Key_Name_Internal
  Tenant               = var.Tenant
  iam_instance_profile = var.Instance_Profile_Name
  ServerName           = var.BTCP_VRM_ServerName_Scan_Engine_Ubu
  JIRA_ID              = var.JIRA_ID
  User_Account         = "Null"
  Owner_Email          = var.Owner_Email
  Lab_Number           = var.Lab_Number
  user_data = templatefile("Template_File/linux_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      ServerName                 = var.BTCP_VRM_ServerName_Scan_Engine_Ubu
      AD_IP                      = "Null"
      TimeZoneID                 = var.TimeZoneID
      Bucket_Name                = var.Bucket_Name
      ZoneName                   = var.ZoneName
      DomainName                 = var.DomainName
      Token                      = var.Token
      AdminUser                  = var.AdminUser
      AdminPD_ID                 = var.AdminPD_ID
      idr_service_account        = var.idr_service_account
      idr_service_account_pwd_ID = var.idr_service_account_pwd_ID
      VR_Agent_File              = var.VR_Agent_File
      Instance_IP1               = var.BTCP_VRM_Engine_Ubu_IP
      Instance_IP2               = "Null"
      Instance_Mask              = var.BTCP_VRM_Mask
      Instance_GW                = var.BTCP_VRM_GW
      Instance_AWSGW             = var.BTCP_VRM_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Coll_IP                    = "Null"
      Orch_IP                    = "Null"
      SiteName                   = var.BTCP_VRM_SiteName
      SiteName_RODC              = "Null"
      RODCServerName             = "Null"
      RODC_IP                    = "Null"
      ScriptList                 = var.ScriptList_VRM_ENGINE_UBU
      User_Account               = "Null"
      Keyboard_Layout            = var.Keyboard_Layout
      MachineType                = var.MachineType
      Tenant                     = var.Tenant
      VRM_License_Key            = var.VRM_License_Key
      Dummy_Data                 = var.BTCP_VRM_Dummy_Data
      Routing_Type               = var.Routing_Type
      Deployment_Mode            = var.Deployment_Mode
      Scenario                   = ["0"]
      PhishingName               = var.PhishingName


  })
}


#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Target ubu                                                                                                                                                                                                                                          
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_Target_Ubu" {
  for_each             = var.BTCP_VRM_Target_Ubu ? { for pair in var.BTCP_VRM_Target_Ubu_IPs : split(":", pair)[1] => split(":", pair)[0] } : {}
  ami                  = var.ami_ubuntu_22
  source               = "./compute/Target_Ubu"
  internal_sg          = var.internal_sg_id
  internal_subnets     = var.private_subnet_ivm_id
  Instance_IP          = each.key
  instance_type        = var.Instance_Type_LINUX
  vol_size             = var.Volume_Size_LINUX
  key_name             = var.Key_Name_Internal
  Tenant               = var.Tenant
  iam_instance_profile = var.Instance_Profile_Name
  ServerName           = each.value.Name
  JIRA_ID              = var.JIRA_ID
  Owner_Email          = var.Owner_Email
  Lab_Number           = var.Lab_Number
  User_Account         = each.value.Name
  user_data = templatefile("Template_File/linux_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      ServerName                 = each.value.Name
      AD_IP                      = "Null"
      TimeZoneID                 = var.TimeZoneID
      Bucket_Name                = var.Bucket_Name
      ZoneName                   = var.ZoneName
      DomainName                 = var.DomainName
      Token                      = var.Token
      AdminUser                  = var.AdminUser
      AdminPD_ID                 = var.AdminPD_ID
      idr_service_account        = var.idr_service_account
      idr_service_account_pwd_ID = var.idr_service_account_pwd_ID
      VR_Agent_File              = var.VR_Agent_File
      Instance_IP1               = each.key
      Instance_IP2               = "Null"
      Instance_Mask              = var.BTCP_VRM_Mask
      Instance_GW                = var.BTCP_VRM_GW
      Instance_AWSGW             = var.BTCP_VRM_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Coll_IP                    = "Null"
      Orch_IP                    = "Null"
      SiteName                   = var.BTCP_VRM_SiteName
      SiteName_RODC              = "Null"
      RODCServerName             = "Null"
      RODC_IP                    = "Null"
      ScriptList                 = var.ScriptList_VRM_TARGET_UBU
      User_Account               = "${each.value.Name}"
      Keyboard_Layout            = var.Keyboard_Layout
      MachineType                = var.MachineType
      Tenant                     = var.Tenant
      VRM_License_Key            = var.VRM_License_Key
      Dummy_Data                 = var.BTCP_VRM_Dummy_Data
      Routing_Type               = var.Routing_Type
      Deployment_Mode            = var.Deployment_Mode
      Scenario                   = each.value.Scenario
      PhishingName               = var.PhishingName



  })
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Target Win                                                                                                                                                                                                                                          
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_Target_Win" {
  for_each             = var.BTCP_VRM_Target_Win ? { for pair in var.BTCP_VRM_Target_Win_IPs : split(":", pair)[1] => split(":", pair)[0] } : {}
  ami                  = var.ami_windows_11
  source               = "./compute/Target_Win"
  internal_sg          = var.internal_sg_id
  internal_subnets     = var.private_subnet_ivm_id
  Instance_IP          = each.key
  instance_type        = var.Instance_Type_WIN11
  vol_size             = var.Volume_Size_WIN11
  key_name             = var.Key_Name_Internal
  Tenant               = var.Tenant
  iam_instance_profile = var.Instance_Profile_Name
  ServerName           = each.value.Name
  JIRA_ID              = var.JIRA_ID
  Owner_Email          = var.Owner_Email
  Lab_Number           = var.Lab_Number
  User_Account         = each.value.Name
  user_data = templatefile("Template_File/windows_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      Password_ID                = var.Password_ID
      ServerName                 = each.value.Name
      AD_IP                      = "Null"
      TimeZoneID                 = var.TimeZoneID
      ZoneName                   = var.ZoneName
      DomainName                 = var.DomainName
      ForestMode                 = var.ForestMode
      ZoneName                   = var.ZoneName
      DomainMode                 = var.DomainMode
      DatabasePath               = var.DatabasePath
      SYSVOLPath                 = var.SYSVOLPath
      LogPath                    = var.LogPath
      AdminSafeModePassword_ID   = var.AdminSafeModePassword_ID
      Token                      = var.Token
      AdminUser                  = var.AdminUser
      AdminPD_ID                 = var.AdminPD_ID
      idr_service_account        = var.idr_service_account
      idr_service_account_pwd_ID = var.idr_service_account_pwd_ID
      Coll_IP                    = "Null"
      Bucket_Name                = var.Bucket_Name
      VR_Agent_File              = var.VR_Agent_File
      Instance_IP1               = each.key
      Instance_IP2               = "Null"
      Instance_Mask              = var.BTCP_VRM_Mask
      Instance_GW                = var.BTCP_VRM_GW
      Instance_AWSGW             = var.BTCP_VRM_AWSGW
      Agent_Type                 = var.Agent_Type
      SiteName                   = var.BTCP_VRM_SiteName
      SiteName_RODC              = "Null"
      RODCServerName             = "Null"
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Orch_IP                    = "Null"
      RODC_IP                    = "Null"
      ScriptList                 = var.ScriptList_VRM_TARGET_WIN
      User_Account               = "${each.value.Name}"
      Keyboard_Layout            = var.Keyboard_Layout
      Routing_Type               = var.Routing_Type
      Deployment_Mode            = var.Deployment_Mode
      User_Lists                 = var.User_Lists
      VRM_License_Key            = var.VRM_License_Key
      Scenario                   = each.value.Scenario
      PhishingName               = var.PhishingName
  })
}

############# Console Ubu  #############
resource "aws_ec2_traffic_mirror_session" "session_console_ubu" {
  count                    = var.BTCP_IDR_NSensor == true && var.BTCP_VRM_Console_Ubu == true ? 1 : 0
  description              = "Traffic mirror session - VRM_Subnet - CONSOLE UBU"
  network_interface_id     = one(module.compute_Console_Ubu[*].private_ip_eni_id)
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = var.traffic_mirror_filter_id[0]
  traffic_mirror_target_id = var.traffic_mirror_target_id[0]
  tags = {
    "Name"        = "${var.Tenant}-VRMSubnet-Session-CONSOLEUBU"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Console Win  #############
resource "aws_ec2_traffic_mirror_session" "session_console_win" {
  count                    = var.BTCP_IDR_NSensor == true && var.BTCP_VRM_Console_Win == true ? 1 : 0
  description              = "Traffic mirror session - VRM_Subnet - CONSOLE WIN"
  network_interface_id     = one(module.compute_Console_Win[*].private_ip_eni_id)
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = var.traffic_mirror_filter_id[0]
  traffic_mirror_target_id = var.traffic_mirror_target_id[0]
  tags = {
    "Name"        = "${var.Tenant}-VRMSubnet-Session-CONSOLEWIN"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Engine Win  #############
resource "aws_ec2_traffic_mirror_session" "session_engine_win" {
  count                    = var.BTCP_IDR_NSensor == true && var.BTCP_VRM_Scan_engine_Win == true ? 1 : 0
  description              = "Traffic mirror session - VRM_Subnet - Engine WIN"
  network_interface_id     = one(module.compute_Scan_engine_Win[*].private_ip_eni_id)
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = var.traffic_mirror_filter_id[0]
  traffic_mirror_target_id = var.traffic_mirror_target_id[0]
  tags = {
    "Name"        = "${var.Tenant}-VRMSubnet-Session-ENGINEWIN"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Engine Ubu  #############
resource "aws_ec2_traffic_mirror_session" "session_engine_ubu" {
  count                    = var.BTCP_IDR_NSensor == true && var.BTCP_VRM_Scan_engine_Ubu == true ? 1 : 0
  description              = "Traffic mirror session - VRM_Subnet - Engine UBU"
  network_interface_id     = one(module.compute_Scan_engine_Ubu[*].private_ip_eni_id)
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = var.traffic_mirror_filter_id[0]
  traffic_mirror_target_id = var.traffic_mirror_target_id[0]
  tags = {
    "Name"        = "${var.Tenant}-VRMSubnet-Session-ENGINEUBU"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

# ############# Windows 11 #############
resource "aws_ec2_traffic_mirror_session" "session_win11" {
  for_each                 = var.BTCP_IDR_NSensor == true && var.BTCP_VRM_Target_Win == true ? { for pair in var.BTCP_VRM_Target_Win_IPs : split(":", pair)[1] => split(":", pair)[0] } : {}
  description              = "Traffic mirror session - VRM_Subnet - Win11 - ${each.value.Name}"
  network_interface_id     = module.compute_Target_Win[each.key].private_ip_eni_id
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = var.traffic_mirror_filter_id[0]
  traffic_mirror_target_id = var.traffic_mirror_target_id[0]
  tags = {
    "Name"        = "${var.Tenant}-Session-VRMSubnet-Win11-${each.value.Name}"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Linux #############
resource "aws_ec2_traffic_mirror_session" "session_linux" {
  for_each                 = var.BTCP_IDR_NSensor == true && var.BTCP_VRM_Target_Ubu == true ? { for pair in var.BTCP_VRM_Target_Ubu_IPs : split(":", pair)[1] => split(":", pair)[0] } : {}
  description              = "Traffic mirror session - VRM_Subnet - LINUX - ${each.value.Name}"
  network_interface_id     = module.compute_Target_Ubu[each.key].private_ip_eni_id
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = var.traffic_mirror_filter_id[0]
  traffic_mirror_target_id = var.traffic_mirror_target_id[0]
  tags = {
    "Name"        = "${var.Tenant}-Session-VRMSubnet-Linux-${each.value.Name}"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

