#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                               Rapid7 Subnet InsightVM Main Definitions                                                                        #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  InsightVM                                                                                                                                                                                                                                       
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_instance" "console_instance" {
  instance_type           = var.instance_type
  ami                     = var.ami
  private_ip              = var.Instance_IP1
  disable_api_termination = true
  key_name                = var.key_name
  vpc_security_group_ids  = [var.internal_sg]
  subnet_id               = var.internal_subnets
  user_data               = var.user_data
  iam_instance_profile    = var.Instance_Profile_Name
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
resource "aws_network_interface" "alb_nic_ivm" {
  description     = "ALB NIC"
  subnet_id       = var.internal_subnets
  security_groups = [var.internal_sg]
  private_ips     = ["10.0.7.11"]
  attachment {
    instance     = aws_instance.console_instance.id
    device_index = 1
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  ALB Lister Rule                                                                                                                                                                                                       
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Hosted Console #############
resource "aws_lb_listener_rule" "hosted_console" {
  count        = var.Deployment_Mode != "limited" && var.use_route53_hz == true ? 1 : 0
  listener_arn = var.aws_lb_listener_ivm443_id
  priority     = var.HCIVM_Priority
  action {
    type             = "forward"
    target_group_arn = one(aws_lb_target_group.hvivm[*].arn)
  }
  condition {
    host_header {
      values = ["ivm.${var.ZoneName}"]
    }
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  ALB Target Group                                                                                                                                                                                                                                                          
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_lb_target_group" "hvivm" {
  count       = var.Deployment_Mode != "limited" && var.use_route53_hz == true ? 1 : 0
  name        = "${var.Tenant}-ivm-tg"
  port        = var.IVM_Console_Port
  protocol    = "HTTPS"
  vpc_id      = var.vpc_id
  target_type = "instance"
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTPS"
    matcher             = "200"
    timeout             = "3"
    path                = "/login.jsp"
    unhealthy_threshold = "2"
    port                = "3780"
  }
}
resource "aws_lb_target_group_attachment" "ivm" {
  target_group_arn = one(aws_lb_target_group.hvivm[*].arn)
  target_id        = one(aws_instance.console_instance[*].id)
  port             = 3780
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Route 53 Records                                                                                                                                                                                                                                                   
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_route53_record" "cname_route53_record" {
  count   = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" && var.use_route53_hz == true ? 1 : 0
  zone_id = var.selected_Zone_ID
  name    = "ivm.${var.ZoneName}" # Replace with your subdomain, Note: not valid with "apex" domains, e.g. example.com
  type    = "A"
  alias {
    name                   = "dualstack.${var.aws_lb_alb_ivm_dnsname}"
    zone_id                = var.aws_lb_alb_ivm_zoneid
    evaluate_target_health = false
  }
}
