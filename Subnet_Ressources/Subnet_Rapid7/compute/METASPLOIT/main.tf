#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                               Rapid7 Subnet Metasploit Main Definitions                                                                       #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Metasploit                                                                                                                                                                                                                         
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_instance" "metasploit_node" {
  instance_type           = var.instance_type
  disable_api_termination = true
  ami                     = var.ami
  iam_instance_profile    = var.Instance_Profile_Name
  private_ip              = var.Instance_IP
  tags = {
    "Name"        = "${var.Tenant} - Rapid7 - ${var.ServerName}"
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

#  ALB Target Group                                                                                                                                                                                                               
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_lb_target_group" "metasploit" {
  count       = var.Metasploit_Module == true && var.use_route53_hz == true ? 1 : 0
  name        = "${var.Tenant}-Metasploit-tg"
  port        = "3790"
  protocol    = "HTTPS"
  vpc_id      = var.vpc_id
  target_type = "instance"
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTPS"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

resource "aws_lb_listener_rule" "ms" {
  count        = var.Metasploit_Module == true && var.use_route53_hz == true ? 1 : 0
  listener_arn = var.aws_lb_listener_webapps443_id
  priority     = var.Metasploit_Priority

  action {
    type             = "forward"
    target_group_arn = one(aws_lb_target_group.metasploit[*].arn)
  }
  condition {
    host_header {
      values = ["ms.${var.ZoneName}"]
    }
  }
}

resource "aws_route53_record" "cname_route53_record_metasploit" {
  count   = var.Metasploit_Module == true && var.use_route53_hz == true ? 1 : 0
  zone_id = var.Zone_ID
  name    = "ms.${var.ZoneName}" # Replace with your subdomain, Note: not valid with "apex" domains, e.g. example.com
  type    = "A"
  alias {
    name                   = "dualstack.${var.aws_lb_alb_webapps_dnsname}"
    zone_id                = var.aws_lb_alb_webapps_zoneid
    evaluate_target_health = false
  }
}
resource "aws_lb_target_group_attachment" "ms" {
  target_group_arn = one(aws_lb_target_group.metasploit[*].arn)
  target_id        = aws_instance.metasploit_node.id
  port             = 3790
}
