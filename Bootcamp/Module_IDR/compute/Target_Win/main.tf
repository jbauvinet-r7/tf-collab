#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                   Subnet IT Windows 2K22 Main Definitions                                                                     #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Target Windows                                                                                                                                                                                                                                                    
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_instance" "target_windows_node" {
  instance_type           = var.instance_type
  ami                     = var.ami
  iam_instance_profile    = var.iam_instance_profile
  disable_api_termination = true
  private_ip              = var.Instance_IP
  tags = {
    "Name"        = "${var.Tenant} - IDR_Subnet - ${var.User_Account}"
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
  # lifecycle {
  #   ignore_changes = [ami]
  # }
}