#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                             DMZ Subnet Main                                                                                   #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  External AWS Linux Module                                                                                                                                                                                                                                                                        
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "compute_EXTLINUXAWS" {
  count                 = var.POVAgent_Module == true ? 1 : 0
  source                = "./AWS_INSTANCE_LINUX"
  ami                   = var.ami_aws_linux
  external_sg           = var.sg_povagent_ext_id
  external_subnets      = var.subnet_povagent_ext_id
  instance_type         = var.Instance_Type_EXTAWS
  vol_size              = var.vol_size_EXTAWS
  key_name              = var.Key_Name_External
  Tenant                = var.Tenant
  Instance_Profile_Name = var.Instance_Profile_Name_AWSAMILINUX
  Instance_IP           = var.ExtLinuxAWS_IP
  JIRA_ID               = var.JIRA_ID
  vpc_id                = var.vpc_id
  ServerName            = var.ServerName_EXTAWS
  Owner_Email           = var.Owner_Email
  POVAgent_Module       = var.POVAgent_Module
  selected_Zone_ID      = var.selected_Zone_ID
  ZoneName              = var.ZoneName
  use_route53_hz        = var.use_route53_hz
  user_data = templatefile("Template_File/linux_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      ServerName                 = var.ServerName_EXTAWS
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
      Instance_IP1               = var.ExtLinuxAWS_IP
      Instance_IP2               = "Null"
      Instance_Mask              = var.AWSCLI_Instance_Mask
      Instance_GW                = var.AWSCLI_Instance_GW
      Instance_AWSGW             = var.AWSCLI_Instance_AWSGW
      Agent_Type                 = var.Agent_Type
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Coll_IP                    = "Null"
      Orch_IP                    = "Null"
      SiteName                   = var.SiteName
      SiteName_RODC              = var.SiteName_EXTRODC
      RODCServerName             = "Null"
      RODC_IP                    = "Null"
      ScriptList                 = var.ScriptList_LINUXAWS
      User_Account               = "Null"
      Keyboard_Layout            = var.Keyboard_Layout
      MachineType                = "Null"
      Tenant                     = var.Tenant
      VRM_License_Key            = "Null"
      Dummy_Data                 = "Null"
      Routing_Type               = "Null"
      Deployment_Mode            = "Null"
      Scenario                   = ["0"]
      PhishingName               = var.PhishingName
  })
}
