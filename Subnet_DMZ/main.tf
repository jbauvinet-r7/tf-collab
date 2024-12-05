#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                             DMZ Subnet Main                                                                                   #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  External ADDS01 Module                                                                                                                                                                                                                                                                        
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_EXTADDS01" {
  count                = var.External_AD_Module == true ? 1 : 0
  source               = "./EXT_ADDS01"
  ami                  = var.ami_windows_2k22
  external_sg          = var.sg_dmz_id
  external_subnets     = var.subnet_dmz_id
  instance_type        = var.Instance_Type_AD
  vol_size             = var.Volume_Size_AD
  key_name             = var.Key_Name_External
  Tenant               = var.Tenant
  iam_instance_profile = var.Instance_Profile_Name
  Instance_IP          = var.ExtAD_IP
  JIRA_ID              = var.JIRA_ID
  ServerName           = var.ServerName_EXTAD
  Owner_Email          = var.Owner_Email
  user_data = templatefile("Template_File/windows_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      Password_ID                = var.Password_ID
      ServerName                 = var.ServerName_EXTAD
      AD_IP                      = var.ExtAD_IP
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
      Coll_IP                    = var.ExtLinuxCollector_IP
      Bucket_Name                = var.Bucket_Name
      VR_Agent_File              = var.VR_Agent_File
      SiteName                   = var.SiteName
      SiteName_RODC              = var.SiteName_EXTRODC
      RODCServerName             = var.ServerName_EXTRODC
      Instance_IP1               = var.ExtAD_IP
      Instance_IP2               = "Null"
      Instance_Mask              = var.Instance_Mask
      Instance_GW                = var.Instance_GW
      Instance_AWSGW             = var.Instance_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Orch_IP                    = var.ExtOrch_IP
      RODC_IP                    = var.ExtRODC_IP
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
#  External Collector Linux Module                                                                                                                                                                                                                                                                        
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_EXTLINUXCOLLECTOR" {
  count                           = var.External_Collector_Linux_Module == true ? 1 : 0
  source                          = "./EXT_COLLECTOR_LINUX"
  ami                             = var.ami_ubuntu_22
  external_sg                     = var.sg_dmz_id
  external_subnets                = var.subnet_dmz_id
  instance_type                   = var.Instance_Type_EXTCOLLECTOR
  vol_size                        = var.vol_size_EXTCOLLECTOR
  key_name                        = var.Key_Name_External
  Tenant                          = var.Tenant
  Instance_Profile_Name           = var.Instance_Profile_Name
  Instance_IP                     = var.ExtLinuxCollector_IP
  JIRA_ID                         = var.JIRA_ID
  vpc_id                          = var.vpc_id
  ServerName                      = var.ServerName_EXTCOLLECTOR
  Owner_Email                     = var.Owner_Email
  External_Collector_Linux_Module = var.External_Collector_Linux_Module
  selected_Zone_ID                = var.selected_Zone_ID
  ZoneName                        = var.ZoneName
  use_route53_hz                  = var.use_route53_hz
  user_data = templatefile("Template_File/linux_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      ServerName                 = var.ServerName_EXTCOLLECTOR
      AD_IP                      = "Null"
      TimeZoneID                 = var.TimeZoneID
      Bucket_Name                = var.Bucket_Name
      ZoneName                   = var.ZoneName
      DomainName                 = var.DomainName
      Token                      = var.Token
      AdminUser                  = var.AdminUser
      AdminPD_ID                 = var.AdminPD_ID
      idr_service_account        = "Null"
      idr_service_account_pwd_ID = "Null"
      VR_Agent_File              = var.VR_Agent_File
      Instance_IP1               = var.ExtLinuxCollector_IP
      Instance_IP2               = "Null"
      Instance_Mask              = var.Instance_Mask
      Instance_GW                = var.Instance_GW
      Instance_AWSGW             = var.Instance_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Coll_IP                    = "Null"
      Orch_IP                    = "Null"
      SiteName                   = var.SiteName
      SiteName_RODC              = var.SiteName_EXTRODC
      RODCServerName             = "Null"
      RODC_IP                    = "Null"
      ScriptList                 = var.ScriptList_LINUXCOLLECTOR
      User_Account               = "Null"
      Keyboard_Layout            = var.Keyboard_Layout
      MachineType                = var.MachineType
      Tenant                     = var.Tenant
      VRM_License_Key            = var.VRM_License_Key
      Dummy_Data                 = var.InsightVM_Dummy_Data_HCIVM
      Routing_Type               = var.Routing_Type
      Deployment_Mode            = var.Deployment_Mode
      Scenario                   = ["0"]
      PhishingName               = var.PhishingName

  })
}


