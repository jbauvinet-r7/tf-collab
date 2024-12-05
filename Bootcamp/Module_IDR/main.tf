#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                       IDR_Subnet Subnet Main Definitions                                                                          #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Log Generator                                                                                                                                                                                                                                            
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_LOGGEN" {
  source                = "./compute/LOGGEN"
  count                 = var.BTCP_IDR_Loggen == true ? 1 : 0
  ami                   = var.ami_windows_2k22
  internal_sg           = var.internal_sg_id
  internal_subnets      = var.private_subnet_idr_id
  instance_type         = var.Instance_Type_LOGGEN
  vol_size              = var.Volume_Size_LOGGEN
  key_name              = var.Key_Name_Internal
  Tenant                = var.Tenant
  Instance_IP           = var.BTCP_IDR_Loggen_IP
  JIRA_ID               = var.JIRA_ID
  ServerName            = var.BTCP_IDR_ServerName_Loggen
  Token                 = var.Token
  TimeZoneID            = var.TimeZoneID
  Instance_Profile_Name = var.Instance_Profile_Name
  Owner_Email           = var.Owner_Email
  Lab_Number            = var.Lab_Number
  user_data = templatefile("Template_File/windows_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      Password_ID                = var.Password_ID
      ServerName                 = var.BTCP_IDR_ServerName_Loggen
      AD_IP                      = var.BTCP_IDR_DC_IP
      TimeZoneID                 = var.TimeZoneID
      ZoneName                   = var.ZoneName
      DomainName                 = var.DomainName
      ForestMode                 = "Null"
      DomainMode                 = "Null"
      DatabasePath               = "Null"
      SYSVOLPath                 = "Null"
      LogPath                    = "Null"
      AdminSafeModePassword_ID   = var.AdminSafeModePassword_ID
      Token                      = var.Token
      AdminUser                  = var.AdminUser
      AdminPD_ID                 = var.AdminPD_ID
      idr_service_account        = var.idr_service_account
      idr_service_account_pwd_ID = var.idr_service_account_pwd_ID
      Coll_IP                    = var.BTCP_IDR_Coll_IP_Ubu
      Bucket_Name                = var.Bucket_Name
      VR_Agent_File              = var.VR_Agent_File
      Instance_IP1               = var.BTCP_IDR_Loggen_IP
      Instance_IP2               = "Null"
      Instance_Mask              = var.BTCP_IDR_Mask
      Instance_GW                = var.BTCP_IDR_GW
      Instance_AWSGW             = var.BTCP_IDR_AWSGW
      Agent_Type                 = var.Agent_Type
      SiteName                   = var.BTCP_IDR_SiteName
      SiteName_RODC              = "Null"
      RODCServerName             = "Null"
      SEOPS_VR_Install           = "Null"
      Orch_IP                    = var.BTCP_IDR_Orch_IP
      RODC_IP                    = "Null"
      ScriptList                 = var.ScriptList_LOGGEN
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
#  Module Orchestrator                                                                                                                                                                                                                                        
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_ORCHESTRATOR" {
  source                = "./compute/ORCHESTRATOR"
  count                 = var.BTCP_IDR_Orchestrator == true ? 1 : 0
  ami                   = var.ami_ubuntu_22
  internal_sg           = var.internal_sg_id
  internal_subnets      = var.private_subnet_idr_id
  instance_type         = var.Instance_Type_ORCHESTRATOR
  vol_size              = var.Volume_Size_ORCHESTRATOR
  key_name              = var.Key_Name_Internal
  Instance_IP           = var.BTCP_IDR_Orch_IP
  Tenant                = var.Tenant
  Instance_Profile_Name = var.Instance_Profile_Name
  JIRA_ID               = var.JIRA_ID
  ServerName            = var.BTCP_IDR_ServerName_Orch
  Owner_Email           = var.Owner_Email
  TimeZoneID            = var.TimeZoneID
  Lab_Number            = var.Lab_Number
  user_data = templatefile("Template_File/linux_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      ServerName                 = var.BTCP_IDR_ServerName_Orch
      AD_IP                      = var.BTCP_IDR_DC_IP
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
      Instance_IP1               = var.BTCP_IDR_Orch_IP
      Instance_IP2               = "Null"
      Instance_Mask              = var.BTCP_IDR_Mask
      Instance_GW                = var.BTCP_IDR_GW
      Instance_AWSGW             = var.BTCP_IDR_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = "Null"
      Coll_IP                    = var.BTCP_IDR_Coll_IP_Ubu
      Orch_IP                    = var.BTCP_IDR_Orch_IP
      SiteName                   = var.BTCP_IDR_SiteName
      SiteName_RODC              = "Null"
      RODCServerName             = "Null"
      RODC_IP                    = "Null"
      ScriptList                 = var.ScriptList_ORCHESTRATOR
      User_Account               = "Null"
      Keyboard_Layout            = var.Keyboard_Layout
      MachineType                = "Null"
      Tenant                     = var.Tenant
      VRM_License_Key            = "Null"
      Dummy_Data                 = "Null"
      Routing_Type               = var.Routing_Type
      Deployment_Mode            = var.Deployment_Mode
      Scenario                   = ["0"]
      PhishingName               = var.PhishingName

  })
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Network Sensor                                                                                                                                                                                                                                        
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_NSENSOR" {
  source                = "./compute/NSENSOR"
  count                 = var.BTCP_IDR_NSensor == true ? 1 : 0
  ami                   = var.ami_ubuntu_22
  internal_sg           = var.internal_sg_id
  internal_subnets      = var.private_subnet_idr_id
  instance_type         = var.Instance_Type_NSENSOR
  vol_size              = var.Volume_Size_NSENSOR
  key_name              = var.Key_Name_Internal
  Instance_IP1          = var.BTCP_IDR_NSensor_IP1
  Instance_IP2          = var.BTCP_IDR_NSensor_IP2
  Tenant                = var.Tenant
  Instance_Profile_Name = var.Instance_Profile_Name
  JIRA_ID               = var.JIRA_ID
  ServerName            = var.BTCP_IDR_ServerName_NSensor
  Owner_Email           = var.Owner_Email
  TimeZoneID            = var.TimeZoneID
  Lab_Number            = var.Lab_Number
  user_data = templatefile("Template_File/linux_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      ServerName                 = var.BTCP_IDR_ServerName_NSensor
      AD_IP                      = var.BTCP_IDR_DC_IP
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
      Instance_IP1               = var.BTCP_IDR_NSensor_IP1
      Instance_IP2               = var.BTCP_IDR_NSensor_IP2
      Instance_Mask              = var.BTCP_IDR_Mask
      Instance_GW                = var.BTCP_IDR_GW
      Instance_AWSGW             = var.BTCP_IDR_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = "Null"
      Coll_IP                    = var.BTCP_IDR_Coll_IP_Ubu
      Orch_IP                    = var.BTCP_IDR_Orch_IP
      SiteName                   = var.BTCP_IDR_SiteName
      SiteName_RODC              = "Null"
      RODCServerName             = "Null"
      RODC_IP                    = "Null"
      ScriptList                 = var.ScriptList_NSENSOR
      User_Account               = "Null"
      Keyboard_Layout            = var.Keyboard_Layout
      MachineType                = "Null"
      Tenant                     = var.Tenant
      VRM_License_Key            = "Null"
      Dummy_Data                 = "Null"
      Routing_Type               = var.Routing_Type
      Deployment_Mode            = var.Deployment_Mode
      Scenario                   = ["0"]
      PhishingName               = var.PhishingName

  })
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Honeypot                                                                                                                                                                                                                                        
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_HONEYPOT" {
  source           = "./compute/HONEYPOT"
  count            = var.BTCP_IDR_Honeypot == true ? 1 : 0
  ami              = var.aws_ami_honeypot
  internal_sg      = var.internal_sg_id
  internal_subnets = var.private_subnet_idr_id
  instance_type    = var.Instance_Type_HONEYPOT
  vol_size         = var.Volume_Size_HONEYPOT
  key_name         = var.Key_Name_Internal
  Instance_IP      = var.BTCP_IDR_Honeypot_IP
  Tenant           = var.Tenant
  JIRA_ID          = var.JIRA_ID
  ServerName       = var.BTCP_IDR_ServerName_Honeypot
  Lab_Number       = var.Lab_Number
  Owner_Email      = var.Owner_Email
  user_data        = "TOKEN = ${var.Token_HONEYPOT}"
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Collector Win                                                                                                                                                                                                                                            
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_COLLECTOR_WIN" {
  source                = "./compute/COLLECTORWIN"
  count                 = var.BTCP_IDR_Collector_Win == true ? 1 : 0
  ami                   = var.ami_windows_2k22
  internal_sg           = var.internal_sg_id
  internal_subnets      = var.private_subnet_idr_id
  instance_type         = var.Instance_Type_COLLECTOR
  vol_size              = var.Volume_Size_COLLECTOR
  key_name              = var.Key_Name_Internal
  Tenant                = var.Tenant
  Instance_IP           = var.BTCP_IDR_Coll_IP_Win
  JIRA_ID               = var.JIRA_ID
  ServerName            = var.BTCP_IDR_ServerName_Coll_Win
  Token                 = var.Token
  TimeZoneID            = var.TimeZoneID
  Instance_Profile_Name = var.Instance_Profile_Name
  Owner_Email           = var.Owner_Email
  Lab_Number            = var.Lab_Number
  user_data = templatefile("Template_File/windows_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      ServerName                 = var.BTCP_IDR_ServerName_Coll_Win
      AD_IP                      = var.BTCP_IDR_DC_IP
      TimeZoneID                 = var.TimeZoneID
      Bucket_Name                = var.Bucket_Name
      DatabasePath               = "Null"
      ZoneName                   = var.ZoneName
      DomainName                 = var.DomainName
      ForestMode                 = "Null"
      DomainMode                 = "Null"
      SYSVOLPath                 = "Null"
      LogPath                    = "Null"
      Token                      = var.Token
      AdminUser                  = var.AdminUser
      AdminPD_ID                 = var.AdminPD_ID
      idr_service_account        = var.idr_service_account
      idr_service_account_pwd_ID = var.idr_service_account_pwd_ID
      AdminSafeModePassword_ID   = var.AdminSafeModePassword_ID
      VR_Agent_File              = var.VR_Agent_File
      Instance_IP1               = var.BTCP_IDR_Loggen_IP
      Instance_IP2               = "Null"
      Instance_Mask              = var.BTCP_IDR_Mask
      Instance_GW                = var.BTCP_IDR_GW
      Instance_AWSGW             = var.BTCP_IDR_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = "Null"
      Coll_IP                    = var.BTCP_IDR_Coll_IP_Win
      Orch_IP                    = var.BTCP_IDR_Orch_IP
      SiteName                   = var.BTCP_IDR_SiteName
      SiteName_RODC              = "Null"
      RODCServerName             = "Null"
      RODC_IP                    = "Null"
      ScriptList                 = var.ScriptList_IDR_WINCOLLECTOR
      User_Account               = "Null"
      Keyboard_Layout            = var.Keyboard_Layout
      MachineType                = "Null"
      Tenant                     = var.Tenant
      Dummy_Data                 = "Null"
      Routing_Type               = var.Routing_Type
      Deployment_Mode            = var.Deployment_Mode
      User_Lists                 = var.User_Lists
      VRM_License_Key            = "Null"
      Scenario                   = ["0"]
      PhishingName               = var.PhishingName

  })
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Collector Ubu                                                                                                                                                                                                                                       
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_COLLECTOR_UBU" {
  source                = "./compute/COLLECTORUBU"
  count                 = var.BTCP_IDR_Collector_Ubu == true ? 1 : 0
  ami                   = var.ami_ubuntu_22
  internal_sg           = var.internal_sg_id
  internal_subnets      = var.private_subnet_idr_id
  instance_type         = var.Instance_Type_COLLECTOR
  vol_size              = var.Volume_Size_COLLECTOR
  key_name              = var.Key_Name_Internal
  Tenant                = var.Tenant
  Instance_Profile_Name = var.Instance_Profile_Name
  Instance_IP           = var.BTCP_IDR_Coll_IP_Ubu
  JIRA_ID               = var.JIRA_ID
  ServerName            = var.BTCP_IDR_ServerName_Coll_Ubu
  Owner_Email           = var.Owner_Email
  Lab_Number            = var.Lab_Number
  user_data = templatefile("Template_File/linux_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      ServerName                 = var.BTCP_IDR_ServerName_Coll_Ubu
      AD_IP                      = var.BTCP_IDR_DC_IP
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
      Instance_IP1               = var.BTCP_IDR_Coll_IP_Ubu
      Instance_IP2               = "Null"
      Instance_Mask              = var.BTCP_IDR_Mask
      Instance_GW                = var.BTCP_IDR_GW
      Instance_AWSGW             = var.BTCP_IDR_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = "Null"
      Coll_IP                    = var.BTCP_IDR_Coll_IP_Ubu
      Orch_IP                    = var.BTCP_IDR_Orch_IP
      SiteName                   = var.BTCP_IDR_SiteName
      SiteName_RODC              = "Null"
      RODCServerName             = "Null"
      RODC_IP                    = "Null"
      ScriptList                 = var.ScriptList_LINUXCOLLECTOR
      User_Account               = "Null"
      Keyboard_Layout            = var.Keyboard_Layout
      MachineType                = "Null"
      Tenant                     = var.Tenant
      VRM_License_Key            = "Null"
      Dummy_Data                 = "Null"
      Routing_Type               = var.Routing_Type
      Deployment_Mode            = var.Deployment_Mode
      Scenario                   = ["0"]
      PhishingName               = var.PhishingName

  })
}


