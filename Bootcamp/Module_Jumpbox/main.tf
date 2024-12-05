#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                     Jumpbox Subnet Main Definitions                                                                           #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  AWS Instance                                                                                                                                                                                                                                                   
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_instance" "jumpbox_node" {
  ami                     = var.ami
  instance_type           = var.instance_type
  key_name                = var.key_name
  subnet_id               = var.external_subnets
  private_ip              = var.Instance_IP
  vpc_security_group_ids  = [var.external_sg]
  disable_api_termination = true
  iam_instance_profile    = var.iam_instance_profile
  user_data               = var.user_data
  tags = {
    "Name"        = "${var.Tenant} - Jumpbox - ${var.ServerName}"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "Jumpbox"
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

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Network Interface                                                                                                                                                                                                                                       
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_network_interface" "jumpbox_public_eni" {
  description       = "JUMPBOX-PUBLIC-ENI"
  subnet_id         = var.external_subnets
  private_ips       = ["10.0.1.101"]
  security_groups   = [var.external_sg]
  source_dest_check = false
  tags = {
    "Name"        = "${var.Tenant} - Jumpbox - ${var.ServerName}"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "Jumpbox"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Network Interface Attachment                                                                                                                                                                                                                                       
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_network_interface_attachment" "jumpbox" {
  instance_id          = aws_instance.jumpbox_node.id
  network_interface_id = aws_network_interface.jumpbox_public_eni.id
  device_index         = 1
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  EIP + EIP Association                                                                                                                                                                                                                                                                  
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_eip_association" "eip_assoc_jump" {
  network_interface_id = aws_network_interface.jumpbox_public_eni.id
  allocation_id        = aws_eip.jumpbox_node.id
}
resource "aws_eip" "jumpbox_node" {
  domain = "vpc"
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Route 53 Records                                                                                                                                                                                                                                                                 
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_route53_record" "rdp" {
  count   = var.use_route53_hz == true ? 1 : 0
  zone_id = var.selected_Zone_ID
  name    = "user${var.Lab_Number}.${var.ZoneName}"
  type    = "A"
  ttl     = 300
  records = [aws_eip.jumpbox_node.public_ip]
}