#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  External Collector Windows Module                                                                                                                                                                                                                                                                        
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_EXTWINCOLLECTOR" {
  count                             = var.External_Collector_Windows_Module == true ? 1 : 0
  source                            = "./EXT_COLLECTOR_WIN"
  ami                               = var.ami_windows_2k22
  external_sg                       = var.sg_dmz_id
  external_subnets                  = var.subnet_dmz_id
  instance_type                     = var.Instance_Type_EXTCOLLECTOR
  vol_size                          = var.vol_size_EXTCOLLECTOR
  key_name                          = var.Key_Name_External
  Tenant                            = var.Tenant
  Instance_Profile_Name             = var.Instance_Profile_Name
  Instance_IP                       = var.ExtWinCollector_IP
  JIRA_ID                           = var.JIRA_ID
  vpc_id                            = var.vpc_id
  ServerName                        = var.ServerName_EXTCOLLECTOR
  Owner_Email                       = var.Owner_Email
  External_Collector_Windows_Module = var.External_Collector_Windows_Module
  selected_Zone_ID                  = var.selected_Zone_ID
  ZoneName                          = var.ZoneName
  use_route53_hz                    = var.use_route53_hz
  user_data = templatefile("Template_File/windows_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      Password_ID                = var.Password_ID
      ServerName                 = var.ServerName_EXTCOLLECTOR
      AD_IP                      = var.ExtAD_IP
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
      Coll_IP                    = var.ExtLinuxCollector_IP
      Bucket_Name                = var.Bucket_Name
      VR_Agent_File              = var.VR_Agent_File
      SiteName                   = var.SiteName
      SiteName_RODC              = var.SiteName_EXTRODC
      RODCServerName             = var.ServerName_EXTRODC
      Instance_IP1               = var.ExtWinCollector_IP
      Instance_IP2               = "Null"
      Instance_Mask              = var.Instance_Mask
      Instance_GW                = var.Instance_GW
      Instance_AWSGW             = var.Instance_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Orch_IP                    = var.ExtOrch_IP
      RODC_IP                    = var.ExtRODC_IP
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
#  Module WIN22                                                                                                                                                                                                                                            
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_EXTWIN22" {
  for_each             = var.External_Win22_Module == true ? tomap(var.User_List_EXTWIN22) : {} # Conditional for_each
  source               = "./EXT_WIN22"
  ami                  = var.ami_windows_2k22
  external_sg          = var.sg_dmz_id
  external_subnets     = var.subnet_dmz_id
  instance_type        = var.Instance_Type_WIN22
  Instance_IP          = "10.0.2.${floor(201 + each.key)}"
  vol_size             = var.Volume_Size_WIN22
  key_name             = var.Key_Name_External
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
      ServerName                 = "${var.ServerName_EXTWIN22}-${each.value.Name}"
      AD_IP                      = var.ExtAD_IP
      TimeZoneID                 = var.TimeZoneID
      DomainName                 = var.DomainName
      AdminUser                  = var.AdminUser
      AdminPD_ID                 = var.AdminPD_ID
      AdminSafeModePassword_ID   = var.AdminSafeModePassword_ID
      Token                      = var.Token
      Bucket_Name                = var.Bucket_Name
      VR_Agent_File              = var.VR_Agent_File
      Instance_IP1               = "10.0.2.${floor(201 + each.key)}"
      Instance_IP2               = "Null"
      Instance_Mask              = var.Instance_Mask
      Instance_GW                = var.Instance_GW
      Instance_AWSGW             = var.Instance_AWSGW
      Agent_Type                 = var.Agent_Type
      ForestMode                 = var.ForestMode
      ZoneName                   = var.ZoneName
      DomainMode                 = var.DomainMode
      DatabasePath               = var.DatabasePath
      SYSVOLPath                 = var.SYSVOLPath
      LogPath                    = var.LogPath
      idr_service_account        = var.idr_service_account
      idr_service_account_pwd_ID = var.idr_service_account_pwd_ID
      Coll_IP                    = var.ExtLinuxCollector_IP
      SiteName                   = var.SiteName
      SiteName_RODC              = var.SiteName_EXTRODC
      RODCServerName             = var.ServerName_EXTRODC
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Orch_IP                    = var.ExtOrch_IP
      RODC_IP                    = var.ExtRODC_IP
      ScriptList                 = var.ScriptList_WIN22
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
#  Module IAS Engine                                                                                                                                                                                                                                            
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_EXTIASENGINE" {
  count                 = var.External_IASEngine_Module == true ? 1 : 0
  source                = "./EXT_IASENGINE"
  ami                   = var.ami_windows_2k22
  external_sg           = var.sg_dmz_id
  external_subnets      = var.subnet_dmz_id
  instance_type         = var.Instance_Type_IASENGINE
  vol_size              = var.Volume_Size_IASENGINE
  key_name              = var.Key_Name_External
  Tenant                = var.Tenant
  AdminUser             = var.AdminUser
  AdminPD               = var.AdminPD_ID
  Instance_IP           = var.ExtIASEngine_IP
  JIRA_ID               = var.JIRA_ID
  ServerName            = var.ServerName_EXTIASENGINE
  Token                 = var.Token
  TimeZoneID            = var.TimeZoneID
  Instance_Profile_Name = var.Instance_Profile_Name
  Owner_Email           = var.Owner_Email
  user_data = templatefile("Template_File/windows_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      ServerName                 = var.ServerName_EXTIASENGINE
      AD_IP                      = var.ExtAD_IP
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
      Instance_IP1               = var.ExtIASEngine_IP
      Instance_IP2               = "Null"
      Instance_Mask              = var.Instance_Mask
      Instance_GW                = var.Instance_GW
      Instance_AWSGW             = var.Instance_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Coll_IP                    = var.ExtLinuxCollector_IP
      Orch_IP                    = var.ExtOrch_IP
      SiteName                   = var.SiteName
      SiteName_RODC              = var.SiteName_EXTRODC
      RODCServerName             = var.ServerName_EXTRODC
      RODC_IP                    = var.ExtRODC_IP
      ScriptList                 = var.ScriptList_IASENGINE
      User_Account               = "Null"
      Keyboard_Layout            = var.Keyboard_Layout
      MachineType                = var.MachineType
      Tenant                     = var.Tenant
      VRM_License_Key            = var.VRM_License_Key
      Dummy_Data                 = var.InsightVM_Dummy_Data_HCIVM
      Routing_Type               = var.Routing_Type
      Deployment_Mode            = var.Deployment_Mode
      User_Lists                 = var.User_Lists
      VRM_License_Key            = var.VRM_License_Key
      Scenario                   = ["0"]
      PhishingName               = var.PhishingName

  })
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  InsightVM Hosted Console                                                                                                                                                                                                                                                                       
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_EXTIVM" {
  count                     = var.External_InsightVM_Module == true ? 1 : 0
  source                    = "./EXT_IVM_HOSTED_CONSOLE"
  ami                       = var.ami_ubuntu_22
  external_sg               = var.External_InsightVM_Lockdown ? var.sg_dmz_ivm_ltd_id : var.sg_dmz_ivm_id
  external_subnets          = var.subnet_dmz_id
  instance_type             = var.Instance_Type_HCIVM
  vol_size                  = var.vol_size_HCIVM
  key_name                  = var.Key_Name_External
  Tenant                    = var.Tenant
  JIRA_ID                   = var.JIRA_ID
  Instance_IP               = var.IVM_Hosted_Console_IP
  private_port              = var.IVM_Hosted_Console_Port
  HCIVM_Priority            = var.HCIVM_Priority
  vpc_id                    = var.vpc_id
  Instance_Profile_Name     = var.Instance_Profile_Name
  Owner_Email               = var.Owner_Email
  ServerName                = var.ServerName_HCIVM
  TimeZoneID                = var.TimeZoneID
  Hosted_Console_Mode       = var.Hosted_Console_Mode
  selected_Zone_ID          = var.selected_Zone_ID
  aws_lb_listener_ivm443_id = var.aws_lb_listener_ivm443_id
  ZoneName                  = var.ZoneName
  use_route53_hz            = var.use_route53_hz
  Deployment_Mode           = var.Deployment_Mode
  aws_lb_alb_ivm_zoneid     = var.aws_lb_alb_ivm_zoneid
  aws_lb_alb_ivm_dnsname    = var.aws_lb_alb_ivm_dnsname
  user_data = templatefile("Template_File/linux_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      ServerName                 = var.ServerName_HCIVM
      AD_IP                      = "Null"
      TimeZoneID                 = var.TimeZoneID
      Bucket_Name                = var.Bucket_Name
      ZoneName                   = var.ZoneName
      DomainName                 = var.DomainName
      Token                      = var.Token
      AdminUser                  = var.AdminUser
      AdminPD_ID                 = var.AdminPD_ID
      idr_service_account        = "Null"
      idr_service_account_pwd_ID = "Null"
      VR_Agent_File              = var.VR_Agent_File
      Instance_IP1               = var.IVM_Hosted_Console_IP
      Instance_IP2               = "Null"
      Instance_Mask              = var.Instance_Mask
      Instance_GW                = var.Instance_GW
      Instance_AWSGW             = var.Instance_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Coll_IP                    = "Null"
      Orch_IP                    = "Null"
      SiteName                   = var.SiteName
      SiteName_RODC              = var.SiteName_EXTRODC
      RODCServerName             = "Null"
      RODC_IP                    = "Null"
      ScriptList                 = var.ScriptList_VRM_CONSOLE_UBU
      User_Account               = "Null"
      Keyboard_Layout            = var.Keyboard_Layout
      MachineType                = var.MachineType
      Tenant                     = var.Tenant
      VRM_License_Key            = var.VRM_License_Key
      Dummy_Data                 = var.InsightVM_Dummy_Data_HCIVM
      Routing_Type               = var.Routing_Type
      Deployment_Mode            = var.Deployment_Mode
      Scenario                   = ["0"]
      PhishingName               = var.PhishingName

  })
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Network Sensor                                                                                                                                                                                                                                        
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_EXTNSENSOR" {
  source                = "./EXT_NSENSOR"
  count                 = var.External_NetworkSensor_Module == true ? 1 : 0
  ami                   = var.ami_ubuntu_22
  external_sg           = var.sg_dmz_id
  external_subnets      = var.subnet_dmz_id
  instance_type         = var.Instance_Type_NSENSOR
  vol_size              = var.Volume_Size_NSENSOR
  key_name              = var.Key_Name_External
  Instance_IP1          = var.ExtNSensor_IP1
  Instance_IP2          = var.ExtNSensor_IP2
  Tenant                = var.Tenant
  Instance_Profile_Name = var.Instance_Profile_Name
  JIRA_ID               = var.JIRA_ID
  ServerName            = var.ServerName_EXTNSENSOR
  Owner_Email           = var.Owner_Email
  TimeZoneID            = var.TimeZoneID
  user_data = templatefile("Template_File/linux_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      ServerName                 = var.ServerName_EXTNSENSOR
      AD_IP                      = var.ExtAD_IP
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
      Instance_IP1               = var.ExtNSensor_IP1
      Instance_IP2               = var.ExtNSensor_IP2
      Instance_Mask              = var.Instance_Mask
      Instance_GW                = var.Instance_GW
      Instance_AWSGW             = var.Instance_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Coll_IP                    = var.ExtLinuxCollector_IP
      Orch_IP                    = var.ExtOrch_IP
      SiteName                   = var.SiteName
      SiteName_RODC              = var.SiteName_EXTRODC
      RODCServerName             = var.SiteName_EXTRODC
      RODC_IP                    = var.ExtRODC_IP
      ScriptList                 = var.ScriptList_NSENSOR
      User_Account               = "Null"
      Keyboard_Layout            = var.Keyboard_Layout
      MachineType                = var.MachineType
      Tenant                     = var.Tenant
      VRM_License_Key            = var.VRM_License_Key
      Dummy_Data                 = var.InsightVM_Dummy_Data_HCIVM
      Routing_Type               = var.Routing_Type
      Deployment_Mode            = var.Deployment_Mode
      Scenario                   = ["0"]
      PhishingName               = var.PhishingName

  })
}


