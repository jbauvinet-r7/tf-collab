#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                             Rapid7 Subnet Orchestrator Variables Definitions                                                                  #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Environement                                                                                                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "Tenant" {}
variable "JIRA_ID" {}
variable "Owner_Email" {}
variable "TimeZoneID" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#   IAM Module (IAM Role, Instance Profile, Policy, Instance Certificates)                                                                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "Instance_Profile_Name" {}
variable "key_name" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Networking                                                                                                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "external_sg" {}
variable "external_subnets" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Orchestrator                                                                                                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "ServerName" {}
variable "Instance_IP" {}
variable "user_data" {}
variable "instance_type" {}
variable "vol_size" {}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  AMI                                                                                                                                                                                                                                                       
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
variable "ami" {}