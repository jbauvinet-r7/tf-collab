#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                       Rapid7 Subnet Main Definitions                                                                          #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Module IAS Engine                                                                                                                                                                                                                                            
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_IASENGINE" {
  source                = "./compute/IASENGINE"
  ami                   = var.ami_windows_2k22
  count                 = var.InsightAppSec_Module == true || var.InsightAppSec_IAS_engine == true ? 1 : 0
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
      PhishingName               = var.PhishingName

  })
}
