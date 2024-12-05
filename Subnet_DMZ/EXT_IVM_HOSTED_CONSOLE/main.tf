#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                             DMZ Ext HC InsightVM Main                                                                         #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Hosted InsightVM Console                                                                                                                                                                                                                                                                    
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_instance" "hosted_console_node" {
  count                       = var.Hosted_Console_Mode == true ? 1 : 0
  instance_type               = var.instance_type
  associate_public_ip_address = true
  disable_api_termination     = true
  ami                         = var.ami
  iam_instance_profile        = var.Instance_Profile_Name
  private_ip                  = var.Instance_IP
  tags = {
    "Name"        = "${var.Tenant} - DMZ - ${var.ServerName}"
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
resource "aws_eip_association" "eip_assoc_hcivm" {
  count         = var.Hosted_Console_Mode == true ? 1 : 0
  instance_id   = aws_instance.hosted_console_node[count.index].id
  allocation_id = aws_eip.ext_hosted_console_node[count.index].id
}
resource "aws_eip" "ext_hosted_console_node" {
  count  = var.Hosted_Console_Mode == true ? 1 : 0
  domain = "vpc"
}

# #-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# #  Route 53 Records                                                                                                                                                                                                                                                                 
# #-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# resource "aws_route53_record" "hc_console" {
#   count   = var.use_route53_hz == true ? 1 : 0
#   zone_id = var.selected_Zone_ID
#   name    = "ivm.${var.ZoneName}"
#   type    = "A"
#   ttl     = 300
#   records = [aws_eip.ext_hosted_console_node[count.index].public_ip]
# }

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
  name        = "${var.Tenant}-WebApps-hvivm-tg"
  port        = var.private_port
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
  target_id        = one(aws_instance.hosted_console_node[*].id)
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
