#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                               Rapid7 Subnet IAS Engine Main Definitions                                                                       #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  IAS Engine                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_instance" "IASEngine_node" {
  ami                     = var.ami
  instance_type           = var.instance_type
  key_name                = var.key_name
  subnet_id               = var.internal_subnets
  private_ip              = var.Instance_IP
  vpc_security_group_ids  = [var.internal_sg]
  disable_api_termination = true
  iam_instance_profile    = var.Instance_Profile_Name
  user_data               = var.user_data
  tags = {
    "Name"        = "${var.Tenant} - Rapid7 - ${var.ServerName}"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
  metadata_options {
    instance_metadata_tags = "enabled"
  }
  lifecycle {
    ignore_changes = [ami]
  }
  root_block_device {
    volume_size = var.vol_size
  }
}
