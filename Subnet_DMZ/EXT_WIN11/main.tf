#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                   Subnet IT Windows 11 Main Definitions                                                                       #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Windows 11                                                                                                                                                                                                                                                    
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_instance" "win11_node" {
  instance_type           = var.instance_type
  ami                     = var.ami
  iam_instance_profile    = var.iam_instance_profile
  disable_api_termination = true
  private_ip              = var.Instance_IP
  key_name                = var.key_name
  vpc_security_group_ids  = [var.external_sg]
  subnet_id               = var.external_subnets
  user_data               = var.user_data
  root_block_device {
    volume_size = var.vol_size
  }
  tags = {
    "Name"        = "${var.Tenant} - DMZ - Workstation - Win11 - ${var.User_Account}"
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
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  EIP + Association                                                                                                                                                                                                                                                                    
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_eip_association" "eip_assoc_win11_node" {
  instance_id   = aws_instance.win11_node.id
  allocation_id = aws_eip.win11_node.id
}
resource "aws_eip" "win11_node" {
  domain = "vpc"
}
