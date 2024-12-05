#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                            Main Terraform                                                                                     #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Commands to use                                                                                                                                                                                                                                                                           
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#List all the workspace             : terraform workspace list
#Create a new workspace             : terraform workspace new [name]
#Create a new workspace from state  : terraform workspace new -state=old.terraform.tfstate [name]
#Select a workspace                 : terraform workspace select [name]
#Delete a workspace                 : terraform workspace delete [name]
#Initialize the terraform           : terraform init
#Plan the terraform                 : terraform plan -var-file "tfvars_folder/[DIR]/$(terraform workspace show).tfvars"     
#Apply the terraform                : terraform apply -var-file "tfvars_folder/[DIR]/$(terraform workspace show).tfvars"   
#Import the DNS Zone                : terraform import -var-file "tfvars_folder/[DIR]/$(terraform workspace show).tfvars" aws_route53_zone.selected Z04590142Q8XXPJ2MZ4SF 
#IF LFS ERROR GITHUB PUSH
#git lfs install --skip-smudge
#git lfs uninstall
#git push

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   Existing AWS Route 53 Zone                                                                                                                                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_route53_zone" "selected" {
  name = var.ZoneName
  lifecycle {
    prevent_destroy = true
  }
}


#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   S3 Module (S3 Bucket, Files)                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "s3" {
  count             = var.Deployment_Mode == "none" || var.BootCamp_Mode == true ? 0 : 1
  source            = "./s3bucket"
  Bucket_Name       = "${var.R7_Region}-${var.Bucket_Name}-${lower(var.Tenant)}"
  aws_s3_bucket_acl = var.Acl_Value
  Tenant            = var.Tenant
  JIRA_ID           = var.JIRA_ID
  Key_Name_Internal = module.iam[0].Key_Name_Internal_id
  Key_Name_External = module.iam[0].Key_Name_External_id
  R7_Region         = var.R7_Region
  Owner_Email       = "${var.Owner_Email}_${lower(var.Tenant)}"
  POVAgent_Module   = var.POVAgent_Module
  Bucket_Name_Agent = "${var.R7_Region}-${var.Bucket_Name_Agent}-${lower(var.Tenant)}"
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   IAM Module (IAM Role, Instance Profile, Policy, Instance Certificates)                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "iam" {
  count                 = var.Deployment_Mode == "none" || var.BootCamp_Mode == true ? 0 : 1
  source                = "./iam/role"
  Tenant                = var.Tenant
  JIRA_ID               = var.JIRA_ID
  Instance_Profile_Name = "${var.R7_Region}-${var.Instance_Profile_Name}-${lower(var.Tenant)}"
  Iam_Policy_Name       = "${var.R7_Region}-${var.Iam_Policy_Name}-${lower(var.Tenant)}"
  Role_Name             = "${var.R7_Region}-${var.Role_Name}-${lower(var.Tenant)}"
  Key_Name_External     = "${var.Tenant}_${var.Key_Name_External}"
  Key_Name_Internal     = "${var.Tenant}_${var.Key_Name_Internal}"
  R7_Region             = var.R7_Region
  Bucket_Name           = "${var.R7_Region}-${var.Bucket_Name}-${lower(var.Tenant)}"
  Owner_Email           = "${var.Owner_Email}_${lower(var.Tenant)}"
  POVAgent_Module       = var.POVAgent_Module
  Bucket_Name_Agent     = "${var.R7_Region}-${var.Bucket_Name_Agent}-${lower(var.Tenant)}"
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   Networking Module (VPC, Subnets, Prefix lists (IAS Engine, R7 VPNs), Security Groups, Routing, NICs, ALB))                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "networking" {
  count              = var.Deployment_Mode == "none" || var.BootCamp_Mode == true ? 0 : 1
  source             = "./networking"
  AWS_Region         = var.AWS_Region
  Tenant             = var.Tenant
  JIRA_ID            = var.JIRA_ID
  availability_zone  = "${var.AWS_Region}a"
  availability_zone2 = "${var.AWS_Region}c"
  R7vpn_List         = var.R7vpn_List
  Bucket_Name        = module.s3[0].Bucket_Name
  ZoneName           = var.ZoneName
  Zone_ID            = var.Zone_ID
  Owner_Email        = "${var.Owner_Email}_${lower(var.Tenant)}"
  IASEngine_List     = var.IASEngine_List
  Routing_Type       = var.Routing_Type
  Deployment_Mode    = var.Deployment_Mode
  Public_Access_ALB  = var.Public_Access_ALB
  use_route53_hz     = var.use_route53_hz
  Jumpbox_Module     = var.Jumpbox_Module
  ExtCollector_ICSIP = var.ExtCollector_ICSIP
  POVAgent_Module    = var.POVAgent_Module
  SEOPS_Orch_IP      = var.SEOPS_Orch_IP
  R7officeList       = var.R7office_List
  InsightVM_Module   = var.InsightVM_Module
}


