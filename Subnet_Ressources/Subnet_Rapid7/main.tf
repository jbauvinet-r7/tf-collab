#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                       Rapid7 Subnet Main Definitions                                                                          #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Log Generator                                                                                                                                                                                                                                            
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_LOGGEN" {
  source                = "./compute/LOGGEN"
  count                 = var.InsightIDR_Dummy_Data == true ? 1 : 0
  ami                   = var.ami_windows_2k22
  internal_sg           = var.sg_rapid7_id
  internal_subnets      = var.subnet_rapid7_id
  instance_type         = var.Instance_Type_LOGGEN
  vol_size              = var.Volume_Size_LOGGEN
  key_name              = var.Key_Name_Internal
  Tenant                = var.Tenant
  Instance_IP           = var.Loggen_IP
  JIRA_ID               = var.JIRA_ID
  ServerName            = var.ServerName_LOGGEN
  Token                 = var.Token
  TimeZoneID            = var.TimeZoneID
  Instance_Profile_Name = var.Instance_Profile_Name
  Owner_Email           = var.Owner_Email
  user_data = templatefile("Template_File/windows_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      ServerName                 = var.ServerName_LOGGEN
      AD_IP                      = var.AD_IP
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
      Instance_IP1               = var.Loggen_IP
      Instance_IP2               = "Null"
      Instance_Mask              = var.Loggen_Mask
      Instance_GW                = var.Loggen_GW
      Instance_AWSGW             = var.Rapid7_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Coll_IP                    = var.Coll_IP
      Orch_IP                    = var.Orch_IP
      SiteName                   = var.SiteName_R7
      SiteName_RODC              = var.SiteName_RODC
      RODCServerName             = var.ServerName_RODC_HQ
      RODC_IP                    = var.RODC_IP
      ScriptList                 = var.ScriptList_LOGGEN
      User_Account               = "Null"
      Keyboard_Layout            = var.Keyboard_Layout
      MachineType                = var.MachineType
      Tenant                     = var.Tenant
      VRM_License_Key            = var.VRM_License_Key
      Dummy_Data                 = var.InsightVM_Dummy_Data
      Routing_Type               = var.Routing_Type
      Deployment_Mode            = var.Deployment_Mode
      User_Lists                 = var.User_Lists
      VRM_License_Key            = var.VRM_License_Key
      Scenario                   = ["0"]
      PhishingName               = var.PhishingName

  })
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module IAS Engine                                                                                                                                                                                                                                            
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_IASENGINE" {
  source                = "./compute/IASENGINE"
  ami                   = var.ami_windows_2k22
  count                 = var.InsightAppSec_Module == true && var.InsightAppSec_IAS_engine == true ? 1 : 0
  internal_sg           = var.sg_rapid7_id
  internal_subnets      = var.subnet_rapid7_id
  instance_type         = var.Instance_Type_IASENGINE
  vol_size              = var.Volume_Size_IASENGINE
  key_name              = var.Key_Name_Internal
  Tenant                = var.Tenant
  AdminUser             = var.AdminUser
  AdminPD               = var.AdminPD_ID
  Instance_IP           = var.IASEngine_IP
  JIRA_ID               = var.JIRA_ID
  ServerName            = var.ServerName_IASENGINE
  Token                 = var.Token
  TimeZoneID            = var.TimeZoneID
  Instance_Profile_Name = var.Instance_Profile_Name
  Owner_Email           = var.Owner_Email
  user_data = templatefile("Template_File/windows_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      ServerName                 = var.ServerName_IASENGINE
      AD_IP                      = var.AD_IP
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
      Instance_IP1               = var.IASEngine_IP
      Instance_IP2               = "Null"
      Instance_Mask              = var.IASEngine_Mask
      Instance_GW                = var.IASEngine_GW
      Instance_AWSGW             = var.Rapid7_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Coll_IP                    = var.Coll_IP
      Orch_IP                    = var.Orch_IP
      SiteName                   = var.SiteName_R7
      SiteName_RODC              = var.SiteName_RODC
      RODCServerName             = var.ServerName_RODC_HQ
      RODC_IP                    = var.RODC_IP
      ScriptList                 = var.ScriptList_LOGGEN
      User_Account               = "Null"
      Keyboard_Layout            = var.Keyboard_Layout
      MachineType                = var.MachineType
      Tenant                     = var.Tenant
      VRM_License_Key            = var.VRM_License_Key
      Dummy_Data                 = var.InsightVM_Dummy_Data
      Routing_Type               = var.Routing_Type
      Deployment_Mode            = var.Deployment_Mode
      User_Lists                 = var.User_Lists
      VRM_License_Key            = var.VRM_License_Key
      Scenario                   = ["0"]
      PhishingName               = var.PhishingName

  })
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module InsightVM                                                                                                                                                                                                                                            
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_IVM" {
  source                    = "./compute/IVM"
  count                     = var.InsightVM_Module == true ? 1 : 0
  ami                       = var.ami_ubuntu_22
  internal_sg               = var.sg_rapid7_id
  internal_subnets          = var.subnet_rapid7_id
  instance_type             = var.Instance_Type_VRM_Console
  vol_size                  = var.Volume_Size_VRM_Console
  key_name                  = var.Key_Name_Internal
  Tenant                    = var.Tenant
  JIRA_ID                   = var.JIRA_ID
  Instance_IP1              = var.IVM_IP1
  Instance_IP2              = var.IVM_IP2
  Instance_Profile_Name     = var.Instance_Profile_Name
  IVM_Console_Port          = var.IVM_Console_Port
  Owner_Email               = var.Owner_Email
  ServerName                = var.ServerName_IVM
  TimeZoneID                = var.TimeZoneID
  Deployment_Mode           = var.Deployment_Mode
  use_route53_hz            = var.use_route53_hz
  vpc_id                    = var.vpc_id
  aws_lb_alb_ivm_dnsname    = var.aws_lb_alb_ivm_dnsname
  selected_Zone_ID          = var.Zone_ID
  ZoneName                  = var.ZoneName
  aws_lb_alb_ivm_zoneid     = var.aws_lb_alb_ivm_zoneid
  aws_lb_listener_ivm443_id = var.aws_lb_listener_ivm443_id
  HCIVM_Priority            = var.HCIVM_Priority
  user_data = templatefile("Template_File/linux_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      ServerName                 = var.ServerName_IVM
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
      AdminSafeModePassword_ID   = var.AdminSafeModePassword_ID
      VR_Agent_File              = var.VR_Agent_File
      Instance_IP1               = var.IVM_IP1
      Instance_IP2               = var.IVM_IP2
      Instance_Mask              = var.IVM_Mask
      Instance_GW                = var.IVM_GW
      Instance_AWSGW             = var.Rapid7_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Coll_IP                    = var.Coll_IP
      Orch_IP                    = var.Orch_IP
      SiteName                   = var.SiteName_R7
      SiteName_RODC              = var.SiteName_RODC
      RODCServerName             = var.ServerName_RODC_HQ
      RODC_IP                    = var.RODC_IP
      ScriptList                 = var.ScriptList_VRM_CONSOLE_UBU
      User_Account               = "Null"
      Keyboard_Layout            = var.Keyboard_Layout
      MachineType                = var.MachineType
      Tenant                     = var.Tenant
      VRM_License_Key            = var.VRM_License_Key
      Dummy_Data                 = var.InsightVM_Dummy_Data
      Routing_Type               = var.Routing_Type
      Deployment_Mode            = var.Deployment_Mode
      Scenario                   = ["0"]
      PhishingName               = var.PhishingName

  })
}


