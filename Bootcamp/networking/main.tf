#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                       Networking Main                                                                                         #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  VPC                                                                                                                                                                                                                                                          
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_eip" "nat_gateway" {
  domain = "vpc"
}
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name"        = "${var.Tenant}-VPC"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "Networking"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Internet Gateway                                                                                                                                                                                                                                                        
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name"        = "${var.Tenant}-IGW"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "Networking"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  NAT Gateway                                                                                                                                                                                                                                                     
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    "Name"        = "${var.Tenant}-NATGW"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "Networking"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Route Table                                                                                                                                                                                                                                                     
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Public #############
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.ig.id
  }

  tags = {
    "Name"        = "${var.Tenant}-Public-Route-Table"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "Networking"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_rt.id
}

############# NAT GW #############
resource "aws_route_table" "nat_gateway" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    "Name"        = "${var.Tenant}-Route-NATGW"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "Networking"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Prefix Lists                                                                                                                                                                                                                                       
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# R7 VPN #############
resource "aws_ec2_managed_prefix_list" "r7_vpnprefixlist" {
  name           = "${var.Tenant}-R7-VPN-prefix-list"
  address_family = "IPv4"
  max_entries    = 25
}

resource "aws_ec2_managed_prefix_list_entry" "r7_vpn_entry" {
  for_each       = var.R7vpn_List
  cidr           = each.key
  description    = each.value
  prefix_list_id = aws_ec2_managed_prefix_list.r7_vpnprefixlist.id
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Subnets                                                                                                                                                                                                                                      
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Public #############
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone

  tags = {
    "Name"        = "${var.Tenant}-Public-Subnet"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "Networking"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.availability_zone2

  tags = {
    "Name"        = "${var.Tenant}-Public-Subnet-2"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "Networking"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Private #############
############# IDR #############
resource "aws_subnet" "private_subnet_idr" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.17.0/24"
  availability_zone = var.availability_zone

  tags = {
    "Name"        = "${var.Tenant}-Private-Subnet-IDR"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "Networking"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_route_table_association" "nat_gateway_idr" {
  subnet_id      = aws_subnet.private_subnet_idr.id
  route_table_id = aws_route_table.nat_gateway.id
}

############# IVM #############
resource "aws_subnet" "private_subnet_ivm" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.7.0/24"
  availability_zone = var.availability_zone2

  tags = {
    "Name"        = "${var.Tenant}-Private-Subnet-IVM"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "Networking"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_route_table_association" "nat_gateway_ivm" {
  subnet_id      = aws_subnet.private_subnet_ivm.id
  route_table_id = aws_route_table.nat_gateway.id
}

############# IAS #############
resource "aws_subnet" "private_subnet_ias" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.27.0/24"
  availability_zone = var.availability_zone2

  tags = {
    "Name"        = "${var.Tenant}-Private-Subnet-IAS"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "Networking"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_route_table_association" "nat_gateway_ias" {
  subnet_id      = aws_subnet.private_subnet_ias.id
  route_table_id = aws_route_table.nat_gateway.id
}

############# ICON #############
resource "aws_subnet" "private_subnet_icon" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.37.0/24"
  availability_zone = var.availability_zone2

  tags = {
    "Name"        = "${var.Tenant}-Private-Subnet-ICON"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "Networking"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_route_table_association" "nat_gateway_icon" {
  subnet_id      = aws_subnet.private_subnet_icon.id
  route_table_id = aws_route_table.nat_gateway.id
}


#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  DHCP Options                                                                                                                                                                                                                                                 
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_vpc_dhcp_options" "dhcp" {
  domain_name_servers = ["${var.BTCP_DC_IP}", "AmazonProvidedDNS"]
  tags = {
    "Name"        = "${var.Tenant}-DHCP"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "Networking"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_vpc_dhcp_options_association" "dhcp" {
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp.id
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Security Groups                                                                                                                                                                                                                                 
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# External #############
resource "aws_security_group" "external_sg" {
  name   = "${var.Tenant}-External"
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name"        = "${var.Tenant}-External-SG"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "Networking"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Internal #############
resource "aws_security_group" "internal_sg" {
  name   = "${var.Tenant}-Internal"
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name"        = "${var.Tenant}-Internal-SG"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "Networking"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Security Groups Rules                                                                                                                                                                                                                               
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Internal #############
resource "aws_security_group_rule" "ingress_external_internal" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.external_sg.id
  security_group_id        = aws_security_group.internal_sg.id
}
resource "aws_security_group_rule" "ingress_internal" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.internal_sg.id
}
resource "aws_security_group_rule" "egress_internal" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.internal_sg.id
}
############# External #############
resource "aws_security_group_rule" "ingress_RDP_external" {
  type              = "ingress"
  from_port         = 3389
  to_port           = 3389
  protocol          = "tcp"
  cidr_blocks       = [var.Public_IP_Access]
  security_group_id = aws_security_group.external_sg.id
}
resource "aws_security_group_rule" "ingress_R7_external" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  prefix_list_ids   = [aws_ec2_managed_prefix_list.r7_vpnprefixlist.id]
  security_group_id = aws_security_group.external_sg.id
}
resource "aws_security_group_rule" "egress_external" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.external_sg.id
}
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  S3 Endpoint                                                                                                                                                                                                                      
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_vpc_endpoint" "s3" {
  vpc_id          = aws_vpc.vpc.id
  service_name    = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids = ["${aws_route_table.nat_gateway.id}"]

  tags = {
    "Name"        = "${var.Tenant}-S3-Endpoint"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "Networking"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
