#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                               Rapid7 Subnet Honeypot Main Definitions                                                                         #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Honeypot                                                                                                                                                                                                                         
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_instance" "honeypot_node" {
  instance_type           = var.instance_type
  ami                     = var.ami
  private_ip              = var.Instance_IP
  disable_api_termination = true
  tags = {
    "Name"        = "${var.Tenant} - IDR_Subnet - ${var.ServerName}"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "${var.Lab_Number}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
  key_name               = var.key_name
  vpc_security_group_ids = [var.internal_sg]
  subnet_id              = var.internal_subnets
  user_data              = var.user_data
  root_block_device {
    volume_size = var.vol_size
  }
  metadata_options {
    instance_metadata_tags = "enabled"
  }
  lifecycle {
    ignore_changes = [ami]
  }
}