#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Orchestrator                                                                                                                                                                                                                                        
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_EXTORCHESTRATOR" {
  source                = "./EXT_ORCHESTRATOR"
  count                 = var.External_Orch_Module == true ? 1 : 0
  ami                   = var.ami_ubuntu_22
  external_sg           = var.sg_dmz_id
  external_subnets      = var.subnet_dmz_id
  instance_type         = var.Instance_Type_ORCHESTRATOR
  vol_size              = var.Volume_Size_ORCHESTRATOR
  key_name              = var.Key_Name_External
  Instance_IP           = var.ExtOrch_IP
  Tenant                = var.Tenant
  Instance_Profile_Name = var.Instance_Profile_Name
  JIRA_ID               = var.JIRA_ID
  ServerName            = var.ServerName_EXTORCHESTRATOR
  Owner_Email           = var.Owner_Email
  TimeZoneID            = var.TimeZoneID
  user_data = templatefile("Template_File/linux_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      ServerName                 = var.ServerName_EXTORCHESTRATOR
      AD_IP                      = var.ExtAD_IP
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
      Instance_IP1               = var.ExtOrch_IP
      Instance_IP2               = "Null"
      Instance_Mask              = var.Instance_Mask
      Instance_GW                = var.Instance_GW
      Instance_AWSGW             = var.Instance_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Coll_IP                    = var.ExtLinuxCollector_IP
      Orch_IP                    = var.ExtOrch_IP
      SiteName                   = var.SiteName
      SiteName_RODC              = var.SiteName_EXTRODC
      RODCServerName             = var.ServerName_EXTRODC
      RODC_IP                    = var.ExtRODC_IP
      ScriptList                 = var.ScriptList_ORCHESTRATOR
      User_Account               = "Null"
      Keyboard_Layout            = var.Keyboard_Layout
      MachineType                = var.MachineType
      Tenant                     = var.Tenant
      VRM_License_Key            = var.VRM_License_Key
      Dummy_Data                 = var.InsightVM_Dummy_Data_HCIVM
      Routing_Type               = var.Routing_Type
      Deployment_Mode            = var.Deployment_Mode
      Scenario                   = ["0"]
      PhishingName               = var.PhishingName
  })
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Windows 11                                                                                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_EXTWIN11" {
  for_each             = var.External_Win11_Module == true ? tomap(var.User_List_EXTWIN11) : {} # Conditional for_each
  source               = "./EXT_WIN11"
  ami                  = var.ami_windows_11
  external_sg          = var.sg_dmz_id
  external_subnets     = var.subnet_dmz_id
  instance_type        = var.Instance_Type_WIN11
  Instance_IP          = "10.0.2.${floor(150 + each.key)}"
  vol_size             = var.Volume_Size_WIN11
  key_name             = var.Key_Name_External
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
      ServerName                 = "${var.ServerName_EXTWIN11}-${each.value.Name}"
      AD_IP                      = var.ExtAD_IP
      TimeZoneID                 = var.TimeZoneID
      DomainName                 = var.DomainName
      AdminUser                  = var.AdminUser
      AdminPD_ID                 = var.AdminPD_ID
      AdminSafeModePassword_ID   = var.AdminSafeModePassword_ID
      Token                      = var.Token
      Bucket_Name                = var.Bucket_Name
      VR_Agent_File              = var.VR_Agent_File
      Instance_IP1               = "10.0.2.${floor(150 + each.key)}"
      Instance_IP2               = "Null"
      Instance_Mask              = var.Instance_Mask
      Instance_GW                = var.Instance_GW
      Instance_AWSGW             = var.Instance_AWSGW
      Agent_Type                 = var.Agent_Type
      ForestMode                 = var.ForestMode
      ZoneName                   = var.ZoneName
      DomainMode                 = var.DomainMode
      DatabasePath               = var.DatabasePath
      SYSVOLPath                 = var.SYSVOLPath
      LogPath                    = var.LogPath
      idr_service_account        = var.idr_service_account
      idr_service_account_pwd_ID = var.idr_service_account_pwd_ID
      Coll_IP                    = var.ExtLinuxCollector_IP
      SiteName                   = var.SiteName
      SiteName_RODC              = var.SiteName_EXTRODC
      RODCServerName             = var.ServerName_EXTRODC
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Orch_IP                    = var.ExtOrch_IP
      RODC_IP                    = var.ExtRODC_IP
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
#  Module Traffic Mirroring                                                                                                                                                                                                                                       
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "ext_traffic_mirroring" {
  source                        = "./EXT_traffic_mirroring"
  count                         = var.External_NetworkSensor_Module == true ? 1 : 0
  AWS_Region                    = var.AWS_Region
  Tenant                        = var.Tenant
  JIRA_ID                       = var.JIRA_ID
  traffic_nic_id                = one(module.compute_EXTNSENSOR[*].traffic_nic_id)
  traffic_instance              = one(module.compute_EXTNSENSOR[*].traffic_instance)
  vpc_id                        = var.vpc_id
  subnet_dmz_id                 = var.subnet_dmz_id
  traffic_nic_ip                = one(module.compute_EXTNSENSOR[*].traffic_nic_ip)
  sg_dmz_id                     = var.sg_dmz_id
  sg_jumpbox_id                 = var.sg_jumpbox_id
  Owner_Email                   = var.Owner_Email
  Deployment_Mode               = var.Deployment_Mode
  Routing_Type                  = var.Routing_Type
  NLB_Private_IP                = var.ExtNLB_Private_IP
  Jumpbox_Module                = var.Jumpbox_Module
  External_NetworkSensor_Module = var.External_NetworkSensor_Module
}


