#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                               Rapid7 Subnet Orchestrator Main Definitions                                                                     #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Orchestrator                                                                                                                                                                                                                                                  
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_instance" "orchestrator_node" {
  instance_type           = var.instance_type
  ami                     = var.ami
  iam_instance_profile    = var.Instance_Profile_Name
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
#  EIP + Association                                                                                                                                                                                                                                                                    
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_eip_association" "eip_assoc_orchestrator_node" {
  instance_id   = aws_instance.orchestrator_node.id
  allocation_id = aws_eip.orchestrator_node.id
}
resource "aws_eip" "orchestrator_node" {
  domain = "vpc"
}