#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   Secrets Manager Module                                                                                                                                                                                                                                                                                          
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "secrets_manager" {
  count                   = var.Deployment_Mode == "none" || var.BootCamp_Mode == true ? 0 : 1
  source                  = "./secrets_manager"
  Tenant                  = var.Tenant
  JIRA_ID                 = var.JIRA_ID
  R7_Region               = var.R7_Region
  Owner_Email             = "${var.Owner_Email}_${lower(var.Tenant)}"
  idr_service_account_pwd = var.idr_service_account_pwd
  AdminPD                 = var.AdminPD
  AdminSafeModePassword   = var.AdminSafeModePassword
  Password                = var.Password
  AWS_Region              = var.AWS_Region
  vpc_id                  = module.networking[0].vpc_id
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   Firewall Subnet Module (External Firewall + Internal Firewall (pfSense))                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "Subnet_Firewalls" {
  count                   = var.Routing_Type == "pfsense" && var.Deployment_Mode != "none" || var.Routing_Type == "pfsense" && var.BootCamp_Mode != true && var.Deployment_Mode != "none" ? 1 : 0
  source                  = "./Subnet_Firewalls"
  ami                     = data.aws_ami.pfsense.id
  private_sg              = module.networking[0].sg_fw_id
  public_sg               = module.networking[0].sg_fw_public_id
  subnet_dmz_id           = module.networking[0].subnet_dmz_id
  subnet_fw_intra_id      = module.networking[0].subnet_fw_intra_id
  instance_count          = var.Instance_Count_FIREWALL
  instance_type           = var.Instance_Type_FIREWALL
  vol_size                = var.Volume_Size_FIREWALL
  Key_Name_Internal       = module.iam[0].Key_Name_Internal_id
  Key_Name_External       = module.iam[0].Key_Name_External_id
  Tenant                  = var.Tenant
  JIRA_ID                 = var.JIRA_ID
  ServerName              = var.ServerName_FIREWALL
  Instance_Profile_Name   = module.iam[0].Instance_Profile_Name
  eni_jumpbox_id          = module.networking[0].eni_jumpbox_id
  eni_rapid7_id           = module.networking[0].eni_rapid7_id
  eni_it_id               = module.networking[0].eni_it_id
  eni_hq_id               = module.networking[0].eni_hq_id
  eni_fw_public_id        = module.networking[0].eni_fw_public_id
  eni_fw_int_id           = module.networking[0].eni_fw_int_id
  eni_dmz_id              = module.networking[0].eni_dmz_id
  eni_fw_publicprivate_id = module.networking[0].eni_fw_publicprivate_id
  ZoneName                = var.ZoneName
  selected_Zone_ID        = aws_route53_zone.selected.id
  #selected_Zone_ID        = length(aws_route53_zone.selected) > 0 ? aws_route53_zone.selected[0].id : ""
  Owner_Email     = "${var.Owner_Email}_${lower(var.Tenant)}"
  use_route53_hz  = var.use_route53_hz
  Deployment_Mode = var.Deployment_Mode
  user_data = templatefile("Subnet_Firewalls/user_data.tpl",
    {
      Password_ID = module.secrets_manager[0].sm_Password_arn
  })
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   Users Lists                                                                                                                                                                                                                                                                                               
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
locals {
  User_Lists = flatten([
    for user_list in [
      var.User_List_LINUX_IT,
      var.User_List_LINUX_HQ,
      var.User_List_WIN10_IT,
      var.User_List_WIN10_HQ,
      var.User_List_WIN11_IT,
      var.User_List_WIN11_HQ,
      var.User_List_Malicious,
      var.User_List_EXTWIN11,
      var.User_List_EXTWIN22
      ] : [
      for user in values(user_list) : user.Name
    ]
  ])
}
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   Jumpbox Subnet Module (Jumpbox)                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "Subnet_JUMPBOX" {
  count                = var.Jumpbox_Module == false || var.Deployment_Mode == "none" || var.BootCamp_Mode == true ? 0 : 1
  source               = "./Subnet_Jumpbox"
  ami                  = data.aws_ami.windows2k22.id
  external_sg          = module.networking[0].sg_jumpbox_id
  external_subnets     = module.networking[0].subnet_jumpbox_id
  ServerName           = var.ServerName_JUMPBOX
  instance_type        = var.Instance_Type_JUMPBOX
  vol_size             = var.Volume_Size_JUMPBOX
  key_name             = module.iam[0].Key_Name_External_id
  Tenant               = var.Tenant
  Instance_IP          = var.Jump_IP
  JIRA_ID              = var.JIRA_ID
  Token                = var.Token
  TimeZoneID           = var.TimeZoneID
  iam_instance_profile = module.iam[0].Instance_Profile_Name
  ZoneName             = var.ZoneName
  #selected_Zone_ID     = length(aws_route53_zone.selected) > 0 ? aws_route53_zone.selected[0].id : ""
  selected_Zone_ID = aws_route53_zone.selected.id
  Owner_Email      = "${var.Owner_Email}_${lower(var.Tenant)}"
  Agent_Type       = var.Agent_Type
  use_route53_hz   = var.use_route53_hz
  Routing_Type     = var.Routing_Type
  user_data = templatefile("Template_File/windows_user_data.tpl",
    {
      R7_Region                  = var.R7_Region
      AWS_Region                 = var.AWS_Region
      Password_ID                = module.secrets_manager[0].sm_Password_arn
      ServerName                 = var.ServerName_JUMPBOX
      AD_IP                      = var.AD_IP
      TimeZoneID                 = var.TimeZoneID
      ZoneName                   = var.ZoneName
      DomainName                 = var.DomainName
      Instance_IP1               = var.Jump_IP
      Instance_IP2               = "Null"
      Instance_Mask              = var.Jump_Mask
      Instance_GW                = var.Jump_GW
      Instance_AWSGW             = var.Jump_AWSGW
      Agent_Type                 = var.Agent_Type
      ForestMode                 = var.ForestMode
      AdminSafeModePassword_ID   = module.secrets_manager[0].sm_AdminSafeModePassword_arn
      DomainMode                 = var.DomainMode
      DatabasePath               = var.DatabasePath
      SYSVOLPath                 = var.SYSVOLPath
      LogPath                    = var.LogPath
      Token                      = var.Token
      AdminUser                  = var.AdminUser
      AdminPD_ID                 = module.secrets_manager[0].sm_AdminPD_arn
      idr_service_account        = var.idr_service_account
      idr_service_account_pwd_ID = module.secrets_manager[0].sm_idr_service_account_pwd_arn
      Coll_IP                    = var.Coll_IP
      Bucket_Name                = module.s3[0].Bucket_Name
      VR_Agent_File              = var.VR_Agent_File
      SiteName                   = var.SiteName_JUMPBOX
      SiteName_RODC              = var.SiteName_RODC
      RODCServerName             = var.ServerName_RODC_HQ
      SEOPS_VR_Install           = var.SEOPS_VR_Install
      Orch_IP                    = var.Orch_IP
      RODC_IP                    = var.RODC_IP
      ScriptList                 = var.ScriptList_JUMPBOX
      User_Account               = "Null"
      Keyboard_Layout            = var.Keyboard_Layout
      Routing_Type               = var.Routing_Type
      Deployment_Mode            = var.Deployment_Mode
      User_Lists                 = local.User_Lists
      VRM_License_Key            = var.VRM_License_Key
      Scenario                   = ["0"]
      PhishingName               = var.PhishingName
      depends_on                 = [module.s3]
  })
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   AWS POV Agent Subnet Module                                                                                                                                                                                                                                                                                          
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "Subnet_POVAgent" {
  count                             = var.POVAgent_Module == true ? 1 : 0
  source                            = "./Subnet_POVAgent"
  sg_povagent_ext_id                = module.networking[0].sg_povagent_ext_id
  sg_povagent_int_id                = module.networking[0].sg_povagent_int_id
  Tenant                            = var.Tenant
  Key_Name_Internal                 = module.iam[0].Key_Name_Internal_id
  Key_Name_External                 = module.iam[0].Key_Name_External_id
  Instance_Profile_Name_AWSAMILINUX = module.iam[0].Instance_Profile_Name_AWSAMILINUX
  JIRA_ID                           = var.JIRA_ID
  ami_aws_linux                     = data.aws_ami.awslinux.id
  Bucket_Name                       = module.s3[0].Bucket_Name
  AdminPD_ID                        = module.secrets_manager[0].sm_AdminPD_arn
  AdminUser                         = var.AdminUser
  TimeZoneID                        = var.TimeZoneID
  Token                             = var.Token
  R7_Region                         = var.R7_Region
  vpc_id                            = module.networking[0].vpc_id
  Agent_Type                        = var.Agent_Type
  Owner_Email                       = "${var.Owner_Email}_${lower(var.Tenant)}"
  depends_on                        = [module.s3]
  ServerName_EXTAWS                 = var.ServerName_EXTAWS
  ScriptList_LINUXAWS               = var.ScriptList_LINUXAWS
  POVAgent_Module                   = var.POVAgent_Module
  Instance_Type_EXTAWS              = var.Instance_Type_EXTAWS
  vol_size_EXTAWS                   = var.Volume_Size_EXTAWS
  ExtLinuxAWS_IP                    = var.ExtLinuxAWS_IP
  SiteName                          = var.SiteName_POVAgent
  AWS_Region                        = var.AWS_Region
  VR_Agent_File                     = var.VR_Agent_File
  SiteName_EXTRODC                  = var.SiteName_RODC
  AWSCLI_Instance_GW                = var.POVAgent_EXT_GW
  AWSCLI_Instance_Mask              = var.POVAgent_EXT_Mask
  AWSCLI_Instance_AWSGW             = var.POVAgent_EXT_AWSGW
  DomainName                        = var.DomainName
  SEOPS_VR_Install                  = var.SEOPS_VR_Install
  ZoneName                          = var.ZoneName
  Keyboard_Layout                   = var.Keyboard_Layout
  use_route53_hz                    = var.use_route53_hz
  selected_Zone_ID                  = var.Zone_ID
  subnet_povagent_int_id            = module.networking[0].subnet_povagent_int_id
  subnet_povagent_ext_id            = module.networking[0].subnet_povagent_ext_id
  PhishingName                      = var.PhishingName

}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   DMZ Subnet Module (External Collector)                                                                                                                                                                                                                                                                                               
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "Subnet_DMZ" {
  count                             = var.Deployment_Mode == "none" || var.BootCamp_Mode == true ? 0 : 1
  source                            = "./Subnet_DMZ"
  Instance_Type_EXTCOLLECTOR        = var.Instance_Type_EXTCOLLECTOR
  vol_size_EXTCOLLECTOR             = var.Volume_Size_EXTCOLLECTOR
  ServerName_EXTCOLLECTOR           = var.ServerName_EXTCOLLECTOR
  sg_dmz_id                         = module.networking[0].sg_dmz_id
  sg_dmz_ivm_id                     = module.networking[0].sg_dmz_ivm_id
  sg_dmz_ivm_ltd_id                 = module.networking[0].sg_dmz_ivm_ltd_id
  subnet_dmz_id                     = module.networking[0].subnet_dmz_id
  Tenant                            = var.Tenant
  Key_Name_Internal                 = module.iam[0].Key_Name_Internal_id
  Key_Name_External                 = module.iam[0].Key_Name_External_id
  Instance_Profile_Name             = module.iam[0].Instance_Profile_Name
  JIRA_ID                           = var.JIRA_ID
  ami_ubuntu_20                     = data.aws_ami.ubuntu20.id
  ami_ubuntu_22                     = data.aws_ami.ubuntu22.id
  ami_debian_12                     = data.aws_ami.debian12.id
  ami_windows_2k22                  = data.aws_ami.windows2k22.id
  ami_centos_8                      = data.aws_ami.debian12.id
  ami_windows_11                    = data.aws_ami.windows11.id
  ami_windows_10                    = data.aws_ami.windows10.id
  ami_aws_linux                     = data.aws_ami.awslinux.id
  DomainName                        = var.DomainName
  Bucket_Name                       = module.s3[0].Bucket_Name
  AdminPD_ID                        = module.secrets_manager[0].sm_AdminPD_arn
  AdminUser                         = var.AdminUser
  TimeZoneID                        = var.TimeZoneID
  Token                             = var.Token
  R7_Region                         = var.R7_Region
  Instance_GW                       = var.DMZ_GW
  ExtLinuxCollector_IP              = var.ExtLinuxCollector_IP
  IVM_Hosted_Console_IP             = var.IVM_Hosted_Console_IP
  IVM_Hosted_Console_Port           = var.IVM_Hosted_Console_Port
  HCIVM_Priority                    = var.HCIVM_Priority
  aws_lb_listener_ivm443_id         = module.networking[0].aws_lb_listener_ivm443_id
  vpc_id                            = module.networking[0].vpc_id
  Instance_Type_HCIVM               = var.Instance_Type_HCIVM
  vol_size_HCIVM                    = var.Volume_Size_HCIVM
  ServerName_HCIVM                  = var.ServerName_HCIVM
  Instance_Mask                     = var.DMZ_Mask
  Instance_AWSGW                    = var.DMZ_AWSGW
  Agent_Type                        = var.Agent_Type
  Owner_Email                       = "${var.Owner_Email}_${lower(var.Tenant)}"
  External_Collector_Linux_Module   = var.External_Collector_Linux_Module
  Hosted_Console_Mode               = var.Hosted_Console_Mode
  Password_ID                       = module.secrets_manager[0].sm_Password_arn
  VRM_License_Key                   = var.VRM_License_Key
  MachineType                       = var.MachineType
  VRM_ENGINE_IP                     = var.VRM_ENGINE_IP
  ServerName_VRM_ENGINE             = var.ServerName_VRM_ENGINE
  InsightVM_Dummy_Data_HCIVM        = var.InsightVM_Dummy_Data_HCIVM
  ZoneName                          = var.ZoneName
  aws_lb_alb_ivm_dnsname            = module.networking[0].aws_lb_alb_ivm_dnsname
  aws_lb_alb_ivm_zoneid             = module.networking[0].aws_lb_alb_ivm_zoneid
  selected_Zone_ID                  = var.Zone_ID
  use_route53_hz                    = var.use_route53_hz
  SEOPS_VR_Install                  = var.SEOPS_VR_Install
  ScriptList_LINUXCOLLECTOR         = var.ScriptList_LINUXCOLLECTOR
  ScriptList_VRM_CONSOLE_UBU        = var.ScriptList_VRM_CONSOLE_UBU
  Keyboard_Layout                   = var.Keyboard_Layout
  VR_Agent_File                     = var.VR_Agent_File
  SiteName                          = var.SiteName_DMZ
  SiteName_EXTRODC                  = var.SiteName_RODC
  Routing_Type                      = var.Routing_Type
  Deployment_Mode                   = var.Deployment_Mode
  AWS_Region                        = var.AWS_Region
  Instance_Type_AD                  = var.Instance_Type_AD
  ExtAD_IP                          = var.ExtAD_IP
  AdminSafeModePassword_ID          = module.secrets_manager[0].sm_AdminSafeModePassword_arn
  ExtRODC_IP                        = var.ExtRODC_IP
  SiteName_AD                       = var.SiteName_AD
  ScriptList_ADDS01                 = var.ScriptList_ADDS01
  idr_service_account               = var.idr_service_account
  idr_service_account_pwd_ID        = module.secrets_manager[0].sm_idr_service_account_pwd_arn
  Volume_Size_AD                    = var.Volume_Size_AD
  DomainMode                        = var.DomainMode
  SYSVOLPath                        = var.SYSVOLPath
  ForestMode                        = var.ForestMode
  LogPath                           = var.LogPath
  DatabasePath                      = var.DatabasePath
  ServerName_EXTRODC                = var.ServerName_EXTRODC
  SiteName_DMZ                      = var.SiteName_DMZ
  ServerName_EXTAD                  = var.ServerName_EXTAD
  Volume_Size_IASENGINE             = var.Volume_Size_IASENGINE
  Instance_Type_IASENGINE           = var.Instance_Type_IASENGINE
  ServerName_EXTIASENGINE           = var.ServerName_EXTIASENGINE
  ExtIASEngine_IP                   = var.ExtIASEngine_IP
  ScriptList_IASENGINE              = var.ScriptList_IASENGINE
  ScriptList_ORCHESTRATOR           = var.ScriptList_ORCHESTRATOR
  External_AD_Module                = var.External_AD_Module
  External_IASEngine_Module         = var.External_IASEngine_Module
  External_Orch_Module              = var.External_Orch_Module
  External_InsightVM_Module         = var.External_InsightVM_Module
  External_InsightVM_Lockdown       = var.External_InsightVM_Lockdown
  Volume_Size_ORCHESTRATOR          = var.Volume_Size_ORCHESTRATOR
  Instance_Type_ORCHESTRATOR        = var.Instance_Type_ORCHESTRATOR
  ExtOrch_IP                        = var.ExtOrch_IP
  ServerName_EXTORCHESTRATOR        = var.ServerName_EXTORCHESTRATOR
  User_Lists                        = local.User_Lists
  ExtNLB_Private_IP                 = var.ExtNLB_Private_IP
  ExtNSensor_IP1                    = var.ExtNSensor_IP1
  ExtNSensor_IP2                    = var.ExtNSensor_IP2
  External_NetworkSensor_Module     = var.External_NetworkSensor_Module
  sg_jumpbox_id                     = module.networking[0].sg_jumpbox_id
  ScriptList_NSENSOR                = var.ScriptList_NSENSOR
  ServerName_EXTNSENSOR             = var.ServerName_EXTNSENSOR
  Instance_Type_NSENSOR             = var.Instance_Type_NSENSOR
  Volume_Size_NSENSOR               = var.Volume_Size_NSENSOR
  ScriptList_WIN11                  = var.ScriptList_WIN11
  ServerName_EXTWIN11               = var.ServerName_EXTWIN11
  User_List_EXTWIN11                = var.User_List_EXTWIN11
  Instance_Type_WIN11               = var.Instance_Type_WIN11
  Volume_Size_WIN11                 = var.Volume_Size_WIN11
  External_Win11_Module             = var.External_Win11_Module
  Jumpbox_Module                    = var.Jumpbox_Module
  ExtWinCollector_IP                = var.ExtWinCollector_IP
  External_Collector_Windows_Module = var.External_Collector_Windows_Module
  ScriptList_IDR_WINCOLLECTOR       = var.ScriptList_IDR_WINCOLLECTOR
  depends_on                        = [module.s3]
  ServerName_EXTAWS                 = var.ServerName_EXTAWS
  ScriptList_LINUXAWS               = var.ScriptList_LINUXAWS
  POVAgent_Module                   = var.POVAgent_Module
  Instance_Type_EXTAWS              = var.Instance_Type_EXTAWS
  vol_size_EXTAWS                   = var.Volume_Size_EXTAWS
  ExtLinuxAWS_IP                    = var.ExtLinuxAWS_IP
  Instance_Profile_Name_AWSAMILINUX = module.iam[0].Instance_Profile_Name_AWSAMILINUX
  PhishingName                      = var.PhishingName
  ServerName_EXTWIN22               = var.ServerName_EXTWIN22
  ScriptList_WIN22                  = var.ScriptList_2K22
  External_Win22_Module             = var.External_Win22_Module
  Instance_Type_WIN22               = var.Instance_Type_WIN22
  Volume_Size_WIN22                 = var.Volume_Size_WIN22
  User_List_EXTWIN22                = var.User_List_EXTWIN22

}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   IT Subnet Module (ADDS01 (DNS, Certificate..), DHCP, Servers (FileServer, WebServer, 2K19, 2K22, Linux), Workstations (10,11,linux))                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "Subnet_IT" {
  count                         = var.Deployment_Mode == "none" || var.Deployment_Mode == "custom" || var.Deployment_Mode == "limited" || var.BootCamp_Mode == true ? 0 : 1
  source                        = "./Subnet_IT"
  AWS_Region                    = var.AWS_Region
  R7_Region                     = var.R7_Region
  Tenant                        = var.Tenant
  JIRA_ID                       = var.JIRA_ID
  Bucket_Name                   = module.s3[0].Bucket_Name
  Key_Name_Internal             = module.iam[0].Key_Name_Internal_id
  Key_Name_External             = module.iam[0].Key_Name_External_id
  Instance_Profile_Name         = module.iam[0].Instance_Profile_Name
  ami_ubuntu_20                 = data.aws_ami.ubuntu20.id
  ami_ubuntu_22                 = data.aws_ami.ubuntu22.id
  ami_windows_2k19              = data.aws_ami.windows2k19.id
  ami_windows_2k22              = data.aws_ami.windows2k22.id
  ami_windows_11                = data.aws_ami.windows11.id
  ami_windows_10                = data.aws_ami.windows10.id
  ServerName_2K19               = var.ServerName_2K19_IT
  ServerName_2K22               = var.ServerName_2K22_IT
  ServerName_AD                 = var.ServerName_AD_IT
  ServerName_DHCP               = var.ServerName_DHCP_IT
  ServerName_FILESERVER         = var.ServerName_FILESERVER_IT
  ServerName_LINUX              = var.ServerName_LINUX_IT
  ServerName_WEBSERVER          = var.ServerName_WEBSERVER_IT
  ServerName_RODC               = var.ServerName_RODC_HQ
  Instance_Count_LINUX          = var.Instance_Count_LINUX
  Instance_Type_AD              = var.Instance_Type_AD
  Instance_Type_LINUX           = var.Instance_Type_LINUX
  Instance_Type_WIN10           = var.Instance_Type_WIN10
  idr_service_account           = var.idr_service_account
  idr_service_account_pwd_ID    = module.secrets_manager[0].sm_idr_service_account_pwd_arn
  Volume_Size_AD                = var.Volume_Size_AD
  Volume_Size_LINUX             = var.Volume_Size_LINUX
  Volume_Size_WIN10             = var.Volume_Size_WIN10
  TimeZoneID                    = var.TimeZoneID
  Token                         = var.Token
  SYSVOLPath                    = var.SYSVOLPath
  User_List_LINUX               = var.User_List_LINUX_IT
  User_List_WIN10               = var.User_List_WIN10_IT
  DomainMode                    = var.DomainMode
  DomainName                    = var.DomainName
  AdminSafeModePassword_ID      = module.secrets_manager[0].sm_AdminSafeModePassword_arn
  AdminPD_ID                    = module.secrets_manager[0].sm_AdminPD_arn
  AdminUser                     = var.AdminUser
  ServerName_WIN10              = var.ServerName_WIN10_IT
  VR_Agent_File                 = var.VR_Agent_File
  ForestMode                    = var.ForestMode
  LogPath                       = var.LogPath
  DatabasePath                  = var.DatabasePath
  Coll_IP                       = var.Coll_IP
  Orch_IP                       = var.Orch_IP
  Password_ID                   = module.secrets_manager[0].sm_Password_arn
  SiteName_IT                   = var.SiteName_IT
  SiteName_AD                   = var.SiteName_AD
  SiteName_RODC                 = var.SiteName_RODC
  traffic_mirror_filter_id      = module.Subnet_Rapid7[0].traffic_mirror_filter_id
  traffic_mirror_target_id      = module.Subnet_Rapid7[0].traffic_mirror_target_id
  traffic_nic_id                = module.Subnet_Rapid7[0].traffic_nic_id
  internal_it_subnets           = module.networking[0].subnet_it_id
  internal_it_sg                = module.networking[0].sg_it_id
  Instance_Type_WIN11           = var.Instance_Type_WIN11
  ServerName_WIN11              = var.ServerName_WIN11_IT
  User_List_WIN11               = var.User_List_WIN11_IT
  Volume_Size_WIN11             = var.Volume_Size_WIN11
  webserver_ip                  = var.WebServer_IP_IT
  fileserver_ip                 = var.FileServer_IP_IT
  RODC_IP                       = var.RODC_IP
  win2K19_ip                    = var.Win2K19_IP_IT
  win2K22_ip                    = var.Win2K22_IP_IT
  AD_IP                         = var.AD_IP
  DHCP_IP                       = var.DHCP_IP
  IT_AWSGW                      = var.IT_AWSGW
  IT_GW                         = var.IT_GW
  IT_Mask                       = var.IT_Mask
  Owner_Email                   = "${var.Owner_Email}_${lower(var.Tenant)}"
  Agent_Type                    = var.Agent_Type
  InsightAppSec_Module          = var.InsightAppSec_Module
  InsightVM_Module              = var.InsightVM_Module
  InsightVM_Dummy_Data          = var.InsightVM_Dummy_Data
  InsightIDR_Module             = var.InsightIDR_Module
  InsightIDR_Dummy_Data         = var.InsightIDR_Dummy_Data
  InsightConnect_Module         = var.InsightConnect_Module
  NetworkSensor_Module          = var.NetworkSensor_Module
  SEOPS_VR_Install              = var.SEOPS_VR_Install
  ScriptList_ADDS01             = var.ScriptList_ADDS01
  ScriptList_2K19               = var.ScriptList_2K19
  ScriptList_2K22               = var.ScriptList_2K22
  ScriptList_WIN11              = var.ScriptList_WIN11
  ScriptList_LINUX              = var.ScriptList_LINUX
  ScriptList_WIN10              = var.ScriptList_WIN10
  ScriptList_FILESERVER         = var.ScriptList_FILESERVER
  ScriptList_WEBSERVER          = var.ScriptList_WEBSERVER
  ScriptList_DHCP               = var.ScriptList_DHCP
  Keyboard_Layout               = var.Keyboard_Layout
  Routing_Type                  = var.Routing_Type
  Deployment_Mode               = var.Deployment_Mode
  User_Lists                    = local.User_Lists
  FileServer_Module             = var.FileServer_IT_Module
  WebServer_Module              = var.WebServer_IT_Module
  Win2K19_Module                = var.Win2K19_IT_Module
  Win2K22_Module                = var.Win2K22_IT_Module
  DHCP_Module                   = var.DHCP_Module
  AD_Module                     = var.AD_Module
  VRM_License_Key               = var.VRM_License_Key
  depends_on                    = [module.s3]
  Win10_Module                  = var.Win10_IT_Module
  Win11_Module                  = var.Win11_IT_Module
  Ubu_Module                    = var.Ubu_IT_Module
  MSBLE_Win_Module              = var.MSBLE_Win_Module
  MSBLE_Ubu_Module              = var.MSBLE_Ubu_Module
  ubu_Mestaploitable_ip         = var.ubu_Mestaploitable_ip
  win_Mestaploitable_ip         = var.win_Mestaploitable_ip
  ServerName_Metasploitable_Ubu = var.ServerName_Metasploitable_Ubu
  ServerName_Metasploitable_Win = var.ServerName_Metasploitable_Win
  ami_windows_metasploitable    = data.aws_ami.windows_metasploitable.id
  ami_linux_metasploitable      = data.aws_ami.linux_metasploitable.id
  ZoneName                      = var.ZoneName
  PhishingName                  = var.PhishingName

}
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   HQ Subnet Module (RODC, DHCP, Servers (FileServer, WebServer, 2K19, 2K22, Linux), Workstations (10,11,linux))                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "Subnet_HQ" {
  count                      = var.Deployment_Mode == "limited" || var.Deployment_Mode == "none" || var.Deployment_Mode == "partial" || var.Deployment_Mode == "custom" || var.BootCamp_Mode == true ? 0 : 1
  source                     = "./Subnet_HQ"
  AWS_Region                 = var.AWS_Region
  R7_Region                  = var.R7_Region
  Tenant                     = var.Tenant
  JIRA_ID                    = var.JIRA_ID
  Bucket_Name                = module.s3[0].Bucket_Name
  Key_Name_Internal          = module.iam[0].Key_Name_Internal_id
  Key_Name_External          = module.iam[0].Key_Name_External_id
  Instance_Profile_Name      = module.iam[0].Instance_Profile_Name
  ami_ubuntu_20              = data.aws_ami.ubuntu20.id
  ami_ubuntu_22              = data.aws_ami.ubuntu22.id
  ami_windows_2k19           = data.aws_ami.windows2k19.id
  ami_windows_2k22           = data.aws_ami.windows2k22.id
  ami_windows_11             = data.aws_ami.windows11.id
  ami_windows_10             = data.aws_ami.windows10.id
  ServerName_2K19            = var.ServerName_2K19_HQ
  ServerName_2K22            = var.ServerName_2K22_HQ
  ServerName_FILESERVER      = var.ServerName_FILESERVER_HQ
  ServerName_WEBSERVER       = var.ServerName_WEBSERVER_HQ
  ServerName_RODC            = var.ServerName_RODC_HQ
  Instance_Type_AD           = var.Instance_Type_AD
  idr_service_account        = var.idr_service_account
  idr_service_account_pwd_ID = module.secrets_manager[0].sm_idr_service_account_pwd_arn
  Volume_Size_AD             = var.Volume_Size_AD
  Volume_Size_LINUX          = var.Volume_Size_LINUX
  User_List_LINUX            = var.User_List_LINUX_HQ
  Instance_Type_LINUX        = var.Instance_Type_LINUX
  Instance_Count_LINUX       = var.Instance_Count_LINUX
  ServerName_LINUX           = var.ServerName_LINUX_HQ
  Volume_Size_WIN10          = var.Volume_Size_WIN10
  Instance_Type_WIN10        = var.Instance_Type_WIN10
  User_List_WIN10            = var.User_List_WIN10_HQ
  Instance_Count_WIN10       = var.Instance_Count_WIN10
  ServerName_WIN10           = var.ServerName_WIN10_HQ
  TimeZoneID                 = var.TimeZoneID
  Token                      = var.Token
  SYSVOLPath                 = var.SYSVOLPath
  DomainMode                 = var.DomainMode
  DomainName                 = var.DomainName
  AdminSafeModePassword_ID   = module.secrets_manager[0].sm_AdminSafeModePassword_arn
  AdminPD_ID                 = module.secrets_manager[0].sm_AdminPD_arn
  AdminUser                  = var.AdminUser
  VR_Agent_File              = var.VR_Agent_File
  ForestMode                 = var.ForestMode
  LogPath                    = var.LogPath
  DatabasePath               = var.DatabasePath
  Coll_IP                    = var.Coll_IP
  Orch_IP                    = var.Orch_IP
  Password_ID                = module.secrets_manager[0].sm_Password_arn
  SiteName_HQ                = var.SiteName_HQ
  SiteName_RODC              = var.SiteName_RODC
  traffic_mirror_filter_id   = module.Subnet_Rapid7[0].traffic_mirror_filter_id
  traffic_mirror_target_id   = module.Subnet_Rapid7[0].traffic_mirror_target_id
  traffic_nic_id             = module.Subnet_Rapid7[0].traffic_nic_id
  internal_hq_subnets        = module.networking[0].subnet_hq_id
  internal_hq_sg             = module.networking[0].sg_hq_id
  Instance_Type_WIN11        = var.Instance_Type_WIN11
  Instance_Count_WIN11       = var.Instance_Count_WIN11
  ServerName_WIN11           = var.ServerName_WIN11_HQ
  User_List_WIN11            = var.User_List_WIN11_HQ
  Volume_Size_WIN11          = var.Volume_Size_WIN11
  webserver_ip               = var.WebServer_IP_HQ
  fileserver_ip              = var.FileServer_IP_HQ
  RODC_IP                    = var.RODC_IP
  win2K19_ip                 = var.Win2k19_IP_HQ
  win2K22_ip                 = var.Win2k22_IP_HQ
  AD_IP                      = var.AD_IP
  HQ_AWSGW                   = var.HQ_AWSGW
  HQ_GW                      = var.HQ_GW
  HQ_Mask                    = var.HQ_Mask
  Owner_Email                = "${var.Owner_Email}_${lower(var.Tenant)}"
  Agent_Type                 = var.Agent_Type
  InsightAppSec_Module       = var.InsightAppSec_Module
  InsightVM_Module           = var.InsightVM_Module
  InsightVM_Dummy_Data       = var.InsightVM_Dummy_Data
  InsightIDR_Module          = var.InsightIDR_Module
  InsightIDR_Dummy_Data      = var.InsightIDR_Dummy_Data
  InsightConnect_Module      = var.InsightConnect_Module
  NetworkSensor_Module       = var.NetworkSensor_Module
  SEOPS_VR_Install           = var.SEOPS_VR_Install
  ScriptList_RODC            = var.ScriptList_RODC
  ScriptList_2K19            = var.ScriptList_2K19
  ScriptList_2K22            = var.ScriptList_2K22
  ScriptList_WIN11           = var.ScriptList_WIN11
  ScriptList_LINUX           = var.ScriptList_LINUX
  ScriptList_WIN10           = var.ScriptList_WIN10
  ScriptList_FILESERVER      = var.ScriptList_FILESERVER
  ScriptList_WEBSERVER       = var.ScriptList_WEBSERVER
  ScriptList_DHCP            = var.ScriptList_DHCP
  Keyboard_Layout            = var.Keyboard_Layout
  Routing_Type               = var.Routing_Type
  Deployment_Mode            = var.Deployment_Mode
  User_Lists                 = local.User_Lists
  FileServer_Module          = var.FileServer_HQ_Module
  WebServer_Module           = var.WebServer_HQ_Module
  Win2K19_Module             = var.Win2K19_HQ_Module
  Win2K22_Module             = var.Win2K22_HQ_Module
  RODC_Module                = var.RODC_Module
  VRM_License_Key            = var.VRM_License_Key
  depends_on                 = [module.s3]
  Win10_Module               = var.Win10_HQ_Module
  Win11_Module               = var.Win11_HQ_Module
  Ubu_Module                 = var.Ubu_HQ_Module
  ZoneName                   = var.ZoneName
  PhishingName               = var.PhishingName

}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   Rapid7 Subnet Module (Orchestrator, Collector, InsightVM, IAS Engine, Network-Sensor, Honeypot, Log Generator)                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "Subnet_Rapid7" {
  count                         = var.Deployment_Mode == "limited" || var.Deployment_Mode == "none" || var.BootCamp_Mode == true ? 0 : 1
  source                        = "./Subnet_Rapid7"
  Tenant                        = var.Tenant
  Key_Name_Internal             = module.iam[0].Key_Name_Internal_id
  Key_Name_External             = module.iam[0].Key_Name_External_id
  vpc_id                        = module.networking[0].vpc_id
  Bucket_Name                   = module.s3[0].Bucket_Name
  AWS_Region                    = var.AWS_Region
  JIRA_ID                       = var.JIRA_ID
  R7_Region                     = var.R7_Region
  Instance_Profile_Name         = module.iam[0].Instance_Profile_Name
  Iam_Policy_Name               = var.Iam_Policy_Name
  Role_Name                     = var.Role_Name
  R7vpn_List                    = var.R7vpn_List
  ami_ubuntu_20                 = data.aws_ami.ubuntu20.id
  ami_ubuntu_22                 = data.aws_ami.ubuntu22.id
  ami_debian_12                 = data.aws_ami.debian12.id
  ami_windows_2k22              = data.aws_ami.windows2k22.id
  ami_centos_8                  = data.aws_ami.debian12.id
  ami_windows_11                = data.aws_ami.windows11.id
  ami_windows_10                = data.aws_ami.windows10.id
  TimeZoneID                    = var.TimeZoneID
  DomainName                    = var.DomainName
  Token                         = var.Token
  AdminUser                     = var.AdminUser
  AdminPD_ID                    = module.secrets_manager[0].sm_AdminPD_arn
  VR_Agent_File                 = var.VR_Agent_File
  Coll_IP                       = var.Coll_IP
  Coll_GW                       = var.Coll_GW
  Coll_Mask                     = var.Coll_Mask
  Orch_IP                       = var.Orch_IP
  Orch_GW                       = var.Orch_GW
  Orch_Mask                     = var.Orch_Mask
  NSensor_IP1                   = var.NSensor_IP1
  NSensor_IP2                   = var.NSensor_IP2
  NSensor_GW                    = var.NSensor_GW
  NSensor_Mask                  = var.NSensor_Mask
  Honeypot_IP                   = var.Honeypot_IP
  Loggen_IP                     = var.Loggen_IP
  Loggen_GW                     = var.Loggen_GW
  Loggen_Mask                   = var.Loggen_Mask
  IVM_IP1                       = var.IVM_IP1
  IVM_IP2                       = var.IVM_IP2
  IVM_GW                        = var.IVM_GW
  IVM_Mask                      = var.IVM_Mask
  IASEngine_IP                  = var.IASEngine_IP
  IASEngine_GW                  = var.IASEngine_GW
  IASEngine_Mask                = var.IASEngine_Mask
  ServerName_LOGGEN             = var.ServerName_LOGGEN
  Instance_Type_LOGGEN          = var.Instance_Type_LOGGEN
  Volume_Size_LOGGEN            = var.Volume_Size_LOGGEN
  ServerName_IASENGINE          = var.ServerName_IASENGINE
  Instance_Type_IASENGINE       = var.Instance_Type_IASENGINE
  Volume_Size_IASENGINE         = var.Volume_Size_IASENGINE
  Instance_Type_ORCHESTRATOR    = var.Instance_Type_ORCHESTRATOR
  Volume_Size_ORCHESTRATOR      = var.Volume_Size_ORCHESTRATOR
  ServerName_ORCHESTRATOR       = var.ServerName_ORCHESTRATOR
  Instance_Type_NSENSOR         = var.Instance_Type_NSENSOR
  Volume_Size_NSENSOR           = var.Volume_Size_NSENSOR
  ServerName_NSENSOR            = var.ServerName_NSENSOR
  aws_ami_honeypot              = data.aws_ami.honeypot.id
  Instance_Type_HONEYPOT        = var.Instance_Type_HONEYPOT
  Volume_Size_HONEYPOT          = var.Volume_Size_HONEYPOT
  ServerName_HONEYPOT           = var.ServerName_HONEYPOT
  Token_HONEYPOT                = var.Token_HONEYPOT
  Instance_Type_COLLECTOR       = var.Instance_Type_COLLECTOR
  Volume_Size_COLLECTOR         = var.Volume_Size_COLLECTOR
  ServerName_COLLECTOR          = var.ServerName_COLLECTOR
  Instance_Type_VRM_Console     = var.Instance_Type_VRM_Console
  Volume_Size_VRM_Console       = var.Volume_Size_VRM_Console
  ServerName_IVM                = var.ServerName_IVM
  subnet_rapid7_id              = module.networking[0].subnet_rapid7_id
  sg_rapid7_id                  = module.networking[0].sg_rapid7_id
  Rapid7_AWSGW                  = var.Rapid7_AWSGW
  NLB_Private_IP                = var.NLB_Private_IP
  Password_ID                   = module.secrets_manager[0].sm_Password_arn
  VRM_License_Key               = var.VRM_License_Key
  MachineType                   = var.MachineType
  VRM_ENGINE_IP                 = var.VRM_ENGINE_IP
  ServerName_VRM_ENGINE         = var.ServerName_VRM_ENGINE
  IVM_Console_Port              = var.IVM_Console_Port
  eni_dmz_public_id             = module.networking[0].eni_fw_public_id
  eni_fw_int_id                 = module.networking[0].eni_fw_int_id
  sg_fw_id                      = module.networking[0].sg_fw_id
  sg_fw_public_id               = module.networking[0].sg_fw_public_id
  sg_dmz_id                     = module.networking[0].sg_dmz_id
  sg_hq_id                      = module.networking[0].sg_hq_id
  sg_it_id                      = module.networking[0].sg_it_id
  sg_jumpbox_id                 = module.networking[0].sg_jumpbox_id
  Owner_Email                   = "${var.Owner_Email}_${lower(var.Tenant)}"
  Agent_Type                    = var.Agent_Type
  InsightAppSec_Module          = var.InsightAppSec_Module
  InsightAppSec_IAS_engine      = var.InsightAppSec_IAS_engine
  InsightVM_Module              = var.InsightVM_Module
  InsightVM_Dummy_Data          = var.InsightVM_Dummy_Data
  InsightIDR_Module             = var.InsightIDR_Module
  Honeypot_Module               = var.Honeypot_Module
  InsightIDR_Dummy_Data         = var.InsightIDR_Dummy_Data
  InsightConnect_Module         = var.InsightConnect_Module
  NetworkSensor_Module          = var.NetworkSensor_Module
  Routing_Type                  = var.Routing_Type
  Deployment_Mode               = var.Deployment_Mode
  Metasploit_IP                 = var.Metasploit_IP
  Metasploit_Mask               = var.Metasploit_Mask
  Metasploit_GW                 = var.Metasploit_GW
  Instance_Type_METASPLOIT      = var.Instance_Type_METASPLOIT
  Volume_Size_METASPLOIT        = var.Volume_Size_METASPLOIT
  ServerName_METASPLOIT         = var.ServerName_METASPLOIT
  Metasploit_Module             = var.Metasploit_Module
  SEOPS_VR_Install              = var.SEOPS_VR_Install
  use_route53_hz                = var.use_route53_hz
  Keyboard_Layout               = var.Keyboard_Layout
  ServerName_RODC_HQ            = var.ServerName_RODC_HQ
  ScriptList_LINUXCOLLECTOR     = var.ScriptList_LINUXCOLLECTOR
  ScriptList_VRM_CONSOLE_UBU    = var.ScriptList_VRM_CONSOLE_UBU
  ScriptList_NSENSOR            = var.ScriptList_NSENSOR
  ScriptList_LOGGEN             = var.ScriptList_LOGGEN
  ScriptList_IASENGINE          = var.ScriptList_IASENGINE
  ScriptList_ORCHESTRATOR       = var.ScriptList_ORCHESTRATOR
  ScriptList_METASPLOIT         = var.ScriptList_METASPLOIT
  SiteName_R7                   = var.SiteName_R7
  SiteName_RODC                 = var.SiteName_RODC
  RODC_IP                       = var.RODC_IP
  AD_IP                         = var.AD_IP
  idr_service_account_pwd_ID    = module.secrets_manager[0].sm_idr_service_account_pwd_arn
  idr_service_account           = var.idr_service_account
  AdminSafeModePassword_ID      = module.secrets_manager[0].sm_AdminSafeModePassword_arn
  User_Lists                    = local.User_Lists
  depends_on                    = [module.s3]
  ScriptList_IDR_WINCOLLECTOR   = var.ScriptList_IDR_WINCOLLECTOR
  SurfaceCommand_Module         = var.SurfaceCommand_Module
  ScriptList_OUTPOST            = var.ScriptList_OUTPOST
  Volume_Size_OUTPOST           = var.Volume_Size_OUTPOST
  ServerName_OUTPOST            = var.ServerName_OUTPOST
  Instance_Type_OUTPOST         = var.Instance_Type_OUTPOST
  Outpost_IP                    = var.Outpost_IP
  aws_lb_listener_webapps443_id = module.networking[0].aws_lb_listener_webapps443_id
  ZoneName                      = var.ZoneName
  Metasploit_Priority           = var.Metasploit_Priority
  aws_lb_alb_webapps_dnsname    = module.networking[0].aws_lb_alb_webapps_dnsname
  aws_lb_alb_webapps_zoneid     = module.networking[0].aws_lb_alb_webapps_zoneid
  Zone_ID                       = aws_route53_zone.selected.id
  aws_lb_alb_ivm_dnsname        = module.networking[0].aws_lb_alb_ivm_dnsname
  aws_lb_alb_ivm_zoneid         = module.networking[0].aws_lb_alb_ivm_zoneid
  aws_lb_listener_ivm443_id     = module.networking[0].aws_lb_listener_ivm443_id
  HCIVM_Priority                = var.HCIVM_Priority
  PhishingName                  = var.PhishingName
  IVMEngine_Module              = var.IVMEngine_Module
  IVMEngine_IP                  = var.IVMEngine_IP
  ScriptList_IVMENGINE          = var.ScriptList_IVMENGINE
  Volume_Size_IVMEngine         = var.Volume_Size_IVMEngine
  ServerName_IVMEngine          = var.ServerName_IVMEngine
  Instance_Type_IVMEngine       = var.Instance_Type_IVMEngine
}
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   WebAPPs Module for IAS WebApps (Webscantest..) and Global Apps (Jenkins..)                                                                                                                                                                                                                                                                                                   
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "webapps" {
  count                          = var.InsightAppSec_Module == false && var.Deployment_Mode == "partial" || var.InsightAppSec_Module == false && var.Deployment_Mode == "custom" || var.InsightAppSec_Module == false && var.Deployment_Mode == "limited" || var.Deployment_Mode == "none" || var.BootCamp_Mode == true ? 0 : 1
  source                         = "./Subnet_DMZ_Webapps"
  sg_dmz_id                      = module.networking[0].sg_dmz_id
  subnet_dmzwebapp1_id           = module.networking[0].subnet_dmzwebapp1_id
  subnet_dmzwebapp2_id           = module.networking[0].subnet_dmzwebapp2_id
  Tenant                         = var.Tenant
  Key_Name_Internal              = module.iam[0].Key_Name_Internal_id
  Key_Name_External              = module.iam[0].Key_Name_External_id
  Instance_Profile_Name          = module.iam[0].Instance_Profile_Name
  JIRA_ID                        = var.JIRA_ID
  DomainName                     = var.DomainName
  Bucket_Name                    = module.s3[0].Bucket_Name
  TimeZoneID                     = var.TimeZoneID
  Token                          = var.Token
  R7_Region                      = var.R7_Region
  Owner_Email                    = "${var.Owner_Email}_${lower(var.Tenant)}"
  Juice_Shop_Image               = var.Juice_Shop_Image
  Juice_Shop_Port                = var.Juice_Shop_Port
  Juice_Shop_Priority            = var.Juice_Shop_Priority
  Juice_Shop_CPU                 = var.Juice_Shop_CPU
  Juice_Shop_Memory              = var.Juice_Shop_Memory
  Hackazon_Image                 = var.Hackazon_Image
  Hackazon_Port                  = var.Hackazon_Port
  Hackazon_Priority              = var.Hackazon_Priority
  Hackazon_CPU                   = var.Hackazon_CPU
  Hackazon_Memory                = var.Hackazon_Memory
  Log4j_Image                    = var.Log4j_Image
  Log4j_Port                     = var.Log4j_Port
  Log4j_Priority                 = var.Log4j_Priority
  Log4j_CPU                      = var.Log4j_CPU
  Log4j_Memory                   = var.Log4j_Memory
  GraphQL_Image                  = var.GraphQL_Image
  GraphQL_Port                   = var.GraphQL_Port
  GraphQL_Priority               = var.GraphQL_Priority
  GraphQL_CPU                    = var.GraphQL_CPU
  GraphQL_Memory                 = var.GraphQL_Memory
  Jenkins_Image                  = var.Jenkins_Image
  Jenkins_Port                   = var.Jenkins_Port
  Jenkins_Priority               = var.Jenkins_Priority
  Jenkins_CPU                    = var.Jenkins_CPU
  Jenkins_Memory                 = var.Jenkins_Memory
  PetClinic_Image                = var.PetClinic_Image
  PetClinic_Port                 = var.PetClinic_Port
  PetClinic_Priority             = var.PetClinic_Priority
  PetClinic_CPU                  = var.PetClinic_CPU
  PetClinic_Memory               = var.PetClinic_Memory
  AWS_ECR_Repository_Name        = var.AWS_ECR_Repository_Name
  ecs_service_sg_id              = module.networking[0].ecs_service_sg_id
  aws_lb_listener_webapps80_id   = module.networking[0].aws_lb_listener_webapps80_id
  aws_lb_listener_webapps443_id  = module.networking[0].aws_lb_listener_webapps443_id
  aws_lb_listener_webapps8025_id = module.networking[0].aws_lb_listener_webapps8025_id
  aws_lb_alb_webapps_dnsname     = module.networking[0].aws_lb_alb_webapps_dnsname
  aws_lb_alb_webapps_zoneid      = module.networking[0].aws_lb_alb_webapps_zoneid
  ZoneName                       = var.ZoneName
  #Zone_ID                        = length(aws_route53_zone.selected) > 0 ? aws_route53_zone.selected[0].id : ""
  Zone_ID              = aws_route53_zone.selected.id
  AWS_Region           = var.AWS_Region
  vpc_id               = module.networking[0].vpc_id
  ami_ubuntu_22        = data.aws_ami.ubuntu22.id
  Instance_Type_DOCKER = var.Instance_Type_DOCKER
  Volume_Size_DOCKER   = var.Volume_Size_DOCKER
  ServerName_DOCKER    = var.ServerName_DOCKER
  Docker_IP            = var.Docker_IP
  AdminUser            = var.AdminUser
  AdminPD_ID           = module.secrets_manager[0].sm_AdminPD_arn
  Instance_GW          = var.DMZ_GW
  Instance_Mask        = var.DMZ_Mask
  Instance_AWSGW       = var.DMZ_AWSGW
  crAPI_Image          = var.crAPI_Image
  crAPI_Port_8888      = var.crAPI_Port_8888
  crAPI_Port_443       = var.crAPI_Port_443
  crAPI_Port_8025      = var.crAPI_Port_8025
  crAPI_Priority       = var.crAPI_Priority
  crAPI_CPU            = var.crAPI_CPU
  crAPI_Memory         = var.crAPI_Memory
  iasengine_list       = module.networking[0].ias_engine_prefix_id
  InsightAppSec_Module = var.InsightAppSec_Module
  use_route53_hz       = var.use_route53_hz
  depends_on           = [module.s3]
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   BootCamps                                                                                                                                                                                                                                                                                               
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "BootCamp" {
  for_each                            = var.BootCamp_Mode ? toset([for num in var.Number_BootCamps : tostring(num)]) : toset([])
  source                              = "./Bootcamp"
  Tenant                              = "${var.Tenant}-${each.key}"
  Lab_Number                          = each.key
  JIRA_ID                             = var.JIRA_ID
  R7_Region                           = var.R7_Region
  AWS_Region                          = var.AWS_Region
  Key_Name_External                   = "${var.Tenant}_${var.Key_Name_External}"
  Key_Name_Internal                   = "${var.Tenant}_${var.Key_Name_Internal}"
  Instance_Profile_Name               = "${var.R7_Region}-${var.Instance_Profile_Name}-${lower(var.Tenant)}-u${each.key}"
  Bucket_Name                         = "${var.R7_Region}-${var.Bucket_Name}-${lower("${var.Tenant}")}-user${each.key}"
  Instance_Type_LOGGEN                = var.Instance_Type_LOGGEN
  Volume_Size_LOGGEN                  = var.Volume_Size_LOGGEN
  ServerName_IASENGINE                = var.ServerName_IASENGINE
  Instance_Type_IASENGINE             = var.Instance_Type_IASENGINE
  Volume_Size_IASENGINE               = var.Volume_Size_IASENGINE
  Instance_Type_ORCHESTRATOR          = var.Instance_Type_ORCHESTRATOR
  Volume_Size_ORCHESTRATOR            = var.Volume_Size_ORCHESTRATOR
  Instance_Type_NSENSOR               = var.Instance_Type_NSENSOR
  Volume_Size_NSENSOR                 = var.Volume_Size_NSENSOR
  aws_ami_honeypot                    = data.aws_ami.honeypot.id
  Instance_Type_HONEYPOT              = var.Instance_Type_HONEYPOT
  Volume_Size_HONEYPOT                = var.Volume_Size_HONEYPOT
  BTCP_Token_HONEYPOT                 = element(var.BTCP_Tokens_HONEYPOT, each.key - 1)
  Instance_Type_COLLECTOR             = var.Instance_Type_COLLECTOR
  Volume_Size_COLLECTOR               = var.Volume_Size_COLLECTOR
  Instance_Type_VRM_Console           = var.Instance_Type_VRM_Console
  Volume_Size_VRM_Console             = var.Volume_Size_VRM_Console
  ServerName_IVM                      = var.ServerName_IVM
  ServerName_JUMPBOX                  = "${var.ServerName_JUMPBOX}-u${each.key}"
  Instance_Type_JUMPBOX               = var.Instance_Type_JUMPBOX
  Volume_Size_JUMPBOX                 = var.Volume_Size_JUMPBOX
  ami_ubuntu_20                       = data.aws_ami.ubuntu20.id
  ami_ubuntu_22                       = data.aws_ami.ubuntu22.id
  ami_windows_2k19                    = data.aws_ami.windows2k19.id
  ami_windows_2k22                    = data.aws_ami.windows2k22.id
  ami_windows_11                      = data.aws_ami.windows11.id
  ami_windows_10                      = data.aws_ami.windows10.id
  Instance_Type_WIN11                 = var.Instance_Type_WIN11
  Instance_Count_WIN11                = var.Instance_Count_WIN11
  ServerName_WIN11                    = var.ServerName_WIN11_HQ
  User_List_WIN11                     = var.User_List_WIN11_HQ
  Volume_Size_WIN11                   = var.Volume_Size_WIN11
  Volume_Size_WIN10                   = var.Volume_Size_WIN10
  Instance_Type_WIN10                 = var.Instance_Type_WIN10
  User_List_WIN10                     = var.User_List_WIN10_IT
  Instance_Count_WIN10                = var.Instance_Count_WIN10
  ServerName_WIN10                    = var.ServerName_WIN10_IT
  Volume_Size_LINUX                   = var.Volume_Size_LINUX
  User_List_LINUX                     = var.User_List_LINUX_IT
  Instance_Type_LINUX                 = var.Instance_Type_LINUX
  Instance_Count_LINUX                = var.Instance_Count_LINUX
  ServerName_LINUX                    = var.ServerName_LINUX_IT
  webserver_ip                        = var.WebServer_IP_IT
  fileserver_ip                       = var.FileServer_IP_IT
  win2K19_ip                          = var.Win2K19_IP_IT
  win2K22_ip                          = var.Win2K22_IP_IT
  Password                            = element(var.BTCP_AdminPD, each.key - 1)
  BTCP_VRM_License_Key                = element(var.BTCP_VRM_License_Keys, each.key - 1)
  MachineType                         = var.MachineType
  VRM_ENGINE_IP                       = var.VRM_ENGINE_IP
  ServerName_VRM_ENGINE               = var.ServerName_VRM_ENGINE
  TimeZoneID                          = var.TimeZoneID
  BTCP_Token                          = element(var.BTCP_Tokens, each.key - 1)
  SYSVOLPath                          = var.SYSVOLPath
  DomainMode                          = var.DomainMode
  DomainName                          = var.DomainName
  AdminSafeModePassword               = element(var.BTCP_AdminPD, each.key - 1)
  AdminPD                             = element(var.BTCP_AdminPD, each.key - 1)
  AdminUser                           = "${var.BTCP_AdminUser}${each.key}"
  VR_Agent_File                       = var.VR_Agent_File
  ForestMode                          = var.ForestMode
  LogPath                             = var.LogPath
  DatabasePath                        = var.DatabasePath
  SiteName                            = var.SiteName_BOOTCAMP
  SiteName_RODC                       = var.SiteName_RODC
  Instance_Type_METASPLOIT            = var.Instance_Type_METASPLOIT
  ServerName_FILESERVER               = var.ServerName_FILESERVER_IT
  BTCP_IVM_IP1                        = var.IVM_IP1
  BTCP_IVM_IP2                        = var.IVM_IP2
  BTCP_IASEngine_IP                   = var.IASEngine_IP
  Owner_Email                         = "${var.Owner_Email}_${lower(var.Tenant)}"
  ZoneName                            = var.ZoneName
  Keyboard_Layout                     = var.Keyboard_Layout
  ServerName_METASPLOIT               = var.ServerName_METASPLOIT
  Agent_Type                          = var.Agent_Type
  ServerName_2K22                     = var.ServerName_2K22_IT
  ServerName_2K19                     = var.ServerName_2K19_IT
  ServerName_AD                       = var.ServerName_AD_IT
  Instance_Type_AD                    = var.Instance_Type_AD
  Volume_Size_AD                      = var.Volume_Size_AD
  Volume_Size_METASPLOIT              = var.Volume_Size_METASPLOIT
  BTCP_Jumpbox_IP                     = var.BTCP_Jumpbox_IP
  BTCP_MS_IP                          = var.Metasploit_IP
  BTCP_JMP_GW                         = var.BTCP_JMP_GW
  BTCP_JMP_Mask                       = var.BTCP_JMP_Mask
  BTCP_JMP_AWSGW                      = var.BTCP_JMP_AWSGW
  ServerName_WEBSERVER                = var.ServerName_WEBSERVER_IT
  idr_service_account                 = "${var.BTCP_idr_service_account}${each.key}"
  idr_service_account_pwd             = element(var.BTCP_AdminPD, each.key - 1)
  Public_IP_Access                    = var.BTCP_Public_IP_Access
  Zone_ID                             = var.Zone_ID
  use_route53_hz                      = var.use_route53_hz
  InsightConnect_Module               = var.InsightConnect_Module
  InsightIDR_Dummy_Data               = var.InsightIDR_Dummy_Data
  InsightIDR_Module                   = var.InsightIDR_Module
  InsightVM_Dummy_Data                = var.InsightVM_Dummy_Data
  InsightVM_Module                    = var.InsightVM_Module
  IVM_Console_Port                    = var.IVM_Console_Port
  Metasploit_Module                   = var.Metasploit_Module
  NetworkSensor_Module                = var.NetworkSensor_Module
  ivm_target_group_arn                = "null"
  Honeypot_Module                     = var.Honeypot_Module
  SEOPS_VR_Install                    = var.SEOPS_VR_Install
  ScriptList_2K19                     = var.ScriptList_2K19
  ScriptList_2K22                     = var.ScriptList_2K22
  ScriptList_WIN11                    = var.ScriptList_WIN11
  ScriptList_WIN10                    = var.ScriptList_WIN10
  ScriptList_FILESERVER               = var.ScriptList_FILESERVER
  ScriptList_WEBSERVER                = var.ScriptList_WEBSERVER
  ScriptList_DHCP                     = var.ScriptList_DHCP
  ScriptList_JUMPBOX                  = var.ScriptList_JUMPBOX
  ScriptList_ADDS01                   = var.ScriptList_ADDS01
  ScriptList_LOGGEN                   = var.ScriptList_LOGGEN
  ScriptList_LINUXCOLLECTOR           = var.ScriptList_LINUXCOLLECTOR
  ScriptList_VRM_CONSOLE_UBU          = var.ScriptList_VRM_CONSOLE_UBU
  ScriptList_LINUX                    = var.ScriptList_LINUX
  ScriptList_METASPLOIT               = var.ScriptList_METASPLOIT
  ScriptList_NSENSOR                  = var.ScriptList_NSENSOR
  ScriptList_ORCHESTRATOR             = var.ScriptList_ORCHESTRATOR
  Deployment_Mode                     = var.Deployment_Mode
  Routing_Type                        = var.Routing_Type
  User_Lists                          = local.User_Lists
  Module_BootCamps_ICON               = var.Module_BootCamps_ICON
  Module_BootCamps_IVM                = var.Module_BootCamps_IVM
  Module_BootCamps_IAS                = var.Module_BootCamps_IAS
  Module_BootCamps_IDR                = var.Module_BootCamps_IDR
  BTCP_VRM_Console_Ubu                = var.BTCP_VRM_Console_Ubu
  BTCP_VRM_Console_Win                = var.BTCP_VRM_Console_Win
  BTCP_VRM_Scan_engine_Win            = var.BTCP_VRM_Scan_engine_Win
  BTCP_VRM_Scan_engine_Ubu            = var.BTCP_VRM_Scan_engine_Ubu
  BTCP_VRM_Target_Win_IPs             = var.BTCP_VRM_Target_Win_IPs
  BTCP_VRM_Target_Ubu_IPs             = var.BTCP_VRM_Target_Ubu_IPs
  ScriptList_VRM_ENGINE_UBU           = var.ScriptList_VRM_ENGINE_UBU
  BTCP_VRM_Console_Ubu_IP2            = var.BTCP_VRM_Console_Ubu_IP2
  ScriptList_VRM_ENGINE_WIN           = var.ScriptList_VRM_ENGINE_WIN
  Iam_Policy_Name                     = var.Iam_Policy_Name
  Instance_Type_VRM_ENGINE            = var.Instance_Type_VRM_ENGINE
  BTCP_VRM_ServerName_Scan_engine_Win = var.BTCP_VRM_ServerName_Scan_engine_Win
  BTCP_VRM_ServerName_Scan_Engine_Ubu = var.BTCP_VRM_ServerName_Scan_Engine_Ubu
  BTCP_VRM_Console_Win_IP2            = var.BTCP_VRM_Console_Win_IP2
  BTCP_VRM_ServerName_Scan_Target_Win = var.BTCP_VRM_ServerName_Scan_Target_Win
  BTCP_VRM_ServerName_Scan_Target_Ubu = var.BTCP_VRM_ServerName_Scan_Target_Ubu
  Volume_Size_VRM_ENGINE              = var.Volume_Size_VRM_ENGINE
  R7vpn_List                          = var.R7vpn_List
  BTCP_VRM_Mask                       = var.BTCP_VRM_Mask
  ami_debian_12                       = data.aws_ami.debian12
  BTCP_VRM_Console_Win_IP1            = var.BTCP_VRM_Console_Win_IP1
  ami_centos_8                        = data.aws_ami.debian12.id
  BTCP_VRM_GW                         = var.BTCP_VRM_GW
  BTCP_VRM_Engine_Win_IP              = var.BTCP_VRM_Engine_Win_IP
  BTCP_VRM_AWSGW                      = var.BTCP_VRM_AWSGW
  Acl_Value                           = var.Acl_Value
  ScriptList_VRM_CONSOLE_WIN          = var.ScriptList_VRM_CONSOLE_WIN
  BTCP_VRM_Dummy_Data                 = var.BTCP_VRM_Dummy_Data
  BTCP_VRM_ServerName_Console_Ubu     = var.BTCP_VRM_ServerName_Console_Ubu
  BTCP_VRM_ServerName_Console_Win     = var.BTCP_VRM_ServerName_Console_Win
  BTCP_VRM_SiteName                   = var.BTCP_VRM_SiteName
  Role_Name                           = var.Role_Name
  BTCP_VRM_Console_Ubu_IP1            = var.BTCP_VRM_Console_Ubu_IP1
  BTCP_VRM_Engine_Ubu_IP              = var.BTCP_VRM_Engine_Ubu_IP
  BTCP_VRM_Target_Win                 = var.BTCP_VRM_Target_Win
  Volume_Size_VRM_TARGET              = var.Volume_Size_VRM_TARGET
  ScriptList_VRM_TARGET_WIN           = var.ScriptList_VRM_TARGET_WIN
  ScriptList_VRM_TARGET_UBU           = var.ScriptList_VRM_TARGET_UBU
  Instance_Type_VRM_TARGET            = var.Instance_Type_VRM_TARGET
  BTCP_VRM_Target_Ubu                 = var.BTCP_VRM_Target_Ubu
  BTCP_IDR_Mask                       = var.BTCP_IDR_Mask
  BTCP_IDR_Orch_IP                    = var.BTCP_IDR_Orch_IP
  BTCP_IDR_NSensor_IP2                = var.BTCP_IDR_NSensor_IP2
  BTCP_IDR_DC_IP                      = var.BTCP_IDR_DC_IP
  BTCP_IDR_ServerName_Honeypot        = var.BTCP_IDR_ServerName_Honeypot
  BTCP_IDR_ServerName_Coll_Ubu        = var.BTCP_IDR_ServerName_Coll_Ubu
  NLB_Private_IP                      = var.BTCP_IDR_NLB_Private_IP
  BTCP_IDR_Honeypot                   = var.BTCP_IDR_Honeypot
  BTCP_IDR_ServerName_NSensor         = var.BTCP_IDR_ServerName_NSensor
  BTCP_IDR_AWSGW                      = var.BTCP_IDR_AWSGW
  BTCP_IDR_NSensor_IP1                = var.BTCP_IDR_NSensor_IP1
  BTCP_IDR_SiteName                   = var.BTCP_IDR_SiteName
  BTCP_IDR_ServerName_Orch            = var.BTCP_IDR_ServerName_Orch
  BTCP_IDR_ServerName_Loggen          = var.BTCP_IDR_ServerName_Loggen
  BTCP_IDR_Loggen                     = var.BTCP_IDR_Loggen
  BTCP_IDR_Coll_IP_Ubu                = var.BTCP_IDR_Coll_IP_Ubu
  BTCP_IDR_NSensor                    = var.BTCP_IDR_NSensor
  BTCP_IDR_Honeypot_IP                = var.BTCP_IDR_Honeypot_IP
  ScriptList_IDR_WINCOLLECTOR         = var.ScriptList_IDR_WINCOLLECTOR
  BTCP_IDR_Loggen_IP                  = var.BTCP_IDR_Loggen_IP
  BTCP_IDR_Orchestrator               = var.BTCP_IDR_Orchestrator
  BTCP_IDR_Collector_Ubu              = var.BTCP_IDR_Collector_Ubu
  BTCP_IDR_Collector_Win              = var.BTCP_IDR_Collector_Win
  BTCP_IDR_GW                         = var.BTCP_IDR_GW
  BTCP_IDR_ADDS01                     = var.BTCP_IDR_ADDS01
  BTCP_IDR_Target_Win                 = var.BTCP_IDR_Target_Win
  BTCP_IDR_Target_Ubu_IPs             = var.BTCP_IDR_Target_Ubu_IPs
  BTCP_IDR_Target_Ubu                 = var.BTCP_IDR_Target_Ubu
  ScriptList_IDR_TARGET_WIN           = var.ScriptList_IDR_TARGET_WIN
  BTCP_IDR_ServerName_Target_Ubu      = var.BTCP_IDR_ServerName_Target_Ubu
  BTCP_IDR_ServerName_ADDS01          = var.BTCP_IDR_ServerName_ADDS01
  ScriptList_IDR_TARGET_UBU           = var.ScriptList_IDR_TARGET_UBU
  BTCP_IDR_ServerName_Target_Win      = var.BTCP_IDR_ServerName_Target_Win
  BTCP_IDR_Target_Win_IPs             = var.BTCP_IDR_Target_Win_IPs
  BTCP_IDR_ServerName_Coll_Win        = var.BTCP_IDR_ServerName_Coll_Win
  BTCP_IDR_Coll_IP_Win                = var.BTCP_IDR_Coll_IP_Win
  SiteName_AD                         = var.SiteName_AD
  PhishingName                        = var.PhishingName
  depends_on                          = [module.s3]
}