#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module Traffic Mirroring - Sessions                                                                                                                                                                                                                                     
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# ADDS01 #############
resource "aws_ec2_traffic_mirror_session" "session_extadds01" {
  count                    = var.External_NetworkSensor_Module == true && var.External_AD_Module == true ? 1 : 0
  description              = "Traffic mirror session - DMZ - ADDS01"
  network_interface_id     = one(module.compute_EXTADDS01[*].private_ip_eni_id)
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = one(module.ext_traffic_mirroring[*].traffic_mirror_filter_ext_id)[0]
  traffic_mirror_target_id = one(module.ext_traffic_mirroring[*].traffic_mirror_target_ext_id)[0]
  tags = {
    "Name"        = "${var.Tenant}-DMZ-Session-ExtADDS01"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# WIN22 #############
resource "aws_ec2_traffic_mirror_session" "session_win22" {
  for_each                 = var.External_NetworkSensor_Module == true && var.External_Win22_Module == true ? tomap(var.User_List_EXTWIN22) : {} # Conditional for_each
  description              = "Traffic mirror session - DMZ - WIN22 -${each.value.Name}"
  network_interface_id     = module.compute_EXTWIN22[each.key].private_ip_eni_id
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = one(module.ext_traffic_mirroring[*].traffic_mirror_filter_ext_id)[0]
  traffic_mirror_target_id = one(module.ext_traffic_mirroring[*].traffic_mirror_target_ext_id)[0]
  tags = {
    "Name"        = "${var.Tenant}-DMZ-Session-WIN22-${each.value.Name}"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Collector Linux #############
resource "aws_ec2_traffic_mirror_session" "session_extlinuxcollector" {
  count                    = var.External_NetworkSensor_Module == true && var.External_Collector_Linux_Module == true ? 1 : 0
  description              = "Traffic mirror session - DMZ - COLLECTOR"
  network_interface_id     = one(module.compute_EXTLINUXCOLLECTOR[*].private_ip_eni_id)
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = one(module.ext_traffic_mirroring[*].traffic_mirror_filter_ext_id)[0]
  traffic_mirror_target_id = one(module.ext_traffic_mirroring[*].traffic_mirror_target_ext_id)[0]
  tags = {
    "Name"        = "${var.Tenant}-DMZ-Session-ExtCOLLECTOR"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Collector Windows #############
resource "aws_ec2_traffic_mirror_session" "session_extwincollector" {
  count                    = var.External_NetworkSensor_Module == true && var.External_Collector_Windows_Module == true ? 1 : 0
  description              = "Traffic mirror session - DMZ - COLLECTOR"
  network_interface_id     = one(module.compute_EXTWINCOLLECTOR[*].private_ip_eni_id)
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = one(module.ext_traffic_mirroring[*].traffic_mirror_filter_ext_id)[0]
  traffic_mirror_target_id = one(module.ext_traffic_mirroring[*].traffic_mirror_target_ext_id)[0]
  tags = {
    "Name"        = "${var.Tenant}-DMZ-Session-ExtCOLLECTOR"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Orchestrator #############
resource "aws_ec2_traffic_mirror_session" "session_extorchestrator" {
  count                    = var.External_NetworkSensor_Module == true && var.External_Orch_Module == true ? 1 : 0
  description              = "Traffic mirror session - DMZ - ORCHESTRATOR"
  network_interface_id     = one(module.compute_EXTORCHESTRATOR[*].private_ip_eni_id)
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = one(module.ext_traffic_mirroring[*].traffic_mirror_filter_ext_id)[0]
  traffic_mirror_target_id = one(module.ext_traffic_mirroring[*].traffic_mirror_target_ext_id)[0]
  tags = {
    "Name"        = "${var.Tenant}-DMZ-Session-ExtORCHESTRATOR"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# InsightVM #############
resource "aws_ec2_traffic_mirror_session" "session_extinsightvm" {
  count                    = var.External_NetworkSensor_Module == true && var.External_InsightVM_Module == true ? 1 : 0
  description              = "Traffic mirror session - DMZ - InsightVM"
  network_interface_id     = one(module.compute_EXTIVM[*].private_ip_eni_id)
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = one(module.ext_traffic_mirroring[*].traffic_mirror_filter_ext_id)[0]
  traffic_mirror_target_id = one(module.ext_traffic_mirroring[*].traffic_mirror_target_ext_id)[0]
  tags = {
    "Name"        = "${var.Tenant}-DMZ-Session-ExtInsightVM"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Windows 11 #############
resource "aws_ec2_traffic_mirror_session" "session_extwin11" {
  for_each                 = var.External_NetworkSensor_Module == true && var.External_Win11_Module == true ? tomap(var.User_List_EXTWIN11) : {} # Conditional for_each
  description              = "Traffic mirror session - DMZ - Win11 - ${each.value.Name}"
  network_interface_id     = module.compute_EXTWIN11[each.key].private_ip_eni_id
  packet_length            = 8500
  session_number           = 1
  traffic_mirror_filter_id = one(module.ext_traffic_mirroring[*].traffic_mirror_filter_ext_id)[0]
  traffic_mirror_target_id = one(module.ext_traffic_mirroring[*].traffic_mirror_target_ext_id)[0]
  tags = {
    "Name"        = "${var.Tenant}-DMZ-Session-Win11-${each.value.Name}"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