#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Outpost                                                                                                                                                                                                                                            
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_OUTPOST" {
  source                = "./compute/Outpost"
  count                 = var.SurfaceCommand_Module == true ? 1 : 0
  ami                   = var.ami_ubuntu_22
  internal_sg           = var.sg_rapid7_id
  internal_subnets      = var.subnet_rapid7_id
  instance_type         = var.Instance_Type_OUTPOST
  vol_size              = var.Volume_Size_OUTPOST
  key_name              = var.Key_Name_Internal
  Tenant                = var.Tenant
  JIRA_ID               = var.JIRA_ID
  Instance_IP           = var.Outpost_IP
  Instance_Profile_Name = var.Instance_Profile_Name
  Owner_Email           = var.Owner_Email
  ServerName            = var.ServerName_OUTPOST
  TimeZoneID            = var.TimeZoneID
  user_data = templatefile("Template_File/linux_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      ServerName                 = var.ServerName_OUTPOST
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
      AdminSafeModePassword_ID   = var.AdminSafeModePassword_ID
      VR_Agent_File              = var.VR_Agent_File
      Instance_IP1               = var.Outpost_IP
      Instance_IP2               = ""
      Instance_Mask              = var.IVM_Mask
      Instance_GW                = var.IVM_GW
      Instance_AWSGW             = var.Rapid7_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Coll_IP                    = var.Coll_IP
      Orch_IP                    = var.Orch_IP
      SiteName                   = var.SiteName_R7
      SiteName_RODC              = var.SiteName_RODC
      RODCServerName             = var.ServerName_RODC_HQ
      RODC_IP                    = var.RODC_IP
      ScriptList                 = var.ScriptList_OUTPOST
      User_Account               = "Null"
      Keyboard_Layout            = var.Keyboard_Layout
      MachineType                = var.MachineType
      Tenant                     = var.Tenant
      VRM_License_Key            = var.VRM_License_Key
      Dummy_Data                 = var.InsightVM_Dummy_Data
      Routing_Type               = var.Routing_Type
      Deployment_Mode            = var.Deployment_Mode
      Scenario                   = ["0"]
      PhishingName               = var.PhishingName

  })
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module IVMEngine                                                                                                                                                                                                                                            
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_IVMENGINE" {
  source                = "./compute/IVMENGINE"
  count                 = var.IVMEngine_Module == true ? 1 : 0
  ami                   = var.ami_ubuntu_22
  internal_sg           = var.sg_rapid7_id
  internal_subnets      = var.subnet_rapid7_id
  instance_type         = var.Instance_Type_IVMEngine
  vol_size              = var.Volume_Size_IVMEngine
  key_name              = var.Key_Name_Internal
  Tenant                = var.Tenant
  JIRA_ID               = var.JIRA_ID
  Instance_IP           = var.IVMEngine_IP
  Instance_Profile_Name = var.Instance_Profile_Name
  Owner_Email           = var.Owner_Email
  ServerName            = var.ServerName_IVMEngine
  TimeZoneID            = var.TimeZoneID
  user_data = templatefile("Template_File/linux_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      ServerName                 = var.ServerName_IVMEngine
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
      AdminSafeModePassword_ID   = var.AdminSafeModePassword_ID
      VR_Agent_File              = var.VR_Agent_File
      Instance_IP1               = var.IVMEngine_IP
      Instance_IP2               = ""
      Instance_Mask              = var.IVM_Mask
      Instance_GW                = var.IVM_GW
      Instance_AWSGW             = var.Rapid7_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Coll_IP                    = var.Coll_IP
      Orch_IP                    = var.Orch_IP
      SiteName                   = var.SiteName_R7
      SiteName_RODC              = var.SiteName_RODC
      RODCServerName             = var.ServerName_RODC_HQ
      RODC_IP                    = var.RODC_IP
      ScriptList                 = var.ScriptList_IVMENGINE
      User_Account               = "Null"
      Keyboard_Layout            = var.Keyboard_Layout
      MachineType                = var.MachineType
      Tenant                     = var.Tenant
      VRM_License_Key            = var.VRM_License_Key
      Dummy_Data                 = var.InsightVM_Dummy_Data
      Routing_Type               = var.Routing_Type
      Deployment_Mode            = var.Deployment_Mode
      Scenario                   = ["0"]
      PhishingName               = var.PhishingName

  })
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Orchestrator                                                                                                                                                                                                                                        
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_ORCHESTRATOR" {
  source                = "./compute/ORCHESTRATOR"
  count                 = var.InsightConnect_Module == true ? 1 : 0
  ami                   = var.ami_ubuntu_22
  internal_sg           = var.sg_rapid7_id
  internal_subnets      = var.subnet_rapid7_id
  instance_type         = var.Instance_Type_ORCHESTRATOR
  vol_size              = var.Volume_Size_ORCHESTRATOR
  key_name              = var.Key_Name_Internal
  Instance_IP           = var.Orch_IP
  Tenant                = var.Tenant
  Instance_Profile_Name = var.Instance_Profile_Name
  JIRA_ID               = var.JIRA_ID
  ServerName            = var.ServerName_ORCHESTRATOR
  Owner_Email           = var.Owner_Email
  TimeZoneID            = var.TimeZoneID
  user_data = templatefile("Template_File/linux_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      ServerName                 = var.ServerName_ORCHESTRATOR
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
      Instance_IP1               = var.Orch_IP
      Instance_IP2               = "Null"
      Instance_Mask              = var.Orch_Mask
      Instance_GW                = var.Orch_GW
      Instance_AWSGW             = var.Rapid7_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Coll_IP                    = var.Coll_IP
      Orch_IP                    = var.Orch_IP
      SiteName                   = var.SiteName_R7
      SiteName_RODC              = var.SiteName_RODC
      RODCServerName             = var.ServerName_RODC_HQ
      RODC_IP                    = var.RODC_IP
      ScriptList                 = var.ScriptList_ORCHESTRATOR
      User_Account               = "Null"
      Keyboard_Layout            = var.Keyboard_Layout
      MachineType                = var.MachineType
      Tenant                     = var.Tenant
      VRM_License_Key            = var.VRM_License_Key
      Dummy_Data                 = var.InsightVM_Dummy_Data
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
  count                 = var.NetworkSensor_Module == true ? 1 : 0
  ami                   = var.ami_ubuntu_22
  internal_sg           = var.sg_rapid7_id
  internal_subnets      = var.subnet_rapid7_id
  instance_type         = var.Instance_Type_NSENSOR
  vol_size              = var.Volume_Size_NSENSOR
  key_name              = var.Key_Name_Internal
  Instance_IP1          = var.NSensor_IP1
  Instance_IP2          = var.NSensor_IP2
  Tenant                = var.Tenant
  Instance_Profile_Name = var.Instance_Profile_Name
  JIRA_ID               = var.JIRA_ID
  ServerName            = var.ServerName_NSENSOR
  Owner_Email           = var.Owner_Email
  TimeZoneID            = var.TimeZoneID
  user_data = templatefile("Template_File/linux_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      ServerName                 = var.ServerName_NSENSOR
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
      Instance_IP1               = var.NSensor_IP1
      Instance_IP2               = var.NSensor_IP2
      Instance_Mask              = var.NSensor_Mask
      Instance_GW                = var.NSensor_GW
      Instance_AWSGW             = var.Rapid7_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Coll_IP                    = var.Coll_IP
      Orch_IP                    = var.Orch_IP
      SiteName                   = var.SiteName_R7
      SiteName_RODC              = var.SiteName_RODC
      RODCServerName             = var.ServerName_RODC_HQ
      RODC_IP                    = var.RODC_IP
      ScriptList                 = var.ScriptList_NSENSOR
      User_Account               = "Null"
      Keyboard_Layout            = var.Keyboard_Layout
      MachineType                = var.MachineType
      Tenant                     = var.Tenant
      VRM_License_Key            = var.VRM_License_Key
      Dummy_Data                 = var.InsightVM_Dummy_Data
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
  count            = var.Honeypot_Module == true ? 1 : 0
  ami              = var.aws_ami_honeypot
  internal_sg      = var.sg_rapid7_id
  internal_subnets = var.subnet_rapid7_id
  instance_type    = var.Instance_Type_HONEYPOT
  vol_size         = var.Volume_Size_HONEYPOT
  key_name         = var.Key_Name_Internal
  Instance_IP      = var.Honeypot_IP
  Tenant           = var.Tenant
  JIRA_ID          = var.JIRA_ID
  ServerName       = var.ServerName_HONEYPOT
  Owner_Email      = var.Owner_Email
  user_data        = "TOKEN = ${var.Token_HONEYPOT}"
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Collector                                                                                                                                                                                                                                        
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_COLLECTOR" {
  source                = "./compute/COLLECTOR_WIN"
  ami                   = var.ami_windows_2k22
  internal_sg           = var.sg_rapid7_id
  internal_subnets      = var.subnet_rapid7_id
  instance_type         = var.Instance_Type_COLLECTOR
  vol_size              = var.Volume_Size_COLLECTOR
  key_name              = var.Key_Name_Internal
  Tenant                = var.Tenant
  Instance_Profile_Name = var.Instance_Profile_Name
  Instance_IP           = var.Coll_IP
  JIRA_ID               = var.JIRA_ID
  ServerName            = var.ServerName_COLLECTOR
  Owner_Email           = var.Owner_Email
  user_data = templatefile("Template_File/windows_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      Password_ID                = var.Password_ID
      ServerName                 = var.ServerName_COLLECTOR
      AD_IP                      = var.AD_IP
      TimeZoneID                 = var.TimeZoneID
      DatabasePath               = "Null"
      ZoneName                   = var.ZoneName
      DomainName                 = var.DomainName
      ForestMode                 = "Null"
      DomainMode                 = "Null"
      SYSVOLPath                 = "Null"
      LogPath                    = "Null"
      AdminSafeModePassword_ID   = var.AdminSafeModePassword_ID
      Token                      = var.Token
      AdminUser                  = var.AdminUser
      AdminPD_ID                 = var.AdminPD_ID
      idr_service_account        = var.idr_service_account
      idr_service_account_pwd_ID = var.idr_service_account_pwd_ID
      Coll_IP                    = var.Coll_IP
      Bucket_Name                = var.Bucket_Name
      VR_Agent_File              = var.VR_Agent_File
      SiteName                   = var.SiteName_R7
      SiteName_RODC              = var.SiteName_RODC
      RODCServerName             = var.ServerName_RODC_HQ
      Instance_IP1               = var.Coll_IP
      Instance_IP2               = "Null"
      Instance_Mask              = var.Coll_Mask
      Instance_GW                = var.Coll_GW
      Instance_AWSGW             = var.Rapid7_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Orch_IP                    = var.Orch_IP
      RODC_IP                    = var.RODC_IP
      ScriptList                 = var.ScriptList_IDR_WINCOLLECTOR
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
#  Module Metasploit                                                                                                                                                                                                                                        
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_METASPLOIT" {
  source                        = "./compute/METASPLOIT"
  count                         = var.Metasploit_Module == true ? 1 : 0
  ami                           = var.ami_ubuntu_22
  internal_sg                   = var.sg_rapid7_id
  internal_subnets              = var.subnet_rapid7_id
  instance_type                 = var.Instance_Type_METASPLOIT
  vol_size                      = var.Volume_Size_METASPLOIT
  key_name                      = var.Key_Name_Internal
  Tenant                        = var.Tenant
  Instance_Profile_Name         = var.Instance_Profile_Name
  Instance_IP                   = var.Metasploit_IP
  JIRA_ID                       = var.JIRA_ID
  ServerName                    = var.ServerName_METASPLOIT
  Owner_Email                   = var.Owner_Email
  Zone_ID                       = var.Zone_ID
  Metasploit_Priority           = var.Metasploit_Priority
  vpc_id                        = var.vpc_id
  use_route53_hz                = var.use_route53_hz
  aws_lb_listener_webapps443_id = var.aws_lb_listener_webapps443_id
  Metasploit_Module             = var.Metasploit_Module
  aws_lb_alb_webapps_zoneid     = var.aws_lb_alb_webapps_zoneid
  aws_lb_alb_webapps_dnsname    = var.aws_lb_alb_webapps_dnsname
  ZoneName                      = var.ZoneName
  user_data = templatefile("Template_File/linux_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      ServerName                 = var.ServerName_METASPLOIT
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
      Instance_IP1               = var.Metasploit_IP
      Instance_IP2               = "Null"
      Instance_Mask              = var.Metasploit_Mask
      Instance_GW                = var.Metasploit_GW
      Instance_AWSGW             = var.Rapid7_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Coll_IP                    = var.Coll_IP
      Orch_IP                    = var.Orch_IP
      SiteName                   = var.SiteName_R7
      SiteName_RODC              = var.SiteName_RODC
      RODCServerName             = var.ServerName_RODC_HQ
      RODC_IP                    = var.RODC_IP
      ScriptList                 = var.ScriptList_METASPLOIT
      User_Account               = "Null"
      Keyboard_Layout            = var.Keyboard_Layout
      MachineType                = var.MachineType
      Tenant                     = var.Tenant
      VRM_License_Key            = var.VRM_License_Key
      Dummy_Data                 = var.InsightVM_Dummy_Data
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
  count            = var.NetworkSensor_Module == true ? 1 : 0
  AWS_Region       = var.AWS_Region
  Tenant           = var.Tenant
  JIRA_ID          = var.JIRA_ID
  traffic_nic_id   = one(module.compute_NSENSOR[*].traffic_nic_id)
  traffic_instance = one(module.compute_NSENSOR[*].traffic_instance)
  vpc_id           = var.vpc_id
  subnet_rapid7_id = var.subnet_rapid7_id
  sg_rapid7_id     = var.sg_rapid7_id
  traffic_nic_ip   = one(module.compute_NSENSOR[*].traffic_nic_ip)
  sg_fw_id         = var.sg_fw_id
  sg_fw_public_id  = var.sg_fw_public_id
  sg_dmz_id        = var.sg_dmz_id
  sg_hq_id         = var.sg_hq_id
  sg_it_id         = var.sg_it_id
  sg_jumpbox_id    = var.sg_jumpbox_id
  Owner_Email      = var.Owner_Email
  Deployment_Mode  = var.Deployment_Mode
  Routing_Type     = var.Routing_Type
  NLB_Private_IP   = var.NLB_Private_IP
}


#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Traffic Mirroring - Sessions                                                                                                                                                                                                                                     
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Collector #############
resource "aws_ec2_traffic_mirror_session" "session_collector" {
  count                    = var.NetworkSensor_Module == true && var.InsightIDR_Module == true ? 1 : 0
  description              = "Traffic mirror session - Rapid7 - COLLECTOR"
  network_interface_id     = one(module.compute_COLLECTOR[*].private_ip_eni_id)
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = one(module.traffic_mirroring[*].traffic_mirror_filter_id)[0]
  traffic_mirror_target_id = one(module.traffic_mirroring[*].traffic_mirror_target_id)[0]
  tags = {
    "Name"        = "${var.Tenant}-Rapid7-Session-COLLECTOR"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Honeypot #############
resource "aws_ec2_traffic_mirror_session" "session_honeypot" {
  count                    = var.NetworkSensor_Module == true && var.InsightIDR_Module == true ? 1 : 0
  description              = "Traffic mirror session - Rapid7 - HONEYPOT"
  network_interface_id     = one(module.compute_HONEYPOT[*].private_ip_eni_id)
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = one(module.traffic_mirroring[*].traffic_mirror_filter_id)[0]
  traffic_mirror_target_id = one(module.traffic_mirroring[*].traffic_mirror_target_id)[0]
  tags = {
    "Name"        = "${var.Tenant}-Rapid7-Session-HONEYPOT"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Log Generator #############
# resource "aws_ec2_traffic_mirror_session" "session-LOGGEN" {
#   count                     = var.NetworkSensor_Module == true  || var.InsightIDR_Dummy_Data == true  ? 1 : 0
#   description               = "Traffic mirror session - Rapid7 - LOGGEN"
#   network_interface_id      = one(module.compute_LOGGEN[*].private_ip_eni_id)
#   packet_length             = 8500
#   session_number            = 1
#   traffic_mirror_filter_id  = one(module.traffic_mirroring[*].traffic_mirror_filter_id)
#   traffic_mirror_target_id  = one(module.traffic_mirroring[*].traffic_mirror_target_id)
#   tags = {
#       "Name"                = "${var.Tenant}-Rapid7-Session-LOGGEN"
#       "Tenant"              = "${var.Tenant}"
#       "Owner_Email"         = "${var.Owner_Email}"
#       "JIRA_ID"             = "${var.JIRA_ID}"
#   }
# }

############# Orchestrator #############
resource "aws_ec2_traffic_mirror_session" "session_orchestrator" {
  count                    = var.NetworkSensor_Module == true && var.InsightConnect_Module == true ? 1 : 0
  description              = "Traffic mirror session - Rapid7 - ORCHESTRATOR"
  network_interface_id     = one(module.compute_ORCHESTRATOR[*].private_ip_eni_id)
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = one(module.traffic_mirroring[*].traffic_mirror_filter_id)[0]
  traffic_mirror_target_id = one(module.traffic_mirroring[*].traffic_mirror_target_id)[0]
  tags = {
    "Name"        = "${var.Tenant}-Rapid7-Session-ORCHESTRATOR"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# FW Ext #############
resource "aws_ec2_traffic_mirror_session" "session_fw_external" {
  count                    = var.NetworkSensor_Module == true && var.Routing_Type == "pSense" ? 1 : 0
  description              = "Traffic mirror session - FW - External"
  network_interface_id     = var.eni_dmz_public_id
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = one(module.traffic_mirroring[*].traffic_mirror_filter_id)[0]
  traffic_mirror_target_id = one(module.traffic_mirroring[*].traffic_mirror_target_id)[0]
  tags = {
    "Name"        = "${var.Tenant}-Session-FW-External"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# FW Int #############
resource "aws_ec2_traffic_mirror_session" "session_fw_internal" {
  count                    = var.NetworkSensor_Module == true && var.Routing_Type == "pSense" ? 1 : 0
  description              = "Traffic mirror session - FW - Internal"
  network_interface_id     = var.eni_fw_int_id
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = one(module.traffic_mirroring[*].traffic_mirror_filter_id)[0]
  traffic_mirror_target_id = one(module.traffic_mirroring[*].traffic_mirror_target_id)[0]
  tags = {
    "Name"        = "${var.Tenant}-Session-FW-Internal"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# InsightVM #############
resource "aws_ec2_traffic_mirror_session" "session_insightvm" {
  count                    = var.NetworkSensor_Module == true && var.InsightVM_Module == true ? 1 : 0
  description              = "Traffic mirror session - Rapid7 - InsightVM"
  network_interface_id     = one(module.compute_IVM[*].private_ip_eni_id)
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = one(module.traffic_mirroring[*].traffic_mirror_filter_id)[0]
  traffic_mirror_target_id = one(module.traffic_mirroring[*].traffic_mirror_target_id)[0]
  tags = {
    "Name"        = "${var.Tenant}-Rapid7-Session-InsightVM"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
