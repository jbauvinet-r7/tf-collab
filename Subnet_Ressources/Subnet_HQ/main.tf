#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                       Subnet HQ Variables Definitions                                                                         #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module RODC                                                                                                                                                                                                                                                              
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_RODC" {
  count                = var.RODC_Module == true ? 1 : 0
  source               = "./compute/RODC"
  ami                  = var.ami_windows_2k22
  internal_sg          = var.internal_hq_sg
  internal_subnets     = var.internal_hq_subnets
  instance_type        = var.Instance_Type_AD
  vol_size             = var.Volume_Size_AD
  key_name             = var.Key_Name_Internal
  Tenant               = var.Tenant
  iam_instance_profile = var.Instance_Profile_Name
  Instance_IP          = var.RODC_IP
  JIRA_ID              = var.JIRA_ID
  ServerName           = var.ServerName_RODC
  Owner_Email          = var.Owner_Email
  user_data = templatefile("Template_File/windows_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      Password_ID                = var.Password_ID
      ServerName                 = var.ServerName_RODC
      AD_IP                      = var.AD_IP
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
      Coll_IP                    = var.Coll_IP
      Bucket_Name                = var.Bucket_Name
      VR_Agent_File              = var.VR_Agent_File
      SiteName                   = var.SiteName_RODC
      SiteName_RODC              = var.SiteName_RODC
      RODCServerName             = var.ServerName_RODC
      Instance_IP1               = var.AD_IP
      Instance_IP2               = "Null"
      Instance_Mask              = var.HQ_Mask
      Instance_GW                = var.HQ_GW
      Instance_AWSGW             = var.HQ_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Orch_IP                    = var.Orch_IP
      RODC_IP                    = var.RODC_IP
      ScriptList                 = var.ScriptList_RODC
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
#  Module 2K19                                                                                                                                                                                                                                                              
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_2K19" {
  count                = var.Win2K19_Module == true ? 1 : 0
  source               = "./compute/2K19"
  ami                  = var.ami_windows_2k19
  internal_sg          = var.internal_hq_sg
  internal_subnets     = var.internal_hq_subnets
  instance_type        = var.Instance_Type_AD
  vol_size             = var.Volume_Size_AD
  key_name             = var.Key_Name_Internal
  Tenant               = var.Tenant
  iam_instance_profile = var.Instance_Profile_Name
  Instance_IP          = var.win2K19_ip
  JIRA_ID              = var.JIRA_ID
  ServerName           = var.ServerName_2K19
  Owner_Email          = var.Owner_Email
  user_data = templatefile("Template_File/windows_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      Password_ID                = var.Password_ID
      ServerName                 = var.ServerName_2K19
      AD_IP                      = var.AD_IP
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
      Coll_IP                    = var.Coll_IP
      Bucket_Name                = var.Bucket_Name
      VR_Agent_File              = var.VR_Agent_File
      Instance_IP1               = var.win2K19_ip
      Instance_IP2               = "Null"
      Instance_Mask              = var.HQ_Mask
      Instance_GW                = var.HQ_GW
      Instance_AWSGW             = var.HQ_AWSGW
      Agent_Type                 = var.Agent_Type
      SiteName                   = var.SiteName_HQ
      SiteName_RODC              = var.SiteName_RODC
      RODCServerName             = var.ServerName_RODC
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Orch_IP                    = var.Orch_IP
      RODC_IP                    = var.RODC_IP
      ScriptList                 = var.ScriptList_2K19
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
#  Module 2K22                                                                                                                                                                                                                                                              
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_2K22" {
  count                = var.Win2K22_Module == true ? 1 : 0
  source               = "./compute/2K22"
  ami                  = var.ami_windows_2k22
  internal_sg          = var.internal_hq_sg
  internal_subnets     = var.internal_hq_subnets
  instance_type        = var.Instance_Type_AD
  vol_size             = var.Volume_Size_AD
  key_name             = var.Key_Name_Internal
  Tenant               = var.Tenant
  iam_instance_profile = var.Instance_Profile_Name
  Instance_IP          = var.win2K22_ip
  JIRA_ID              = var.JIRA_ID
  ServerName           = var.ServerName_2K22
  Owner_Email          = var.Owner_Email
  user_data = templatefile("Template_File/windows_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      Password_ID                = var.Password_ID
      ServerName                 = var.ServerName_2K22
      AD_IP                      = var.AD_IP
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
      Coll_IP                    = var.Coll_IP
      Bucket_Name                = var.Bucket_Name
      VR_Agent_File              = var.VR_Agent_File
      Instance_IP1               = var.win2K22_ip
      Instance_IP2               = "Null"
      Instance_Mask              = var.HQ_Mask
      Instance_GW                = var.HQ_GW
      Instance_AWSGW             = var.HQ_AWSGW
      Agent_Type                 = var.Agent_Type
      SiteName                   = var.SiteName_HQ
      SiteName_RODC              = var.SiteName_RODC
      RODCServerName             = var.ServerName_RODC
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Orch_IP                    = var.Orch_IP
      RODC_IP                    = var.RODC_IP
      ScriptList                 = var.ScriptList_2K22
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
#  Module FileServer                                                                                                                                                                                                                                                              
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_FILESERVER" {
  count                = var.FileServer_Module == true ? 1 : 0
  source               = "./compute/FILESERVER"
  ami                  = var.ami_windows_2k22
  internal_sg          = var.internal_hq_sg
  internal_subnets     = var.internal_hq_subnets
  instance_type        = var.Instance_Type_AD
  vol_size             = var.Volume_Size_AD
  key_name             = var.Key_Name_Internal
  Tenant               = var.Tenant
  iam_instance_profile = var.Instance_Profile_Name
  Instance_IP          = var.fileserver_ip
  JIRA_ID              = var.JIRA_ID
  ServerName           = var.ServerName_FILESERVER
  Owner_Email          = var.Owner_Email
  user_data = templatefile("Template_File/windows_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      Password_ID                = var.Password_ID
      ServerName                 = var.ServerName_FILESERVER
      AD_IP                      = var.AD_IP
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
      Coll_IP                    = var.Coll_IP
      Bucket_Name                = var.Bucket_Name
      VR_Agent_File              = var.VR_Agent_File
      Instance_IP1               = var.fileserver_ip
      Instance_IP2               = "Null"
      Instance_Mask              = var.HQ_Mask
      Instance_GW                = var.HQ_GW
      Instance_AWSGW             = var.HQ_AWSGW
      Agent_Type                 = var.Agent_Type
      SiteName                   = var.SiteName_HQ
      SiteName_RODC              = var.SiteName_RODC
      RODCServerName             = var.ServerName_RODC
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Orch_IP                    = var.Orch_IP
      RODC_IP                    = var.RODC_IP
      ScriptList                 = var.ScriptList_FILESERVER
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
#  Module WebServer                                                                                                                                                                                                                                                              
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_WEBSERVER" {
  count                = var.WebServer_Module == true ? 1 : 0
  source               = "./compute/WEBSERVER"
  ami                  = var.ami_windows_2k22
  internal_sg          = var.internal_hq_sg
  internal_subnets     = var.internal_hq_subnets
  instance_type        = var.Instance_Type_AD
  vol_size             = var.Volume_Size_AD
  key_name             = var.Key_Name_Internal
  Tenant               = var.Tenant
  iam_instance_profile = var.Instance_Profile_Name
  Instance_IP          = var.webserver_ip
  JIRA_ID              = var.JIRA_ID
  ServerName           = var.ServerName_WEBSERVER
  Owner_Email          = var.Owner_Email
  user_data = templatefile("Template_File/windows_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      Password_ID                = var.Password_ID
      ServerName                 = var.ServerName_WEBSERVER
      AD_IP                      = var.AD_IP
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
      Coll_IP                    = var.Coll_IP
      Bucket_Name                = var.Bucket_Name
      VR_Agent_File              = var.VR_Agent_File
      Instance_IP1               = var.webserver_ip
      Instance_IP2               = "Null"
      Instance_Mask              = var.HQ_Mask
      Instance_GW                = var.HQ_GW
      Instance_AWSGW             = var.HQ_AWSGW
      Agent_Type                 = var.Agent_Type
      SiteName                   = var.SiteName_HQ
      SiteName_RODC              = var.SiteName_RODC
      RODCServerName             = var.ServerName_RODC
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Orch_IP                    = var.Orch_IP
      RODC_IP                    = var.RODC_IP
      ScriptList                 = var.ScriptList_WEBSERVER
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
#  Module Windows 10                                                                                                                                                                                                                                                              
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_WIN10" {
  for_each             = var.Win10_Module ? tomap(var.User_List_WIN10) : {}
  source               = "./compute/WIN10"
  ami                  = var.ami_windows_10
  internal_sg          = var.internal_hq_sg
  internal_subnets     = var.internal_hq_subnets
  instance_count       = var.Instance_Count_WIN10
  instance_type        = var.Instance_Type_WIN10
  vol_size             = var.Volume_Size_WIN10
  Instance_IP          = "10.0.20.${floor(120 + each.key)}"
  key_name             = var.Key_Name_Internal
  Tenant               = var.Tenant
  iam_instance_profile = var.Instance_Profile_Name
  JIRA_ID              = var.JIRA_ID
  User_Account         = each.value.Name
  Owner_Email          = var.Owner_Email
  user_data = templatefile("Template_File/windows_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      Password_ID                = var.Password_ID
      ServerName                 = "${var.ServerName_WIN10}-${each.value.Name}"
      AD_IP                      = var.AD_IP
      TimeZoneID                 = var.TimeZoneID
      DomainName                 = var.DomainName
      User_Account               = each.value.Name
      Instance_IP1               = "10.0.20.${floor(120 + each.key)}"
      Instance_IP2               = "Null"
      Instance_Mask              = var.HQ_Mask
      Instance_GW                = var.HQ_GW
      Instance_AWSGW             = var.HQ_AWSGW
      Agent_Type                 = var.Agent_Type
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
      Coll_IP                    = var.Coll_IP
      Bucket_Name                = var.Bucket_Name
      VR_Agent_File              = var.VR_Agent_File
      SiteName                   = var.SiteName_HQ
      SiteName_RODC              = var.SiteName_RODC
      RODCServerName             = var.ServerName_RODC
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Orch_IP                    = var.Orch_IP
      RODC_IP                    = var.RODC_IP
      ScriptList                 = var.ScriptList_WIN10
      User_Account               = each.value.Name
      Keyboard_Layout            = var.Keyboard_Layout
      Routing_Type               = var.Routing_Type
      Deployment_Mode            = var.Deployment_Mode
      User_Lists                 = var.User_Lists
      VRM_License_Key            = var.VRM_License_Key
      Scenario                   = each.value.Scenario
      PhishingName               = var.PhishingName

  })
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Windows 11                                                                                                                                                                                                                                                              
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_WIN11" {
  for_each             = var.Win11_Module ? tomap(var.User_List_WIN11) : {}
  source               = "./compute/WIN11"
  ami                  = var.ami_windows_11
  internal_sg          = var.internal_hq_sg
  internal_subnets     = var.internal_hq_subnets
  instance_count       = var.Instance_Count_WIN11
  instance_type        = var.Instance_Type_WIN11
  Instance_IP          = "10.0.20.${floor(150 + each.key)}"
  vol_size             = var.Volume_Size_WIN11
  key_name             = var.Key_Name_Internal
  Tenant               = var.Tenant
  iam_instance_profile = var.Instance_Profile_Name
  JIRA_ID              = var.JIRA_ID
  User_Account         = each.value.Name
  Owner_Email          = var.Owner_Email
  user_data = templatefile("Template_File/windows_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      Password_ID                = var.Password_ID
      ServerName                 = "${var.ServerName_WIN11}-${each.value.Name}"
      AD_IP                      = var.AD_IP
      TimeZoneID                 = var.TimeZoneID
      DomainName                 = var.DomainName
      AdminUser                  = var.idr_service_account
      AdminPD_ID                 = var.AdminPD_ID
      AdminSafeModePassword_ID   = var.AdminSafeModePassword_ID
      Token                      = var.Token
      Bucket_Name                = var.Bucket_Name
      VR_Agent_File              = var.VR_Agent_File
      Instance_IP1               = "10.0.20.${floor(150 + each.key)}"
      Instance_IP2               = "Null"
      Instance_Mask              = var.HQ_Mask
      Instance_GW                = var.HQ_GW
      Instance_AWSGW             = var.HQ_AWSGW
      Agent_Type                 = var.Agent_Type
      ForestMode                 = var.ForestMode
      ZoneName                   = var.ZoneName
      DomainMode                 = var.DomainMode
      DatabasePath               = var.DatabasePath
      SYSVOLPath                 = var.SYSVOLPath
      LogPath                    = var.LogPath
      idr_service_account        = var.idr_service_account
      idr_service_account_pwd_ID = var.idr_service_account_pwd_ID
      Coll_IP                    = var.Coll_IP
      SiteName                   = var.SiteName_HQ
      SiteName_RODC              = var.SiteName_RODC
      RODCServerName             = var.ServerName_RODC
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Orch_IP                    = var.Orch_IP
      RODC_IP                    = var.RODC_IP
      ScriptList                 = var.ScriptList_WIN11
      User_Account               = each.value.Name
      Keyboard_Layout            = var.Keyboard_Layout
      Routing_Type               = var.Routing_Type
      Deployment_Mode            = var.Deployment_Mode
      User_Lists                 = var.User_Lists
      VRM_License_Key            = var.VRM_License_Key
      Scenario                   = each.value.Scenario
      PhishingName               = var.PhishingName

  })
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Linux                                                                                                                                                                                                                                                              
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_LINUX" {
  for_each             = var.Ubu_Module ? tomap(var.User_List_LINUX) : {}
  ami                  = var.ami_ubuntu_20
  source               = "./compute/LINUX"
  internal_sg          = var.internal_hq_sg
  internal_subnets     = var.internal_hq_subnets
  instance_count       = var.Instance_Count_LINUX
  Instance_IP          = "10.0.20.${floor(170 + each.key)}"
  instance_type        = var.Instance_Type_LINUX
  vol_size             = var.Volume_Size_LINUX
  key_name             = var.Key_Name_Internal
  Tenant               = var.Tenant
  iam_instance_profile = var.Instance_Profile_Name
  JIRA_ID              = var.JIRA_ID
  User_Account         = each.value.Name
  Owner_Email          = var.Owner_Email
  user_data = templatefile("Template_File/linux_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      ServerName                 = "${var.ServerName_LINUX}-${each.value.Name}"
      AD_IP                      = var.AD_IP
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
      Instance_IP1               = "10.0.20.${floor(170 + each.key)}"
      Instance_IP2               = "Null"
      Instance_Mask              = var.HQ_Mask
      Instance_GW                = var.HQ_GW
      Instance_AWSGW             = var.HQ_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Coll_IP                    = var.Coll_IP
      Orch_IP                    = var.Orch_IP
      SiteName                   = var.SiteName_HQ
      SiteName_RODC              = var.SiteName_RODC
      RODCServerName             = "Null"
      RODC_IP                    = "Null"
      ScriptList                 = var.ScriptList_LINUX
      User_Account               = each.value.Name
      Keyboard_Layout            = var.Keyboard_Layout
      MachineType                = "Null"
      Tenant                     = var.Tenant
      VRM_License_Key            = "Null"
      Dummy_Data                 = "Null"
      Routing_Type               = var.Routing_Type
      Deployment_Mode            = var.Deployment_Mode
      Scenario                   = each.value.Scenario
      PhishingName               = var.PhishingName

  })
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Traffic Mirroring - Sessions                                                                                                                                                                                                                                     
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# RODC #############
resource "aws_ec2_traffic_mirror_session" "session_hq_rodc" {
  count                    = var.NetworkSensor_Module == true && var.RODC_Module == true ? 1 : 0
  description              = "Traffic mirror session - HQ - RODC"
  network_interface_id     = one(module.compute_RODC[*].private_ip_eni_id)
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = var.traffic_mirror_filter_id[0]
  traffic_mirror_target_id = var.traffic_mirror_target_id[0]
  tags = {
    "Name"        = "${var.Tenant}-Session-HQ-RODC"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# 2K19 #############
resource "aws_ec2_traffic_mirror_session" "session_hq_2k19" {
  count                    = var.NetworkSensor_Module == true && var.Win2K19_Module == true ? 1 : 0
  description              = "Traffic mirror session - HQ - 2K19"
  network_interface_id     = one(module.compute_2K19[*].private_ip_eni_id)
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = var.traffic_mirror_filter_id[0]
  traffic_mirror_target_id = var.traffic_mirror_target_id[0]
  tags = {
    "Name"        = "${var.Tenant}-Session-HQ-2K19"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# 2K22 #############
resource "aws_ec2_traffic_mirror_session" "session_hq_2k22" {
  count                    = var.NetworkSensor_Module == true && var.Win2K22_Module == true ? 1 : 0
  description              = "Traffic mirror session - HQ - 2K22"
  network_interface_id     = one(module.compute_2K22[*].private_ip_eni_id)
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = var.traffic_mirror_filter_id[0]
  traffic_mirror_target_id = var.traffic_mirror_target_id[0]
  tags = {
    "Name"        = "${var.Tenant}-Session-HQ-2K22"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# FileServer #############
resource "aws_ec2_traffic_mirror_session" "session_hq_fileserver" {
  count                    = var.NetworkSensor_Module == true && var.FileServer_Module == true ? 1 : 0
  description              = "Traffic mirror session - HQ - FILESERVER"
  network_interface_id     = one(module.compute_FILESERVER[*].private_ip_eni_id)
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = var.traffic_mirror_filter_id[0]
  traffic_mirror_target_id = var.traffic_mirror_target_id[0]
  tags = {
    "Name"        = "${var.Tenant}-Session-HQ-FILESERVER"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# WebServer #############
resource "aws_ec2_traffic_mirror_session" "session_hq_webserver" {
  count                    = var.NetworkSensor_Module == true && var.WebServer_Module == true ? 1 : 0
  description              = "Traffic mirror session - HQ - WEBSERVER"
  network_interface_id     = one(module.compute_WEBSERVER[*].private_ip_eni_id)
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = var.traffic_mirror_filter_id[0]
  traffic_mirror_target_id = var.traffic_mirror_target_id[0]
  tags = {
    "Name"        = "${var.Tenant}-Session-HQ-WEBSERVER"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Windows 10 #############
# resource "aws_ec2_traffic_mirror_session" "session-IT-Win10" {
#   for_each                 = var.NetworkSensor_Module == true ? tomap(var.User_List_WIN10) : {} # Conditional for_each
#   description               = "Traffic mirror session - IT - Win10 - ${each.key}"
#   network_interface_id      = module.compute_WIN10[each.key].private_ip_eni_id
#   packet_length             = 8500
#   session_number            = 1
#   traffic_mirror_filter_id  = var.traffic_mirror_filter_id[0]
#   traffic_mirror_target_id  = var.traffic_mirror_target_id[0]
# tags = {
#  "Name"                  = "${var.Tenant}-Session-HQ-Win10-${each.value.Name}"
#   "Tenant"                = "${var.Tenant}"
#   "Owner_Email"           = "${var.Owner_Email}"
#   "JIRA_ID"               = "${var.JIRA_ID}"
# }
# }

############# Windows 11 #############
resource "aws_ec2_traffic_mirror_session" "session_hq_win11" {
  for_each                 = var.NetworkSensor_Module == true && var.Win11_Module == true ? tomap(var.User_List_WIN11) : {} # Conditional for_each
  description              = "Traffic mirror session - HQ - Win11 - ${each.value.Name}"
  network_interface_id     = module.compute_WIN11[each.key].private_ip_eni_id
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = var.traffic_mirror_filter_id[0]
  traffic_mirror_target_id = var.traffic_mirror_target_id[0]
  tags = {
    "Name"        = "${var.Tenant}-Session-HQ-Win11-${each.value.Name}"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Linux #############
resource "aws_ec2_traffic_mirror_session" "session_hq_linux" {
  for_each                 = var.NetworkSensor_Module == true && var.Ubu_Module == true ? tomap(var.User_List_LINUX) : {} # Conditional for_each
  description              = "Traffic mirror session - HQ - LINUX - ${each.value.Name}"
  network_interface_id     = module.compute_LINUX[each.key].private_ip_eni_id
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = var.traffic_mirror_filter_id[0]
  traffic_mirror_target_id = var.traffic_mirror_target_id[0]
  tags = {
    "Name"        = "${var.Tenant}-Session-HQ-Linux-${each.value.Name}"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}