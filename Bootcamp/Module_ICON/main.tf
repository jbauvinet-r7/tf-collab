#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                       Rapid7 Subnet Main Definitions                                                                          #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

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
      PhishingName               = var.PhishingName

  })
}
