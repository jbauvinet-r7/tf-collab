#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                   Subnet IT WebServer Main Definitions                                                                        #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  WebServer                                                                                                                                                                                                                                                
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_instance" "webserver_node" {
  instance_type           = var.instance_type
  ami                     = var.ami
  iam_instance_profile    = var.iam_instance_profile
  disable_api_termination = true
  private_ip              = var.Instance_IP
  tags = {
    "Name"        = "${var.Tenant} - IT - Server - ${var.ServerName}"
    "Tenant"      = "${var.Tenant}"
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
