#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                             Rapid7 Subnet Traffic Mirroring Main Definitions             s                                                     #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Network Load Balancer                                                                                                                                                                                          
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_lb" "traffic-mirrorin-nlb" {
  name                       = "${var.Tenant}-NLB-TM"
  internal                   = true
  load_balancer_type         = "network"
  security_groups            = [aws_security_group.traffic-mirroring-nlb-SG.id]
  enable_deletion_protection = false
  subnet_mapping {
    subnet_id            = var.subnet_rapid7_id
    private_ipv4_address = var.NLB_Private_IP
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Network Load Balancer - Target Group                                                                                                                                                                                          
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_lb_target_group" "tm-nlb-target-group" {

  name        = "${var.Tenant}-NLB-target-group"
  port        = 4789
  protocol    = "UDP"
  target_type = "ip"
  vpc_id      = var.vpc_id
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Network Load Balancer - Listener                                                                                                                                                                                      
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_lb_listener" "traffic-mirrorin-nlb-listener" {
  load_balancer_arn = aws_lb.traffic-mirrorin-nlb.arn
  port              = 4789
  protocol          = "UDP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tm-nlb-target-group.arn
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Network Load Balancer - Target Group Attachment                                                                                                                                                                                      
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_lb_target_group_attachment" "tm-nlb-target-group-attachment" {
  target_group_arn = aws_lb_target_group.tm-nlb-target-group.arn
  target_id        = var.traffic_nic_ip

}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Network Load Balancer - Filter                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_ec2_traffic_mirror_filter" "filter" {
  description = "${var.Tenant} NLB Traffic mirror filter"
  tags = {
    "Name"        = "${var.Tenant}-NLB-Filter"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Network Load Balancer - RuleIn                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_ec2_traffic_mirror_filter_rule" "rulein" {
  description              = "${var.Tenant}-NLB-Filter-In"
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.filter.id
  destination_cidr_block   = "0.0.0.0/0"
  source_cidr_block        = "0.0.0.0/0"
  rule_number              = 1
  rule_action              = "accept"
  traffic_direction        = "ingress"
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Network Load Balancer - RuleOut                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_ec2_traffic_mirror_filter_rule" "ruleout" {
  description              = "${var.Tenant}-NLB-Filter-Out"
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.filter.id
  destination_cidr_block   = "0.0.0.0/0"
  source_cidr_block        = "0.0.0.0/0"
  rule_number              = 1
  rule_action              = "accept"
  traffic_direction        = "egress"
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Network Load Balancer - Target                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_ec2_traffic_mirror_target" "target" {
  network_load_balancer_arn = aws_lb.traffic-mirrorin-nlb.arn
  tags = {
    "Name"        = "${var.Tenant}-NLB-Target"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Security Group                                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_security_group" "traffic-mirroring-nlb-SG" {
  name        = "${var.Tenant}-NLB-SG"
  description = "${var.Tenant}-NLB-TM-SG"
  vpc_id      = var.vpc_id
  tags = {
    "Name"        = "${var.Tenant}-NLB-SG"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Security Group Rules                                                                                                                                                                                           
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_security_group_rule" "NLB-R7" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = aws_security_group.traffic-mirroring-nlb-SG.id
  security_group_id        = var.sg_rapid7_id
}
# resource "aws_security_group_rule" "NSENSOR-NLB" {
#   type                      = "ingress"
#   from_port                 = 0
#   to_port                   = 0
#   protocol                  = -1
#   source_security_group_id  = aws_security_group.traffic-mirroring-nlb-SG.id
#   security_group_id         = var.sg_rapid7_id
# }
resource "aws_security_group_rule" "R7-NLB" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = var.sg_rapid7_id
  security_group_id        = aws_security_group.traffic-mirroring-nlb-SG.id
}
resource "aws_security_group_rule" "FW-NLB" {
  count                    = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = var.sg_fw_id
  security_group_id        = aws_security_group.traffic-mirroring-nlb-SG.id
}
resource "aws_security_group_rule" "FWPub-NLB" {
  count                    = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = var.sg_fw_public_id
  security_group_id        = aws_security_group.traffic-mirroring-nlb-SG.id
}
resource "aws_security_group_rule" "DMZ-NLB" {
  count                    = var.Deployment_Mode != "limited" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = var.sg_dmz_id
  security_group_id        = aws_security_group.traffic-mirroring-nlb-SG.id
}
resource "aws_security_group_rule" "HQ-NLB" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "partial" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = var.sg_hq_id
  security_group_id        = aws_security_group.traffic-mirroring-nlb-SG.id
}
resource "aws_security_group_rule" "IT-NLB" {
  count                    = var.Deployment_Mode != "limited" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = var.sg_it_id
  security_group_id        = aws_security_group.traffic-mirroring-nlb-SG.id
}
resource "aws_security_group_rule" "JUMP-NLB" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = var.sg_jumpbox_id
  security_group_id        = aws_security_group.traffic-mirroring-nlb-SG.id
}
resource "aws_security_group_rule" "Egress-NLB" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.traffic-mirroring-nlb-SG.id
}
