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
  vpc_security_group_ids  = [var.external_sg]
  subnet_id               = var.external_subnets
  user_data               = var.user_data
  disable_api_termination = true
  root_block_device {
    volume_size = var.vol_size
  }
  tags = {
    "Name"        = "${var.Tenant} - DMZ - ${var.ServerName}"
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
  description     = "Traffic DMZ NIC"
  subnet_id       = var.external_subnets
  security_groups = [var.external_sg]
  private_ips     = [var.Instance_IP2]
  attachment {
    instance     = aws_instance.nsensor_node.id
    device_index = 1
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  EIP + Association                                                                                                                                                                                                                                                                    
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_eip_association" "eip_assoc_nsensor_node" {
  instance_id   = aws_instance.nsensor_node.id
  allocation_id = aws_eip.nsensor_node.id
}
resource "aws_eip" "nsensor_node" {
  domain = "vpc"
}
