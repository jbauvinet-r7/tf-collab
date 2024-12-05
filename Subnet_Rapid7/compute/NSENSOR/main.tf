#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                               Rapid7 Subnet Network Sensor Main    Definitions                                                                #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Network Sensor                                                                                                                                                                                                                                                  
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_instance" "nsensor_node" {
  instance_type           = var.instance_type
  ami                     = var.ami
  iam_instance_profile    = var.Instance_Profile_Name
  private_ip              = var.Instance_IP1
  key_name                = var.key_name
  vpc_security_group_ids  = [var.internal_sg]
  subnet_id               = var.internal_subnets
  user_data               = var.user_data
  disable_api_termination = true
  root_block_device {
    volume_size = var.vol_size
  }
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
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  NIC Network Interface                                                                                                                                                                                                                                                  
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_network_interface" "traffic_nic" {
  description     = "Traffic NIC"
  subnet_id       = var.internal_subnets
  security_groups = [var.internal_sg]
  private_ips     = [var.Instance_IP2]
  attachment {
    instance     = aws_instance.nsensor_node.id
    device_index = 1
  }
}
