#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                             Firewall Main                                                                                     #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Firewall External                                                                                                                                                                                                                                                                   
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_instance" "firewall_external_node" {
  ami                     = var.ami
  instance_type           = var.instance_type
  key_name                = var.Key_Name_External
  disable_api_termination = true
  iam_instance_profile    = var.Instance_Profile_Name
  user_data               = var.user_data
  network_interface {
    network_interface_id = var.eni_fw_public_id
    device_index         = 0
  }
  tags = {
    "Name"        = "${var.Tenant} - Firewall - External - ${var.ServerName}"
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
#  Firewall Internal                                                                                                                                                                                                                                                                   
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_instance" "firewall_internal_node" {
  ami                     = var.ami
  instance_type           = var.instance_type
  key_name                = var.Key_Name_Internal
  disable_api_termination = true
  iam_instance_profile    = var.Instance_Profile_Name
  user_data               = var.user_data
  network_interface {
    network_interface_id = var.eni_fw_int_id
    device_index         = 0
  }
  tags = {
    "Name"        = "${var.Tenant} - Firewall - Internal - ${var.ServerName}"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
  lifecycle {
    ignore_changes = [ami]
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  EIP + EIP Association                                                                                                                                                                                                                                                                  
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_eip" "firewall_external_node" {
  domain = "vpc"
}
resource "aws_eip_association" "eip_assoc_fw_ext" {
  network_interface_id = var.eni_fw_public_id
  allocation_id        = aws_eip.firewall_external_node.id
  depends_on           = [aws_instance.firewall_external_node]

}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Route 53 Records                                                                                                                                                                                                                                                                 
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_route53_record" "firewall" {
  count   = var.use_route53_hz == true ? 1 : 0
  zone_id = var.selected_Zone_ID
  name    = "firewall.${var.ZoneName}"
  type    = "A"
  ttl     = 300
  records = [aws_eip.firewall_external_node.public_ip]
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Network Interface Attachment                                                                                                                                                                                                                                                               
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_network_interface_attachment" "fw_publicprivate" {
  instance_id          = aws_instance.firewall_external_node.id
  network_interface_id = var.eni_fw_publicprivate_id
  device_index         = 3
}
resource "aws_network_interface_attachment" "dmz" {
  instance_id          = aws_instance.firewall_external_node.id
  network_interface_id = var.eni_dmz_id
  device_index         = 1
}
# resource "aws_network_interface_attachment" "dmz-int-ext" {
#   instance_id               = aws_instance.firewall_internal_node.id
#   network_interface_id      = var.eni-DMZ-int-id
#   device_index              = 2
# }
resource "aws_network_interface_attachment" "jumpbox" {
  instance_id          = aws_instance.firewall_external_node.id
  network_interface_id = var.eni_jumpbox_id
  device_index         = 2
}
resource "aws_network_interface_attachment" "it" {
  instance_id          = aws_instance.firewall_internal_node.id
  network_interface_id = var.eni_it_id
  device_index         = 1
}
resource "aws_network_interface_attachment" "hq" {
  count                = var.Deployment_Mode != "limited" && var.Deployment_Mode != "partial" ? 1 : 0
  instance_id          = aws_instance.firewall_internal_node.id
  network_interface_id = var.eni_hq_id
  device_index         = 2
}
resource "aws_network_interface_attachment" "rapid7" {
  instance_id          = aws_instance.firewall_internal_node.id
  network_interface_id = var.eni_rapid7_id
  device_index         = 3
}
