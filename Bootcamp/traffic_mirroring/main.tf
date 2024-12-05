resource "aws_ec2_traffic_mirror_filter" "filter" {
  description = "Traffic mirror filter"
  tags = {
    "Name" = "${var.Tenant}-Filter"
    "Tenant" : "${var.Tenant}"
    "JIRA_ID" : "${var.JIRA_ID}"
  }
}

resource "aws_ec2_traffic_mirror_filter_rule" "ruleout" {
  description              = "${var.Tenant}-Filter-Out"
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.filter.id
  destination_cidr_block   = "0.0.0.0/0"
  source_cidr_block        = "0.0.0.0/0"
  rule_number              = 1
  rule_action              = "accept"
  traffic_direction        = "egress"
}

resource "aws_ec2_traffic_mirror_filter_rule" "rulein" {
  description              = "${var.Tenant}-Filter-In"
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.filter.id
  destination_cidr_block   = "0.0.0.0/0"
  source_cidr_block        = "0.0.0.0/0"
  rule_number              = 1
  rule_action              = "accept"
  traffic_direction        = "ingress"
}

resource "aws_ec2_traffic_mirror_target" "target" {
  network_interface_id = var.traffic_nic_id
  tags = {
    "Name" = "${var.Tenant}-Target"
    "Tenant" : "${var.Tenant}"
    "JIRA_ID" : "${var.JIRA_ID}"
  }
}

resource "aws_ec2_traffic_mirror_session" "session-Jumpbox" {
  description              = "Traffic mirror session - Jumpbox"
  network_interface_id     = var.jumpbox_eni
  session_number           = 1
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.filter.id
  traffic_mirror_target_id = aws_ec2_traffic_mirror_target.target.id
  tags = {
    "Name" = "${var.Tenant}-Session-Jumpbox"
    "Tenant" : "${var.Tenant}"
    "JIRA_ID" : "${var.JIRA_ID}"
  }
}

resource "aws_ec2_traffic_mirror_session" "session-AD" {
  description              = "Traffic mirror session - AD"
  network_interface_id     = var.ad_eni
  session_number           = 2
  traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.filter.id
  traffic_mirror_target_id = aws_ec2_traffic_mirror_target.target.id
  tags = {
    "Name" = "${var.Tenant}-Session-AD"
    "Tenant" : "${var.Tenant}"
    "JIRA_ID" : "${var.JIRA_ID}"
  }
}

# resource "aws_ec2_traffic_mirror_session" "session-COLLECTOR" {
#   description              = "Traffic mirror session - COLLECTOR"
#   network_interface_id     = var.coll_eni
#   session_number           = 2
#   traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.filter.id
#   traffic_mirror_target_id = aws_ec2_traffic_mirror_target.target.id
#   tags = {
#     "Name" = "${var.Tenant}-Session-COLLECTOR"
#     "Tenant" : "${var.Tenant}"
#     "JIRA_ID" : "${var.JIRA_ID}"
#   }
# }

# resource "aws_ec2_traffic_mirror_session" "session-ORCHESTRATOR" {
#   description              = "Traffic mirror session - ORCHESTRATOR"
#   network_interface_id     = var.orch_eni
#   session_number           = 2
#   traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.filter.id
#   traffic_mirror_target_id = aws_ec2_traffic_mirror_target.target.id
#   tags = {
#     "Name" = "${var.Tenant}-Session-ORCHESTRATOR"
#     "Tenant" : "${var.Tenant}"
#     "JIRA_ID" : "${var.JIRA_ID}"
#   }
# }

# resource "aws_ec2_traffic_mirror_session" "session-METASPLOIT" {
#   description              = "Traffic mirror session - METASPLOIT"
#   network_interface_id     = var.ms_eni
#   session_number           = 2
#   traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.filter.id
#   traffic_mirror_target_id = aws_ec2_traffic_mirror_target.target.id
#   tags = {
#     "Name" = "${var.Tenant}-Session-METASPLOIT"
#     "Tenant" : "${var.Tenant}"
#     "JIRA_ID" : "${var.JIRA_ID}"
#   }
# }

# resource "aws_ec2_traffic_mirror_session" "session-IVM" {
#   description              = "Traffic mirror session - IVM"
#   network_interface_id     = var.ivm_eni
#   session_number           = 2
#   traffic_mirror_filter_id = aws_ec2_traffic_mirror_filter.filter.id
#   traffic_mirror_target_id = aws_ec2_traffic_mirror_target.target.id
#   tags = {
#     "Name" = "${var.Tenant}-Session-IVM"
#     "Tenant" : "${var.Tenant}"
#     "JIRA_ID" : "${var.JIRA_ID}"
#   }
# }
