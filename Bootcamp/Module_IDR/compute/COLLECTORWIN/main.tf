#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                               Rapid7 Subnet Log Generator Main Definitions                                                                    #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Log Generator                                                                                                                                                                                                                                          
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_instance" "collector_win_node" {
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
    "Name"        = "${var.Tenant} - IDR_Subnet - ${var.ServerName}"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "${var.Lab_Number}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
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
