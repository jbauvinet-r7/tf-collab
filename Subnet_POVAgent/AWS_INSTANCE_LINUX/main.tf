#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                             DMZ Ext AWS Linux Main                                                                            #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  External AWS Linux                                                                                                                                                                                                                                                                       
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_instance" "ext_awslinux_node" {
  count                       = var.POVAgent_Module == true ? 1 : 0
  instance_type               = var.instance_type
  disable_api_termination     = true
  associate_public_ip_address = true
  ami                         = var.ami
  iam_instance_profile        = var.Instance_Profile_Name[0]
  private_ip                  = var.Instance_IP
  tags = {
    "Name"        = "${var.Tenant} - Amazon Linux - ${var.ServerName}"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
  key_name               = var.key_name
  vpc_security_group_ids = [var.external_sg]
  subnet_id              = var.external_subnets
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

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  EIP + Association                                                                                                                                                                                                                                                                    
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_eip_association" "eip_assoc_excol" {
  count         = var.POVAgent_Module == true ? 1 : 0
  instance_id   = aws_instance.ext_awslinux_node[count.index].id
  allocation_id = aws_eip.ext_awslinux_node[count.index].id
}
resource "aws_eip" "ext_awslinux_node" {
  count  = var.POVAgent_Module == true ? 1 : 0
  domain = "vpc"
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Route 53 Records                                                                                                                                                                                                                                                                 
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_route53_record" "awscli_instance" {
  count   = var.use_route53_hz == true ? 1 : 0
  zone_id = var.selected_Zone_ID
  name    = "awscli.${var.ZoneName}"
  type    = "A"
  ttl     = 300
  records = [aws_eip.ext_awslinux_node[count.index].public_ip]
}
