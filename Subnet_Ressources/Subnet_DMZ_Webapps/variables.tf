#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                             DMZ WebApps Variables                                                                             #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Environement                                                                                                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "Tenant" {}
variable "JIRA_ID" {}
variable "DomainName" {}
variable "TimeZoneID" {}
variable "Token" {}
variable "R7_Region" {}
variable "Bucket_Name" {}
variable "Owner_Email" {}
variable "ZoneName" {}
variable "Zone_ID" {}
variable "AWS_Region" {}
variable "AdminUser" {}
variable "AdminPD_ID" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Features                                                                                                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "InsightAppSec_Module" {}
variable "use_route53_hz" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Networking                                                                                                                                                                                                            
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "vpc_id" {}
variable "subnet_dmzwebapp1_id" {}
variable "subnet_dmzwebapp2_id" {}
variable "ecs_service_sg_id" {}
variable "sg_dmz_id" {}
variable "iasengine_list" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Application Load Balancer                                                                                                                                                                                                               
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "aws_lb_listener_webapps80_id" {}
variable "aws_lb_listener_webapps443_id" {}
variable "aws_lb_listener_webapps8025_id" {}
variable "aws_lb_alb_webapps_dnsname" {}
variable "aws_lb_alb_webapps_zoneid" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   IAM Module (IAM Role, Instance Profile, Policy, Instance Certificates)                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "Key_Name_External" {}
variable "Key_Name_Internal" {}
variable "Instance_Profile_Name" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   WebAPPs Module for IAS WebApps (Webscantest..) and Global Apps (Jenkins..)                                                                                                                                                                                                                                                                                                   
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Global #############
variable "AWS_ECR_Repository_Name" {}

############# Juice Shop #############
variable "Juice_Shop_Image" {}
variable "Juice_Shop_Port" {}
variable "Juice_Shop_Priority" {}
variable "Juice_Shop_CPU" {}
variable "Juice_Shop_Memory" {}

############# Log4j #############
variable "Log4j_Image" {}
variable "Log4j_Port" {}
variable "Log4j_Priority" {}
variable "Log4j_CPU" {}
variable "Log4j_Memory" {}

############# Hackazon #############
variable "Hackazon_Image" {}
variable "Hackazon_Port" {}
variable "Hackazon_Priority" {}
variable "Hackazon_CPU" {}
variable "Hackazon_Memory" {}

############# GraphQL #############
variable "GraphQL_Image" {}
variable "GraphQL_Port" {}
variable "GraphQL_Priority" {}
variable "GraphQL_CPU" {}
variable "GraphQL_Memory" {}

############# Docker #############
variable "Instance_Type_DOCKER" {}
variable "Volume_Size_DOCKER" {}
variable "Docker_IP" {}
variable "ServerName_DOCKER" {}
variable "Instance_Mask" {}
variable "Instance_GW" {}
variable "Instance_AWSGW" {}

############# crAPI #############
variable "crAPI_Image" {}
variable "crAPI_Port_8888" {}
variable "crAPI_Port_443" {}
variable "crAPI_Port_8025" {}
variable "crAPI_Priority" {}
variable "crAPI_CPU" {}
variable "crAPI_Memory" {}

############# Jenkins #############
variable "Jenkins_Image" {}
variable "Jenkins_Port" {}
variable "Jenkins_Priority" {}
variable "Jenkins_CPU" {}
variable "Jenkins_Memory" {}

############# PetClinic #############
variable "PetClinic_Image" {}
variable "PetClinic_Port" {}
variable "PetClinic_Priority" {}
variable "PetClinic_CPU" {}
variable "PetClinic_Memory" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  AMIs                                                                                                                                                                                                                                                         
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "ami_ubuntu_22" {}