#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Traffic Mirroring                                                                                                                                                                                                                                       
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "traffic_mirroring" {
  source           = "./traffic_mirroring"
  count            = var.BTCP_IDR_NSensor == true ? 1 : 0
  AWS_Region       = var.AWS_Region
  Tenant           = var.Tenant
  JIRA_ID          = var.JIRA_ID
  traffic_nic_id   = one(module.compute_NSENSOR[*].traffic_nic_id)
  traffic_instance = one(module.compute_NSENSOR[*].traffic_instance)
  vpc_id           = var.vpc_id
  traffic_nic_ip   = one(module.compute_NSENSOR[*].traffic_nic_ip)
  sg_jumpbox_id    = var.sg_jumpbox_id
  Owner_Email      = var.Owner_Email
  Deployment_Mode  = var.Deployment_Mode
  Routing_Type     = var.Routing_Type
  NLB_Private_IP   = var.NLB_Private_IP
  internal_sg_id   = var.internal_sg_id
  Lab_Number       = var.Lab_Number
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Target ubu                                                                                                                                                                                                                                          
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_Target_Ubu" {
  for_each             = var.BTCP_IDR_Target_Ubu ? { for pair in var.BTCP_IDR_Target_Ubu_IPs : split(":", pair)[1] => split(":", pair)[0] } : {}
  ami                  = var.ami_ubuntu_22
  source               = "./compute/Target_Ubu"
  internal_sg          = var.internal_sg_id
  internal_subnets     = var.private_subnet_idr_id
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
      ServerName                 = var.BTCP_IDR_ServerName_Target_Ubu
      AD_IP                      = var.BTCP_IDR_DC_IP
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
      Instance_Mask              = var.BTCP_IDR_Mask
      Instance_GW                = var.BTCP_IDR_GW
      Instance_AWSGW             = var.BTCP_IDR_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = "Null"
      Coll_IP                    = "Null"
      Orch_IP                    = "Null"
      SiteName                   = var.BTCP_IDR_SiteName
      SiteName_RODC              = "Null"
      RODCServerName             = "Null"
      RODC_IP                    = "Null"
      ScriptList                 = var.ScriptList_IDR_TARGET_UBU
      User_Account               = "${each.value.Name}"
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
#  Module Target Win                                                                                                                                                                                                                                          
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_Target_Win" {
  for_each             = var.BTCP_IDR_Target_Win ? { for pair in var.BTCP_IDR_Target_Win_IPs : split(":", pair)[1] => split(":", pair)[0] } : {}
  ami                  = var.ami_windows_11
  source               = "./compute/Target_Win"
  internal_sg          = var.internal_sg_id
  internal_subnets     = var.private_subnet_idr_id
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
      AD_IP                      = var.BTCP_IDR_DC_IP
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
      Instance_Mask              = var.BTCP_IDR_Mask
      Instance_GW                = var.BTCP_IDR_GW
      Instance_AWSGW             = var.BTCP_IDR_AWSGW
      Agent_Type                 = var.Agent_Type
      SiteName                   = var.BTCP_IDR_SiteName
      SiteName_RODC              = "Null"
      RODCServerName             = "Null"
      SEOPS_VR_Install           = "Null"
      Orch_IP                    = "Null"
      RODC_IP                    = "Null"
      ScriptList                 = var.ScriptList_IDR_TARGET_WIN
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

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module ADDS01                                                                                                                                                                                                                                                  
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_ADDS01" {
  count                = var.BTCP_IDR_ADDS01 == true ? 1 : 0
  source               = "./compute/ADDS01"
  ami                  = var.ami_windows_2k22
  internal_sg          = var.internal_sg_id
  internal_subnets     = var.private_subnet_idr_id
  instance_type        = var.Instance_Type_AD
  vol_size             = var.Volume_Size_AD
  key_name             = var.Key_Name_Internal
  Tenant               = var.Tenant
  iam_instance_profile = var.Instance_Profile_Name
  Instance_IP          = var.BTCP_IDR_DC_IP
  JIRA_ID              = var.JIRA_ID
  ServerName           = var.BTCP_IDR_ServerName_ADDS01
  Owner_Email          = var.Owner_Email
  Lab_Number           = var.Lab_Number
  user_data = templatefile("Template_File/windows_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      Password_ID                = var.Password_ID
      ServerName                 = var.BTCP_IDR_ServerName_ADDS01
      AD_IP                      = var.BTCP_IDR_DC_IP
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
      Coll_IP                    = var.BTCP_IDR_Coll_IP_Ubu
      Bucket_Name                = var.Bucket_Name
      VR_Agent_File              = var.VR_Agent_File
      SiteName                   = var.SiteName_AD
      SiteName_RODC              = var.BTCP_IDR_SiteName
      RODCServerName             = "Null"
      Instance_IP1               = var.BTCP_IDR_DC_IP
      Instance_IP2               = "Null"
      Instance_Mask              = var.BTCP_IDR_Mask
      Instance_GW                = var.BTCP_IDR_GW
      Instance_AWSGW             = var.BTCP_IDR_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = "Null"
      Orch_IP                    = var.BTCP_IDR_Orch_IP
      RODC_IP                    = "Null"
      ScriptList                 = var.ScriptList_ADDS01
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
#  Module Traffic Mirroring - Sessions                                                                                                                                                                                                                                     
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Collector Ubu #############
resource "aws_ec2_traffic_mirror_session" "session_collector_ubu" {
  count                    = var.BTCP_IDR_NSensor == true && var.BTCP_IDR_Collector_Ubu == true ? 1 : 0
  description              = "Traffic mirror session - IDR_Subnet - COLLECTOR UBU"
  network_interface_id     = one(module.compute_COLLECTOR_UBU[*].private_ip_eni_id)
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = one(module.traffic_mirroring[*].traffic_mirror_filter_id)[0]
  traffic_mirror_target_id = one(module.traffic_mirroring[*].traffic_mirror_target_id)[0]
  tags = {
    "Name"        = "${var.Tenant}-IDRSubnet-Session-COLLECTORUBU"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Collector Win #############
resource "aws_ec2_traffic_mirror_session" "session_collector_win" {
  count                    = var.BTCP_IDR_NSensor == true && var.BTCP_IDR_Collector_Win == true ? 1 : 0
  description              = "Traffic mirror session - IDR_Subnet - COLLECTOR WIN"
  network_interface_id     = one(module.compute_COLLECTOR_WIN[*].private_ip_eni_id)
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = one(module.traffic_mirroring[*].traffic_mirror_filter_id)[0]
  traffic_mirror_target_id = one(module.traffic_mirroring[*].traffic_mirror_target_id)[0]
  tags = {
    "Name"        = "${var.Tenant}-IDRSubnet-Session-COLLECTORWIN"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Honeypot #############
resource "aws_ec2_traffic_mirror_session" "session_honeypot" {
  count                    = var.BTCP_IDR_NSensor == true && var.BTCP_IDR_Honeypot == true ? 1 : 0
  description              = "Traffic mirror session - IDR_Subnet - HONEYPOT"
  network_interface_id     = one(module.compute_HONEYPOT[*].private_ip_eni_id)
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = one(module.traffic_mirroring[*].traffic_mirror_filter_id)[0]
  traffic_mirror_target_id = one(module.traffic_mirroring[*].traffic_mirror_target_id)[0]
  tags = {
    "Name"        = "${var.Tenant}-IDRSubnet-Session-HONEYPOT"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############ Log Generator #############
resource "aws_ec2_traffic_mirror_session" "session-LOGGEN" {
  count                    = var.BTCP_IDR_NSensor == true || var.BTCP_IDR_Loggen == true ? 1 : 0
  description              = "Traffic mirror session - IDR_Subnet - LOGGEN"
  network_interface_id     = one(module.compute_LOGGEN[*].private_ip_eni_id)
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = one(module.traffic_mirroring[*].traffic_mirror_filter_id)[0]
  traffic_mirror_target_id = one(module.traffic_mirroring[*].traffic_mirror_target_id)[0]
  tags = {
    "Name"        = "${var.Tenant}-IDRSubnet-Session-LOGGEN"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Orchestrator #############
resource "aws_ec2_traffic_mirror_session" "session_orchestrator" {
  count                    = var.BTCP_IDR_NSensor == true && var.BTCP_IDR_Orchestrator == true ? 1 : 0
  description              = "Traffic mirror session - IDR_Subnet - ORCHESTRATOR"
  network_interface_id     = one(module.compute_ORCHESTRATOR[*].private_ip_eni_id)
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = one(module.traffic_mirroring[*].traffic_mirror_filter_id)[0]
  traffic_mirror_target_id = one(module.traffic_mirroring[*].traffic_mirror_target_id)[0]
  tags = {
    "Name"        = "${var.Tenant}-IDRSubnet-Session-ORCHESTRATOR"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# ADDS01 #############
resource "aws_ec2_traffic_mirror_session" "session_adds01" {
  count                    = var.BTCP_IDR_NSensor == true && var.BTCP_IDR_ADDS01 == true ? 1 : 0
  description              = "Traffic mirror session - IDR_Subnet - ADDS01"
  network_interface_id     = one(module.compute_ADDS01[*].private_ip_eni_id)
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = one(module.traffic_mirroring[*].traffic_mirror_filter_id)[0]
  traffic_mirror_target_id = one(module.traffic_mirroring[*].traffic_mirror_target_id)[0]
  tags = {
    "Name"        = "${var.Tenant}-IDRSubnet-Session-ADDS01"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Windows 11 #############
resource "aws_ec2_traffic_mirror_session" "session_win11" {
  for_each                 = var.BTCP_IDR_NSensor == true && var.BTCP_IDR_Target_Win == true ? { for pair in var.BTCP_IDR_Target_Win_IPs : split(":", pair)[1] => split(":", pair)[0] } : {}
  description              = "Traffic mirror session - IDR_Subnet - Win11 - ${each.value.Name}"
  network_interface_id     = module.compute_Target_Win[each.key].private_ip_eni_id
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = one(module.traffic_mirroring[*].traffic_mirror_filter_id)[0]
  traffic_mirror_target_id = one(module.traffic_mirroring[*].traffic_mirror_target_id)[0]
  tags = {
    "Name"        = "${var.Tenant}-Session-IDRSubnet-Win11-${each.value.Name}"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Linux #############
resource "aws_ec2_traffic_mirror_session" "session_linux" {
  for_each                 = var.BTCP_IDR_NSensor == true && var.BTCP_IDR_Target_Ubu == true ? { for pair in var.BTCP_IDR_Target_Ubu_IPs : split(":", pair)[1] => split(":", pair)[0] } : {}
  description              = "Traffic mirror session - IDR_Subnet - LINUX - ${each.value.Name}"
  network_interface_id     = module.compute_Target_Ubu[each.key].private_ip_eni_id
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = one(module.traffic_mirroring[*].traffic_mirror_filter_id)[0]
  traffic_mirror_target_id = one(module.traffic_mirroring[*].traffic_mirror_target_id)[0]
  tags = {
    "Name"        = "${var.Tenant}-Session-IDRSubnet-Linux-${each.value.Name}"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
