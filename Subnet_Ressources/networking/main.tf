#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                       Networking Main                                                                                         #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  VPC                                                                                                                                                                                                                                                          
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name"        = "${var.Tenant}-VPC"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Internet Gateway                                                                                                                                                                                                                                                        
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name"        = "${var.Tenant}-IGW"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  ACM Module                                                                                                                                                                                                                                                         
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
module "acm" {
  count               = var.use_route53_hz == true ? 1 : 0
  source              = "terraform-aws-modules/acm/aws"
  version             = "~> 4.0"
  domain_name         = "*.${var.ZoneName}"
  zone_id             = var.Zone_ID
  wait_for_validation = true
  tags = {
    "Name"        = "${var.Tenant}-ALB-CERT"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
module "acmivm" {
  count               = var.use_route53_hz == true ? 1 : 0
  source              = "terraform-aws-modules/acm/aws"
  version             = "~> 4.0"
  domain_name         = "ivm.${var.ZoneName}"
  zone_id             = var.Zone_ID
  wait_for_validation = true
  tags = {
    "Name"        = "${var.Tenant}-IVM-CERT"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  NAT Gateway                                                                                                                                                                                                                                                     
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_nat_gateway" "nat_gateway" {
  count         = var.Routing_Type == "aws" ? 1 : 0
  allocation_id = one(aws_eip.nat_gateway[*].id)
  subnet_id     = one(aws_subnet.subnet_NAT[*].id)
  tags = {
    "Name"        = "${var.Tenant}-NATGW"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Route Table                                                                                                                                                                                                                                                     
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Public #############
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
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
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Rapid7 #############
resource "aws_route_table" "rapid7" {
  count  = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" ? 1 : 0
  vpc_id = aws_vpc.main.id
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_network_interface.rapid7_eni[count.index].id
  }
  tags = {
    "Name"        = "${var.Tenant}-Rapid7-Route-Table"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_route_table_association" "global_rapid7_fw" {
  count          = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" ? 1 : 0
  subnet_id      = one(aws_subnet.subnet_rapid7[*].id)
  route_table_id = one(aws_route_table.rapid7[*].id)
}
resource "aws_route_table_association" "global_rapid7-nat" {
  count          = var.Routing_Type == "aws" && var.Deployment_Mode != "limited" ? 1 : 0
  subnet_id      = one(aws_subnet.subnet_rapid7[*].id)
  route_table_id = aws_route_table.nat_gateway[count.index].id
}

############# Global NAT #############
resource "aws_route_table_association" "global_Rapid7-nat" {
  count          = var.Routing_Type == "aws" && var.Deployment_Mode != "limited" ? 1 : 0
  subnet_id      = one(aws_subnet.subnet_rapid7[*].id)
  route_table_id = aws_route_table.nat_gateway[count.index].id
}
resource "aws_route_table" "nat_gateway" {
  count  = var.Routing_Type == "aws" ? 1 : 0
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = one(aws_nat_gateway.nat_gateway[*].id)
  }
  tags = {
    "Name"        = "${var.Tenant}-Route-NATGW"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_route_table_association" "natgw" {
  count          = var.Routing_Type == "aws" ? 1 : 0
  subnet_id      = one(aws_subnet.subnet_NAT[*].id)
  route_table_id = aws_route_table.public_rt.id
}

############# Public #############
resource "aws_route_table" "public" {
  count  = var.Routing_Type == "pfsense" ? 1 : 0
  vpc_id = aws_vpc.main.id
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_network_interface.fw_public_eni[count.index].id
  }
  tags = {
    "Name"        = "${var.Tenant}-Public-Route-Table"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# IT #############
resource "aws_route_table" "it" {
  count  = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  vpc_id = aws_vpc.main.id
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_network_interface.it_eni[count.index].id
  }
  tags = {
    "Name"        = "${var.Tenant}-IT-Route-Table"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

resource "aws_route_table_association" "it-nat" {
  count          = var.Routing_Type == "aws" && var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  subnet_id      = one(aws_subnet.subnet_it[*].id)
  route_table_id = aws_route_table.nat_gateway[count.index].id
}
resource "aws_route_table_association" "it_fw" {
  count          = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  subnet_id      = one(aws_subnet.subnet_it[*].id)
  route_table_id = one(aws_route_table.it[*].id)
}
############# HQ #############
resource "aws_route_table" "hq" {
  count  = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" && var.Deployment_Mode != "partial" ? 1 : 0
  vpc_id = aws_vpc.main.id
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_network_interface.hq_eni[count.index].id
  }
  tags = {
    "Name"        = "${var.Tenant}-HQ-Route-Table"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_route_table_association" "hq-nat" {
  count          = var.Routing_Type == "aws" && var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" && var.Deployment_Mode != "partial" ? 1 : 0
  subnet_id      = one(aws_subnet.subnet_hq[*].id)
  route_table_id = aws_route_table.nat_gateway[count.index].id
}
resource "aws_route_table_association" "hq_fw" {
  count          = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" && var.Deployment_Mode != "partial" ? 1 : 0
  subnet_id      = one(aws_subnet.subnet_hq[*].id)
  route_table_id = one(aws_route_table.hq[*].id)
}
############# Jumpbox #############
resource "aws_route_table" "jumpbox" {
  count  = var.Jumpbox_Module == true ? 1 : 0
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }
  tags = {
    "Name"        = "${var.Tenant}-Jumpbox-Route-Table"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_route_table_association" "jumpbox-nat" {
  count          = var.Routing_Type == "aws" && var.Jumpbox_Module == true ? 1 : 0
  subnet_id      = one(aws_subnet.subnet_jumpbox[*].id)
  route_table_id = one(aws_route_table.jumpbox[*].id)
}
resource "aws_route_table_association" "jumpbox_fw" {
  count          = var.Routing_Type == "pfsense" && var.Jumpbox_Module == true ? 1 : 0
  subnet_id      = one(aws_subnet.subnet_jumpbox[*].id)
  route_table_id = one(aws_route_table.jumpbox[*].id)
}

############# FW #############
resource "aws_route_table" "fwintra" {
  count  = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  vpc_id = aws_vpc.main.id
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_network_interface.fw_publicprivate_eni[count.index].id
  }
  tags = {
    "Name"        = "${var.Tenant}-FW-Intra-Route-Table"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_route_table_association" "fw" {
  count          = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  subnet_id      = aws_subnet.subnet_fw[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

############# DMZ #############
resource "aws_route_table" "dmz" {
  count  = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  vpc_id = aws_vpc.main.id
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_network_interface.dmz_eni[count.index].id
  }
  tags = {
    "Name"        = "${var.Tenant}-DMZ-Route-Table"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_route_table_association" "DMZ-nat" {
  count          = var.Routing_Type == "aws" && var.POVAgent_Module == false ? 1 : 0
  subnet_id      = one(aws_subnet.subnet_dmz[*].id)
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "dmz_fw" {
  count          = var.Routing_Type == "pfsense" && var.POVAgent_Module == false && var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  subnet_id      = one(aws_subnet.subnet_dmz[*].id)
  route_table_id = aws_route_table.dmz[0].id
}

############# POVAgent #############
resource "aws_route_table_association" "povagent_ext_nat" {
  count          = var.POVAgent_Module == true ? 1 : 0
  subnet_id      = one(aws_subnet.subnet_povagent_ext[*].id)
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "povagent_int_nat" {
  count          = var.POVAgent_Module == true ? 1 : 0
  subnet_id      = one(aws_subnet.subnet_povagent_int[*].id)
  route_table_id = aws_route_table.nat_gateway[count.index].id
}

############# DMZ WebApp1 #############
resource "aws_route_table_association" "dmz_webapp1_fw" {
  count          = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  subnet_id      = one(aws_subnet.subnet_dmz_webapp1[*].id)
  route_table_id = aws_route_table.public_rt.id
}

############# DMZ WebApp2 #############
resource "aws_route_table_association" "dmz_webapp2_fw" {
  count          = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  subnet_id      = one(aws_subnet.subnet_dmz_webapp2[*].id)
  route_table_id = aws_route_table.public_rt.id
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  DHCP Options                                                                                                                                                                                                                                                 
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_vpc_dhcp_options" "dhcp" {
  domain_name_servers = ["AmazonProvidedDNS"]
  tags = {
    "Name"        = "${var.Tenant}-DHCP"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_vpc_dhcp_options_association" "dhcp" {
  vpc_id          = aws_vpc.main.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp.id
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
resource "aws_ec2_managed_prefix_list" "r7_officeprefixlist" {
  name           = "${var.Tenant}-R7-Office-prefix-list"
  address_family = "IPv4"
  max_entries    = 25
}

resource "aws_ec2_managed_prefix_list_entry" "r7_vpn_entry" {
  for_each       = var.R7vpn_List
  cidr           = each.key
  description    = each.value
  prefix_list_id = aws_ec2_managed_prefix_list.r7_vpnprefixlist.id
}
resource "aws_ec2_managed_prefix_list_entry" "r7_office_entry" {
  for_each       = var.R7officeList
  cidr           = each.key
  description    = each.value
  prefix_list_id = aws_ec2_managed_prefix_list.r7_officeprefixlist.id
}
############# IAS Cloud Engines #############
resource "aws_ec2_managed_prefix_list" "r7_iasengineprefixlist" {
  name           = "${var.Tenant}-R7-IAS-Engine-list"
  address_family = "IPv4"
  max_entries    = 25
}
resource "aws_ec2_managed_prefix_list_entry" "r7_iasengine_entry" {
  for_each       = var.IASEngine_List
  cidr           = each.key
  description    = each.value
  prefix_list_id = aws_ec2_managed_prefix_list.r7_iasengineprefixlist.id
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Subnets                                                                                                                                                                                                                                      
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Rapid7 #############
resource "aws_subnet" "subnet_rapid7" {
  count             = var.Deployment_Mode != "limited" ? 1 : 0
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.7.0/24"
  availability_zone = "${var.AWS_Region}a"
  tags = {
    "Name"        = "${var.Tenant}-Rapid7"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# POVAgent #############
resource "aws_subnet" "subnet_povagent_ext" {
  count             = var.POVAgent_Module == true ? 1 : 0
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.100.0/24"
  availability_zone = "${var.AWS_Region}a"
  tags = {
    "Name"        = "${var.Tenant}-POVAgent_Ext"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_subnet" "subnet_povagent_int" {
  count             = var.POVAgent_Module == true ? 1 : 0
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.110.0/24"
  availability_zone = "${var.AWS_Region}a"
  tags = {
    "Name"        = "${var.Tenant}-POVAgent_Int"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Firewall #############
resource "aws_subnet" "subnet_fw" {
  count             = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "${var.AWS_Region}a"
  tags = {
    "Name"        = "${var.Tenant}-FW"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Firewall Intra #############
resource "aws_subnet" "subnet_fw_intra" {
  count             = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.AWS_Region}a"
  tags = {
    "Name"        = "${var.Tenant}-FW-Intra"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_route_table_association" "fw_intra" {
  count          = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  subnet_id      = aws_subnet.subnet_fw_intra[count.index].id
  route_table_id = one(aws_route_table.fwintra[*].id)
}

############# Jumpbox #############
resource "aws_subnet" "subnet_jumpbox" {
  count             = var.Jumpbox_Module == true ? 1 : 0
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.AWS_Region}a"
  tags = {
    "Name"        = "${var.Tenant}-Jumpbox"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# DMZ #############
resource "aws_subnet" "subnet_dmz" {
  count             = var.POVAgent_Module == true ? 0 : 1
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.AWS_Region}a"
  tags = {
    "Name"        = "${var.Tenant}-DMZ"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# NATGW #############
resource "aws_eip" "nat_gateway" {
  count  = var.Routing_Type == "aws" ? 1 : 0
  domain = "vpc"
}
resource "aws_subnet" "subnet_NAT" {
  count             = var.Routing_Type == "aws" ? 1 : 0
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.6.0/24"
  availability_zone = "${var.AWS_Region}a"
  tags = {
    "Name"        = "${var.Tenant}-NATGW"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# DMZ WebApp1 #############
resource "aws_subnet" "subnet_dmz_webapp1" {
  count             = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${var.AWS_Region}b"
  tags = {
    "Name"        = "${var.Tenant}-DMZ-WebApp1"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# DMZ WebApp2 #############
resource "aws_subnet" "subnet_dmz_webapp2" {
  count             = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.5.0/24"
  availability_zone = "${var.AWS_Region}c"
  tags = {
    "Name"        = "${var.Tenant}-DMZ-WebApp2"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# IT #############
resource "aws_subnet" "subnet_it" {
  count             = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "${var.AWS_Region}a"
  tags = {
    "Name"        = "${var.Tenant}-IT"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# HQ #############
resource "aws_subnet" "subnet_hq" {
  count             = var.Deployment_Mode != "limited" && var.Deployment_Mode != "partial" && var.Deployment_Mode != "custom" ? 1 : 0
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "${var.AWS_Region}a"
  tags = {
    "Name"        = "${var.Tenant}-HQ"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Security Groups                                                                                                                                                                                                                                 
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Rapid7 #############
resource "aws_security_group" "rapid7_sg" {
  count  = var.Deployment_Mode != "limited" ? 1 : 0
  name   = "${var.Tenant}-Rapid7"
  vpc_id = aws_vpc.main.id
  tags = {
    "Name"        = "${var.Tenant}-Rapid7-SG"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}


############# FW Pub #############
resource "aws_security_group" "fw_public_sg" {
  name   = "${var.Tenant}-FW-Public-SG"
  count  = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  vpc_id = aws_vpc.main.id
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    prefix_list_ids = [aws_ec2_managed_prefix_list.r7_vpnprefixlist.id]
  }
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [one(aws_security_group.jumpbox_sg[*].id)]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name"        = "${var.Tenant}-FW-Public-SG"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# FW Intra #############
resource "aws_security_group" "fw_sg" {
  count  = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  name   = "${var.Tenant}-FW"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [one(aws_security_group.jumpbox_sg[*].id)]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Name"        = "${var.Tenant}-FW-SG"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Jumpbox #############
resource "aws_security_group" "jumpbox_sg" {
  count  = var.Jumpbox_Module == true ? 1 : 0
  name   = "${var.Tenant}-Jumpbox"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    prefix_list_ids = [aws_ec2_managed_prefix_list.r7_vpnprefixlist.id]
  }
  # egress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  #}
  tags = {
    "Name"        = "${var.Tenant}-Jumpbox-SG"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# DMZ #############
resource "aws_security_group" "dmz_sg" {
  name   = "${var.Tenant}-DMZ"
  vpc_id = aws_vpc.main.id
  tags = {
    "Name"        = "${var.Tenant}-DMZ-SG"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# POVAgent #############
resource "aws_security_group" "povagent_ext_sg" {
  count  = var.POVAgent_Module == true ? 1 : 0
  name   = "${var.Tenant}-POVAgent-EXT"
  vpc_id = aws_vpc.main.id
  tags = {
    "Name"        = "${var.Tenant}-POVAgent-EXT"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_security_group" "povagent_int_sg" {
  count  = var.POVAgent_Module == true ? 1 : 0
  name   = "${var.Tenant}-POVAgent-INT"
  vpc_id = aws_vpc.main.id
  tags = {
    "Name"        = "${var.Tenant}-POVAgent-INT"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# DMZ IVM #############
resource "aws_security_group" "dmz_ivm_sg" {
  name   = "${var.Tenant}-DMZ-IVM"
  vpc_id = aws_vpc.main.id
  tags = {
    "Name"        = "${var.Tenant}-DMZ-IVM-SG"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# DMZ IVM Limited #############
resource "aws_security_group" "dmz_ivm_ltd_sg" {
  name   = "${var.Tenant}-DMZ-IVM-LTD"
  vpc_id = aws_vpc.main.id
  tags = {
    "Name"        = "${var.Tenant}-DMZ-IVM-LTD-SG"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# DMZ WebApp1 #############
resource "aws_security_group" "dmz_webpp1_sg" {
  count  = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  name   = "${var.Tenant}-DMZ-WebApp1"
  vpc_id = aws_vpc.main.id
  tags = {
    "Name"        = "${var.Tenant}-DMZ-WebApp1-SG"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# DMZ WebApp2 #############
resource "aws_security_group" "dmz_webpp2_sg" {
  count  = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  name   = "${var.Tenant}-DMZ-WebApp2"
  vpc_id = aws_vpc.main.id
  tags = {
    "Name"        = "${var.Tenant}-DMZ-WebApp2-SG"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# ALB #############
resource "aws_security_group" "alb_sg" {
  count  = var.Deployment_Mode != "limited" && var.use_route53_hz == true ? 1 : 0
  name   = "${var.Tenant}-ALB-SG"
  vpc_id = aws_vpc.main.id
  tags = {
    "Name"        = "${var.Tenant}-ALB-SG"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_security_group" "alb2_sg" {
  count  = var.Deployment_Mode != "limited" && var.use_route53_hz == true ? 1 : 0
  name   = "${var.Tenant}-ALB2-SG"
  vpc_id = aws_vpc.main.id
  tags = {
    "Name"        = "${var.Tenant}-ALB2-SG"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# ECS #############
resource "aws_security_group" "ecs_service_sg" {
  count  = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  name   = "${var.Tenant}-ECS-SG"
  vpc_id = aws_vpc.main.id
  # ingress {
  #   from_port = 0
  #   to_port   = 0
  #   protocol  = "-1"
  #   self      = true
  # }
  # ingress {
  #   from_port       = 0
  #   to_port         = 0
  #   protocol        = "-1"
  #   prefix_list_ids = [aws_ec2_managed_prefix_list.r7_vpnprefixlist.id]
  # }
  # ingress {
  #   from_port       = 0
  #   to_port         = 0
  #   protocol        = "-1"
  #   security_groups = [one(aws_security_group.alb_sg[*].id)]
  # }
  # egress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  tags = {
    "Name"        = "${var.Tenant}-ECS-SG"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# IT #############
resource "aws_security_group" "it_sg" {
  count  = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  name   = "${var.Tenant}-IT"
  vpc_id = aws_vpc.main.id
  tags = {
    "Name"        = "${var.Tenant}-IT-SG"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# HQ #############
resource "aws_security_group" "hq_sg" {
  count  = var.Deployment_Mode != "limited" && var.Deployment_Mode != "partial" && var.Deployment_Mode != "custom" ? 1 : 0
  name   = "${var.Tenant}-HQ"
  vpc_id = aws_vpc.main.id
  tags = {
    "Name"        = "${var.Tenant}-HQ-SG"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# NAT GW #############
# resource "aws_security_group" "nat_gateway_sg" {
#   count  = var.Routing_Type == "aws" ? 1 : 0
#   name   = "${var.Tenant}-NATGW"
#   vpc_id = aws_vpc.main.id
#   ingress {
#     from_port = 0
#     to_port   = 0
#     protocol  = "-1"
#     self      = true
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = -1
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     "Name" = "${var.Tenant}-NATGW-SG"
#     "Tenant" : "${var.Tenant}"
#     "JIRA_ID" : "${var.JIRA_ID}"
#   }
# }

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Security Groups Rules                                                                                                                                                                                                                               
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# ALB #############
resource "aws_security_group_rule" "ingress_public_alb_https" {
  count             = var.Deployment_Mode != "limited" && var.Public_Access_ALB == true && var.use_route53_hz == true ? 1 : 0
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = one(aws_security_group.alb_sg[*].id)
}
resource "aws_security_group_rule" "ingress_public_alb_8025" {
  count             = var.Deployment_Mode != "limited" && var.Public_Access_ALB == true && var.use_route53_hz == true ? 1 : 0
  type              = "ingress"
  from_port         = 8025
  to_port           = 8025
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = one(aws_security_group.alb_sg[*].id)
}
resource "aws_security_group_rule" "ingress_r7vpn_alb" {
  count             = var.Deployment_Mode != "limited" && var.use_route53_hz == true ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  prefix_list_ids   = [aws_ec2_managed_prefix_list.r7_vpnprefixlist.id]
  security_group_id = one(aws_security_group.alb_sg[*].id)
}
resource "aws_security_group_rule" "ingress_r7office_alb2" {
  count             = var.Deployment_Mode != "limited" && var.use_route53_hz == true ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  prefix_list_ids   = [aws_ec2_managed_prefix_list.r7_officeprefixlist.id]
  security_group_id = one(aws_security_group.alb2_sg[*].id)
}
resource "aws_security_group_rule" "ingress_iasengine_alb" {
  count             = var.Deployment_Mode != "limited" && var.use_route53_hz == true ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  prefix_list_ids   = [aws_ec2_managed_prefix_list.r7_iasengineprefixlist.id]
  security_group_id = one(aws_security_group.alb_sg[*].id)
}
resource "aws_security_group_rule" "egress_alb" {
  count             = var.Deployment_Mode != "limited" && var.use_route53_hz == true ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = one(aws_security_group.alb_sg[*].id)
}

############# Jumpbox #############
resource "aws_security_group_rule" "egress_jumpbox_rapid7" {
  count                    = var.Deployment_Mode != "limited" && var.Jumpbox_Module == true ? 1 : 0
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.rapid7_sg[*].id)
  security_group_id        = one(aws_security_group.jumpbox_sg[*].id)
}
resource "aws_security_group_rule" "egress_jumpbox_hq" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "partial" && var.Jumpbox_Module == true ? 1 : 0
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.hq_sg[*].id)
  security_group_id        = one(aws_security_group.jumpbox_sg[*].id)
}
resource "aws_security_group_rule" "egress_jumpbox_it" {
  count                    = var.Deployment_Mode != "limited" && var.Jumpbox_Module == true ? 1 : 0
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.it_sg[*].id)
  security_group_id        = one(aws_security_group.jumpbox_sg[*].id)
}
resource "aws_security_group_rule" "egress_jumpbox_dmz" {
  count                    = var.Jumpbox_Module == true ? 1 : 0
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.dmz_sg[*].id)
  security_group_id        = one(aws_security_group.jumpbox_sg[*].id)
}
resource "aws_security_group_rule" "egress_jumpbox_dmzwebapp1" {
  count                    = var.Deployment_Mode != "limited" && var.Jumpbox_Module == true ? 1 : 0
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.dmz_webpp1_sg[*].id)
  security_group_id        = one(aws_security_group.jumpbox_sg[*].id)
}
resource "aws_security_group_rule" "egress_jumpbox_dmzwebapp2" {
  count                    = var.Deployment_Mode != "limited" && var.Jumpbox_Module == true ? 1 : 0
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.dmz_webpp2_sg[*].id)
  security_group_id        = one(aws_security_group.jumpbox_sg[*].id)
}
resource "aws_security_group_rule" "egress_jumpbox_jumpbox" {
  count             = var.Jumpbox_Module == true ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
  security_group_id = one(aws_security_group.jumpbox_sg[*].id)
}
resource "aws_security_group_rule" "egress_jumpbox_public" {
  count             = var.Jumpbox_Module == true ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = one(aws_security_group.jumpbox_sg[*].id)
}
resource "aws_security_group_rule" "egress_jumpbox_povagent_ext" {
  count                    = var.POVAgent_Module == true && var.Jumpbox_Module == true ? 1 : 0
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.povagent_ext_sg[*].id)
  security_group_id        = one(aws_security_group.jumpbox_sg[*].id)
}
resource "aws_security_group_rule" "egress_jumpbox_povagent_int" {
  count                    = var.POVAgent_Module == true && var.Jumpbox_Module == true ? 1 : 0
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.povagent_int_sg[*].id)
  security_group_id        = one(aws_security_group.jumpbox_sg[*].id)
}

############# Rapid7 #############
resource "aws_security_group_rule" "ingress_rapid7_jumpbox" {
  count                    = var.Deployment_Mode != "limited" && var.Jumpbox_Module == true ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.jumpbox_sg[*].id)
  security_group_id        = one(aws_security_group.rapid7_sg[*].id)
}
resource "aws_security_group_rule" "ingress_fw_rapid7" {
  count                    = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" || var.Routing_Type == "pfsense" && var.Deployment_Mode == "custom" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = aws_security_group.fw_sg[count.index].id
  security_group_id        = one(aws_security_group.rapid7_sg[*].id)
}
resource "aws_security_group_rule" "ingress_rapid7_it" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.it_sg[*].id)
  security_group_id        = one(aws_security_group.rapid7_sg[*].id)
}
resource "aws_security_group_rule" "ingress_rapid7_hq" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "partial" && var.Deployment_Mode != "custom" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.hq_sg[*].id)
  security_group_id        = one(aws_security_group.rapid7_sg[*].id)
}
resource "aws_security_group_rule" "ingress_alb_rapid7" {
  count                    = var.Deployment_Mode == "custom" && var.use_route53_hz == true || var.Deployment_Mode != "limited" && var.use_route53_hz == true ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.alb_sg[*].id)
  security_group_id        = one(aws_security_group.rapid7_sg[*].id)
}
resource "aws_security_group_rule" "ingress_rapid7" {
  count             = var.Deployment_Mode != "limited" ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
  security_group_id = one(aws_security_group.rapid7_sg[*].id)
}
resource "aws_security_group_rule" "egress_rapid7" {
  count             = var.Deployment_Mode != "limited" ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = one(aws_security_group.rapid7_sg[*].id)
}

resource "aws_security_group_rule" "igress_seops_rapid7" {
  count             = var.Deployment_Mode != "limited" ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["52.14.125.144/32"]
  security_group_id = one(aws_security_group.rapid7_sg[*].id)
}

############# IT #############
resource "aws_security_group_rule" "ingress_it_jumpbox" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.jumpbox_sg[*].id)
  security_group_id        = one(aws_security_group.it_sg[*].id)
}
resource "aws_security_group_rule" "ingress_it_it" {
  count             = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
  security_group_id = one(aws_security_group.it_sg[*].id)
}
resource "aws_security_group_rule" "ingress_it_rapid7" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.rapid7_sg[*].id)
  security_group_id        = one(aws_security_group.it_sg[*].id)
}
resource "aws_security_group_rule" "ingress_hq_it" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "partial" && var.Deployment_Mode != "custom" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.hq_sg[*].id)
  security_group_id        = one(aws_security_group.it_sg[*].id)
}
resource "aws_security_group_rule" "egress_it" {
  count             = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = one(aws_security_group.it_sg[*].id)
}

resource "aws_security_group_rule" "ingress_ivm_it" {
  count             = var.Deployment_Mode != "limited" && var.Deployment_Mode != "partial" && var.Deployment_Mode != "custom" ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["10.0.2.10/32"]
  security_group_id = one(aws_security_group.it_sg[*].id)
}

############# HQ #############
resource "aws_security_group_rule" "ingress_hq_jumpbox" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "partial" && var.Deployment_Mode != "custom" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.jumpbox_sg[*].id)
  security_group_id        = one(aws_security_group.hq_sg[*].id)
}
resource "aws_security_group_rule" "ingress_hq_hq" {
  count             = var.Deployment_Mode != "limited" && var.Deployment_Mode != "partial" && var.Deployment_Mode != "custom" ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
  security_group_id = one(aws_security_group.hq_sg[*].id)
}
resource "aws_security_group_rule" "ingress_hq_rapid7" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "partial" && var.Deployment_Mode != "custom" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.rapid7_sg[*].id)
  security_group_id        = one(aws_security_group.hq_sg[*].id)
}
resource "aws_security_group_rule" "ingress_it_hq" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "partial" && var.Deployment_Mode != "custom" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.it_sg[*].id)
  security_group_id        = one(aws_security_group.hq_sg[*].id)
}
resource "aws_security_group_rule" "egress_hq" {
  count             = var.Deployment_Mode != "limited" && var.Deployment_Mode != "partial" && var.Deployment_Mode != "custom" ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = one(aws_security_group.hq_sg[*].id)
}

resource "aws_security_group_rule" "ingress_ivm_hq" {
  count             = var.Deployment_Mode != "limited" && var.Deployment_Mode != "partial" && var.Deployment_Mode != "custom" ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["10.0.2.10/32"]
  security_group_id = one(aws_security_group.hq_sg[*].id)
}

############# DMZ IVM #############
resource "aws_security_group_rule" "ingress_fwpub-dmz_ivm" {
  count                    = var.Routing_Type == "pfsense" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = aws_security_group.fw_public_sg[count.index].id
  security_group_id        = one(aws_security_group.dmz_ivm_sg[*].id)
}
resource "aws_security_group_rule" "ingress_fw_dmz_ivm" {
  count                    = var.Routing_Type == "pfsense" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = aws_security_group.fw_sg[count.index].id
  security_group_id        = one(aws_security_group.dmz_ivm_sg[*].id)
}
resource "aws_security_group_rule" "ingress_jumpbox_dmz_ivm" {
  count                    = var.Jumpbox_Module == true ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.jumpbox_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_ivm_sg[*].id)
}
resource "aws_security_group_rule" "ingress_vulnlab_dmz_ivm" {
  type              = "ingress"
  from_port         = 40815
  to_port           = 40815
  protocol          = -1
  cidr_blocks       = ["128.177.65.3/32"]
  security_group_id = one(aws_security_group.dmz_ivm_sg[*].id)
}
resource "aws_security_group_rule" "ingress_r7vpn_dmz_ivm" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  prefix_list_ids   = [aws_ec2_managed_prefix_list.r7_vpnprefixlist.id]
  security_group_id = one(aws_security_group.dmz_ivm_sg[*].id)
}
resource "aws_security_group_rule" "ingress_r7office_dmz_ivm" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  prefix_list_ids   = [aws_ec2_managed_prefix_list.r7_officeprefixlist.id]
  security_group_id = one(aws_security_group.dmz_ivm_sg[*].id)
}
resource "aws_security_group_rule" "ingress_rapid7_dmz_ivm" {
  count                    = var.Deployment_Mode != "limited" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.rapid7_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_ivm_sg[*].id)
}
resource "aws_security_group_rule" "ingress_dmz_dmz_ivm" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
  security_group_id = one(aws_security_group.dmz_ivm_sg[*].id)
}
resource "aws_security_group_rule" "eggress_dmz_dmz_ivm" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = one(aws_security_group.dmz_ivm_sg[*].id)
}
resource "aws_security_group_rule" "ingress_dmz_webapp1_dmz_ivm" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" && var.InsightVM_Module != false ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.dmz_webpp1_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_ivm_sg[*].id)
}
resource "aws_security_group_rule" "ingress_dmz_webapp2_dmz_ivm" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" && var.InsightVM_Module != false ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.dmz_webpp2_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_ivm_sg[*].id)
}
resource "aws_security_group_rule" "ingress_alb_dmz_ivm" {
  count                    = var.Deployment_Mode != "limited" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.alb_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_ivm_sg[*].id)
}
resource "aws_security_group_rule" "ingress_alb2_dmz_ivm" {
  count                    = var.Deployment_Mode != "limited" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.alb2_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_ivm_sg[*].id)
}

############# DMZ IVM Lockdown #############
resource "aws_security_group_rule" "ingress_alb_dmz_ivm_ltd" {
  count                    = var.Deployment_Mode != "limited" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.alb_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_ivm_ltd_sg[*].id)
}
resource "aws_security_group_rule" "ingress_dmz_dmz_ltd_ivm" {
  count                    = var.Deployment_Mode != "limited" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.dmz_ivm_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_ivm_ltd_sg[*].id)
}

resource "aws_security_group_rule" "ingress_fwpub_dmz_ivm_ltd" {
  count                    = var.Routing_Type == "pfsense" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = aws_security_group.fw_public_sg[count.index].id
  security_group_id        = one(aws_security_group.dmz_ivm_ltd_sg[*].id)
}
resource "aws_security_group_rule" "ingress_fw_dmz_ivm_ltd" {
  count                    = var.Routing_Type == "pfsense" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = aws_security_group.fw_sg[count.index].id
  security_group_id        = one(aws_security_group.dmz_ivm_ltd_sg[*].id)
}
resource "aws_security_group_rule" "ingress_jumpbox_dmz_ivm_ltd" {
  count                    = var.Jumpbox_Module == true ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.jumpbox_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_ivm_ltd_sg[*].id)
}
resource "aws_security_group_rule" "ingress_vulnlab_dmz_ivm_ltd" {
  type              = "ingress"
  from_port         = 40815
  to_port           = 40815
  protocol          = -1
  cidr_blocks       = ["128.177.65.3/32"]
  security_group_id = one(aws_security_group.dmz_ivm_ltd_sg[*].id)
}
resource "aws_security_group_rule" "ingress_r7vpn_dmz_ivm_ltd" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  prefix_list_ids   = [aws_ec2_managed_prefix_list.r7_vpnprefixlist.id]
  security_group_id = one(aws_security_group.dmz_ivm_ltd_sg[*].id)
}
resource "aws_security_group_rule" "ingress_rapid7_dmz_ivm_ltd" {
  count                    = var.Deployment_Mode != "limited" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.rapid7_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_ivm_ltd_sg[*].id)
}
resource "aws_security_group_rule" "ingress_dmz_dmz_ivm_ltd" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
  security_group_id = one(aws_security_group.dmz_ivm_ltd_sg[*].id)
}
resource "aws_security_group_rule" "ingress_dmz_webapp1_dmz_ivm_ltd" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" && var.InsightVM_Module != false ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.dmz_webpp1_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_ivm_ltd_sg[*].id)
}
resource "aws_security_group_rule" "ingress_dmz_webapp2_dmz_ivm_ltd" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" && var.InsightVM_Module != false ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.dmz_webpp2_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_ivm_ltd_sg[*].id)
}
resource "aws_security_group_rule" "eggress_R7_dmz_ivm_ltd" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" && var.InsightVM_Module != false ? 1 : 0
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.rapid7_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_ivm_ltd_sg[*].id)
}
resource "aws_security_group_rule" "eggress_IT_dmz_ivm_ltd" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" && var.InsightVM_Module != false ? 1 : 0
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.it_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_ivm_ltd_sg[*].id)
}
resource "aws_security_group_rule" "eggress_HQ_dmz_ivm_ltd" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "partial" && var.Deployment_Mode != "custom" ? 1 : 0
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.hq_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_ivm_ltd_sg[*].id)
}
resource "aws_security_group_rule" "eggress_443_dmz_ivm_ltd" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = one(aws_security_group.dmz_ivm_ltd_sg[*].id)
}

############# DMZ #############
resource "aws_security_group_rule" "ingress_ics_dmz" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = var.ExtCollector_ICSIP
  security_group_id = one(aws_security_group.dmz_sg[*].id)
}
resource "aws_security_group_rule" "ingress_fwpub-dmz" {
  count                    = var.Routing_Type == "pfsense" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = aws_security_group.fw_public_sg[count.index].id
  security_group_id        = one(aws_security_group.dmz_sg[*].id)
}
resource "aws_security_group_rule" "ingress_fw_dmz" {
  count                    = var.Routing_Type == "pfsense" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = aws_security_group.fw_sg[count.index].id
  security_group_id        = one(aws_security_group.dmz_sg[*].id)
}
resource "aws_security_group_rule" "ingress_jumpbox_dmz" {
  count                    = var.Jumpbox_Module == true ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.jumpbox_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_sg[*].id)
}
resource "aws_security_group_rule" "ingress_vulnlab_dmz" {
  type              = "ingress"
  from_port         = 40815
  to_port           = 40815
  protocol          = -1
  cidr_blocks       = ["128.177.65.3/32"]
  security_group_id = one(aws_security_group.dmz_sg[*].id)
}
resource "aws_security_group_rule" "ingress_r7vpn_dmz" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  prefix_list_ids   = [aws_ec2_managed_prefix_list.r7_vpnprefixlist.id]
  security_group_id = one(aws_security_group.dmz_sg[*].id)
}
resource "aws_security_group_rule" "ingress_rapid7_dmz" {
  count                    = var.Deployment_Mode != "limited" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.rapid7_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_sg[*].id)
}
resource "aws_security_group_rule" "ingress_dmz_dmz" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
  security_group_id = one(aws_security_group.dmz_sg[*].id)
}
resource "aws_security_group_rule" "eggress_dmz_dmz" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = one(aws_security_group.dmz_sg[*].id)
}
resource "aws_security_group_rule" "ingress_dmz_webapp1_dmz" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" && var.InsightVM_Module != false ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.dmz_webpp1_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_sg[*].id)
}
resource "aws_security_group_rule" "ingress_dmz_webapp2_dmz" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" && var.InsightVM_Module != false ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.dmz_webpp2_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_sg[*].id)
}
resource "aws_security_group_rule" "ingress_alb_dmz" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" && var.InsightVM_Module != false ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.alb_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_sg[*].id)
}

############# DMZ WebApp1 #############
resource "aws_security_group_rule" "ingress_fw_dmz-webapp1" {
  count                    = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" || var.Routing_Type == "pfsense" && var.Deployment_Mode != "custom" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = aws_security_group.fw_sg[count.index].id
  security_group_id        = one(aws_security_group.dmz_webpp1_sg[*].id)
}
resource "aws_security_group_rule" "ingress_fwpub_dmz_webapp1" {
  count                    = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" || var.Routing_Type == "pfsense" && var.Deployment_Mode != "custom" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = aws_security_group.fw_public_sg[count.index].id
  security_group_id        = one(aws_security_group.dmz_webpp1_sg[*].id)
}
resource "aws_security_group_rule" "ingress_dmz_dmz_webapp1" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.dmz_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_webpp1_sg[*].id)
}
resource "aws_security_group_rule" "ingress_jumpbox_dmz_webapp1" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.jumpbox_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_webpp1_sg[*].id)
}
resource "aws_security_group_rule" "ingress_dmz_webapp2_dmz_webapp1" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.dmz_webpp2_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_webpp1_sg[*].id)
}
resource "aws_security_group_rule" "ingress_dmz_webapp1" {
  count             = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
  security_group_id = one(aws_security_group.dmz_webpp1_sg[*].id)
}
resource "aws_security_group_rule" "egress_dmz_webapp1" {
  count             = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = one(aws_security_group.dmz_webpp1_sg[*].id)
}

############# DMZ WebApp2 #############
resource "aws_security_group_rule" "ingress_fw_dmz_webapp2" {
  count                    = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" || var.Routing_Type == "pfsense" && var.Deployment_Mode != "custom" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = aws_security_group.fw_sg[count.index].id
  security_group_id        = one(aws_security_group.dmz_webpp2_sg[*].id)
}
resource "aws_security_group_rule" "ingress_fwpub_dmz_webapp2" {
  count                    = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" || var.Routing_Type == "pfsense" && var.Deployment_Mode != "custom" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = aws_security_group.fw_public_sg[count.index].id
  security_group_id        = one(aws_security_group.dmz_webpp2_sg[*].id)
}
resource "aws_security_group_rule" "ingress_dmz_dmz_webapp2" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.dmz_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_webpp2_sg[*].id)
}
resource "aws_security_group_rule" "ingress_jumpbox_dmz_webapp2" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.jumpbox_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_webpp2_sg[*].id)
}
resource "aws_security_group_rule" "ingress_dmz_webapp1_dmz_webapp2" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.dmz_webpp1_sg[*].id)
  security_group_id        = one(aws_security_group.dmz_webpp2_sg[*].id)
}
resource "aws_security_group_rule" "ingress_dmz_webapp2" {
  count             = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
  security_group_id = one(aws_security_group.dmz_webpp2_sg[*].id)
}
resource "aws_security_group_rule" "egress_dmz_webapp2" {
  count             = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = one(aws_security_group.dmz_webpp2_sg[*].id)
}

############# ECS #############
resource "aws_security_group_rule" "ingress_r7vpn_ecs" {
  count             = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  prefix_list_ids   = [aws_ec2_managed_prefix_list.r7_vpnprefixlist.id]
  security_group_id = one(aws_security_group.ecs_service_sg[*].id)
}
resource "aws_security_group_rule" "ingress_alb2_ecs" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.alb2_sg[*].id)
  security_group_id        = one(aws_security_group.ecs_service_sg[*].id)
}
resource "aws_security_group_rule" "ingress_alb_ecs" {
  count                    = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.alb_sg[*].id)
  security_group_id        = one(aws_security_group.ecs_service_sg[*].id)
}
resource "aws_security_group_rule" "ingress_ecs_ecs" {
  count             = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
  security_group_id = one(aws_security_group.ecs_service_sg[*].id)
}
resource "aws_security_group_rule" "egress_ecs" {
  count             = var.Deployment_Mode != "limited" && var.Deployment_Mode != "custom" ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = one(aws_security_group.ecs_service_sg[*].id)
}


############# POVAgent #############
######EXTERNAL########
resource "aws_security_group_rule" "ingress_r7vpn_povagent_ext" {
  count             = var.POVAgent_Module == true ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  prefix_list_ids   = [aws_ec2_managed_prefix_list.r7_vpnprefixlist.id]
  security_group_id = one(aws_security_group.povagent_ext_sg[*].id)
}
resource "aws_security_group_rule" "ingress_seopsorch_povagent_ext" {
  count             = var.POVAgent_Module == true ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["${var.SEOPS_Orch_IP}"]
  security_group_id = one(aws_security_group.povagent_ext_sg[*].id)
}
resource "aws_security_group_rule" "ingress_povagent_ext_povagent_ext" {
  count             = var.POVAgent_Module == true ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
  security_group_id = one(aws_security_group.povagent_ext_sg[*].id)
}
resource "aws_security_group_rule" "eggress_povagent_ext_sg" {
  count             = var.POVAgent_Module == true ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = one(aws_security_group.povagent_ext_sg[*].id)
}
resource "aws_security_group_rule" "ingress_jumpbox_povagent_ext" {
  count                    = var.Jumpbox_Module == true && var.POVAgent_Module == true ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.jumpbox_sg[*].id)
  security_group_id        = one(aws_security_group.povagent_ext_sg[*].id)
}
######INTERNAL########
resource "aws_security_group_rule" "ingress_povagent_ext_povagent_int" {
  count                    = var.POVAgent_Module == true ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.povagent_ext_sg[*].id)
  security_group_id        = one(aws_security_group.povagent_int_sg[*].id)
}
resource "aws_security_group_rule" "eggress_povagent_int" {
  count             = var.POVAgent_Module == true ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = one(aws_security_group.povagent_int_sg[*].id)
}
resource "aws_security_group_rule" "ingress_jumpbox_povagent_int" {
  count                    = var.Jumpbox_Module == true && var.POVAgent_Module == true ? 1 : 0
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  source_security_group_id = one(aws_security_group.jumpbox_sg[*].id)
  security_group_id        = one(aws_security_group.povagent_int_sg[*].id)
}



############# Not Used #############

# # resource "aws_security_group_rule" "egress-Rapid7-NATGW" {
# #   type                      = "egress"
# #   from_port                 = 0
# #   to_port                   = 0
# #   protocol                  = -1
# #   source_security_group_id  = aws_security_group.nat_gateway_sg.id
# #   security_group_id         = one(aws_security_group.rapid7_sg[*].id)
# # }
# resource "aws_security_group_rule" "egress-Rapid7-DMZ" {
#   type                      = "egress"
#   from_port                 = 0
#   to_port                   = 0
#   protocol                  = -1
#   source_security_group_id  = aws_security_group.fw_sg.id
#   security_group_id         = one(aws_security_group.rapid7_sg[*].id)
# }
# resource "aws_security_group_rule" "egress-Rapid7-IT" {
#   type                      = "egress"
#   from_port                 = 0
#   to_port                   = 0
#   protocol                  = -1
#   source_security_group_id  = one(aws_security_group.it_sg[*].id)
#   security_group_id         = one(aws_security_group.rapid7_sg[*].id)
# }
# resource "aws_security_group_rule" "egress-Rapid7-HQ" {
#   type                      = "egress"
#   from_port                 = 0
#   to_port                   = 0
#   protocol                  = -1
#   source_security_group_id  = one(aws_security_group.hq_sg[*].id)
#   security_group_id         = one(aws_security_group.rapid7_sg[*].id)
# }





# resource "aws_security_group_rule" "ingress-DMZ-HQ" {
#   type                      = "ingress"
#   from_port                 = 0
#   to_port                   = 0
#   protocol                  = -1
#   source_security_group_id  = one(aws_security_group.hq_sg[*].id)
#   security_group_id         = aws_security_group.fw_sg.id
# }
# resource "aws_security_group_rule" "ingress-DMZ-IT" {
#   type                      = "ingress"
#   from_port                 = 0
#   to_port                   = 0
#   protocol                  = -1
#   source_security_group_id  = one(aws_security_group.it_sg[*].id)
#   security_group_id         = aws_security_group.fw_sg.id
# }
# # resource "aws_security_group_rule" "egress-DMZ-NATGW" {
# #   type                      = "egress"
# #   from_port                 = 0
# #   to_port                   = 0
# #   protocol                  = -1
# #   source_security_group_id  = aws_security_group.nat_gateway_sg.id
# #   security_group_id         = one(aws_security_group.dmz_sg[*].id)
# # }
# resource "aws_security_group_rule" "egress-DMZ-Rapid7" {
#   type                      = "egress"
#   from_port                 = 0
#   to_port                   = 0
#   protocol                  = -1
#   source_security_group_id  = one(aws_security_group.rapid7_sg[*].id)
#   security_group_id         = aws_security_group.fw_sg.id
# }
# resource "aws_security_group_rule" "egress-DMZ-IT" {
#   type                      = "egress"
#   from_port                 = 0
#   to_port                   = 0
#   protocol                  = -1
#   source_security_group_id  = one(aws_security_group.it_sg[*].id)
#   security_group_id         = aws_security_group.fw_sg.id
# }
# resource "aws_security_group_rule" "egress-DMZ-HQ" {
#   type                      = "egress"
#   from_port                 = 0
#   to_port                   = 0
#   protocol                  = -1
#   source_security_group_id  = one(aws_security_group.hq_sg[*].id)
#   security_group_id         = aws_security_group.fw_sg.id
# }


#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Network Interface                                                                                                                                                                                                                              
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# FW #############
resource "aws_network_interface" "fw_public_eni" {
  count           = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" || var.Routing_Type == "pfsense" && var.Deployment_Mode != "custom" ? 1 : 0
  description     = "Public-ENI"
  subnet_id       = aws_subnet.subnet_fw[count.index].id
  private_ips     = ["10.0.0.254"]
  security_groups = [aws_security_group.fw_public_sg[count.index].id]

  source_dest_check = false
  tags = {
    "Name"        = "${var.Tenant}-Public-ENI"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_network_interface" "fw_publicprivate_eni" {
  count             = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" || var.Routing_Type == "pfsense" && var.Deployment_Mode != "custom" ? 1 : 0
  description       = "PublicPrivate-ENI"
  subnet_id         = aws_subnet.subnet_fw_intra[count.index].id
  private_ips       = ["10.0.3.254"]
  security_groups   = [aws_security_group.fw_public_sg[count.index].id]
  source_dest_check = false
  tags = {
    "Name"        = "${var.Tenant}-PublicPrivate-ENI"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_network_interface" "fw_private_eni" {
  count             = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" || var.Routing_Type == "pfsense" && var.Deployment_Mode != "custom" ? 1 : 0
  description       = "FW-Private-ENI"
  subnet_id         = aws_subnet.subnet_fw[count.index].id
  private_ips       = ["10.0.0.253"]
  security_groups   = [aws_security_group.fw_public_sg[count.index].id]
  source_dest_check = false
  tags = {
    "Name"        = "${var.Tenant}-FW-Private-ENI"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# DMZ #############
resource "aws_network_interface" "dmz_eni" {
  count             = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" || var.Routing_Type == "pfsense" && var.Deployment_Mode != "custom" ? 1 : 0
  description       = "DMZ-ENI"
  subnet_id         = one(aws_subnet.subnet_dmz[*].id)
  private_ips       = ["10.0.2.254"]
  security_groups   = [one(aws_security_group.dmz_sg[*].id)]
  source_dest_check = false
  tags = {
    "Name"        = "${var.Tenant}-DMZ-ENI"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# IT #############
resource "aws_network_interface" "it_eni" {
  count             = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" || var.Routing_Type == "pfsense" && var.Deployment_Mode != "custom" ? 1 : 0
  description       = "IT-ENI"
  subnet_id         = one(aws_subnet.subnet_it[*].id)
  private_ips       = ["10.0.10.254"]
  security_groups   = [one(aws_security_group.it_sg[*].id)]
  source_dest_check = false
  tags = {
    "Name"        = "${var.Tenant}-IT-ENI"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# HQ #############
resource "aws_network_interface" "hq_eni" {
  count             = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" && var.Deployment_Mode != "partial" && var.Deployment_Mode != "custom" ? 1 : 0
  description       = "HQ-ENI"
  subnet_id         = one(aws_subnet.subnet_hq[*].id)
  private_ips       = ["10.0.20.254"]
  security_groups   = [one(aws_security_group.hq_sg[*].id)]
  source_dest_check = false
  tags = {
    "Name"        = "${var.Tenant}-HQ-ENI"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Rapid7 #############
resource "aws_network_interface" "rapid7_eni" {
  count             = var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" || var.Routing_Type == "pfsense" && var.Deployment_Mode == "custom" ? 1 : 0
  description       = "RAPID7-ENI"
  subnet_id         = one(aws_subnet.subnet_rapid7[*].id)
  private_ips       = ["10.0.7.254"]
  security_groups   = [one(aws_security_group.rapid7_sg[*].id)]
  source_dest_check = false
  tags = {
    "Name"        = "${var.Tenant}-RAPID7-ENI"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

############# Jumpbox #############
resource "aws_network_interface" "jumpbox_eni" {
  count             = var.Jumpbox_Module == true && var.Routing_Type == "pfsense" && var.Deployment_Mode != "limited" || var.Jumpbox_Module == true && var.Routing_Type == "pfsense" && var.Deployment_Mode != "custom" ? 1 : 0
  description       = "JUMPBOX-ENI"
  subnet_id         = one(aws_subnet.subnet_jumpbox[*].id)
  private_ips       = ["10.0.1.254"]
  security_groups   = [one(aws_security_group.jumpbox_sg[*].id)]
  source_dest_check = false
  tags = {
    "Name"        = "${var.Tenant}-JUMPBOX-ENI"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}


#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  S3 Endpoint                                                                                                                                                                                                                      
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.AWS_Region}.s3"
  route_table_ids = compact([
    one(aws_route_table.hq[*].id),
    one(aws_route_table.it[*].id),
    one(aws_route_table.jumpbox[*].id),
    one(aws_route_table.public[*].id),
    one(aws_route_table.rapid7[*].id),
    aws_route_table.public_rt.id,
    one(aws_route_table.nat_gateway[*].id)
  ])

  tags = {
    "Name"        = "${var.Tenant}-S3-Endpoint"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Application Load Balancer                                                                                                                                                                                                               
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# ALB #############
resource "aws_lb" "alb_webapps" {
  count                      = var.Deployment_Mode != "limited" && var.use_route53_hz == true ? 1 : 0
  name                       = "${lower(var.Tenant)}-webapps-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [one(aws_security_group.alb_sg[*].id), one(aws_security_group.alb2_sg[*].id)]
  subnets                    = [one(aws_subnet.subnet_rapid7[*].id), one(aws_subnet.subnet_dmz_webapp1[*].id), one(aws_subnet.subnet_dmz_webapp2[*].id)]
  ip_address_type            = "ipv4"
  enable_deletion_protection = false
  tags = {
    "Name"    = "${var.Tenant}-WEBAPPS-ALB"
    "Tenant"  = "${var.Tenant}"
    "JIRA_ID" = "${var.JIRA_ID}"
  }
}

resource "aws_lb" "alb_ivm" {
  count                      = var.Deployment_Mode != "limited" && var.use_route53_hz == true ? 1 : 0
  name                       = "${lower(var.Tenant)}-ivm-alb"
  load_balancer_type         = "application"
  security_groups            = [one(aws_security_group.alb_sg[*].id), one(aws_security_group.alb2_sg[*].id)]
  subnets                    = [one(aws_subnet.subnet_rapid7[*].id), one(aws_subnet.subnet_dmz_webapp1[*].id), one(aws_subnet.subnet_dmz_webapp2[*].id)]
  ip_address_type            = "ipv4"
  enable_deletion_protection = false
  tags = {
    "Name"    = "${var.Tenant}-IVM-ALB"
    "Tenant"  = "${var.Tenant}"
    "JIRA_ID" = "${var.JIRA_ID}"
  }
}

############# ALB : Listener #############
resource "aws_lb_listener" "webapps80" {
  count             = var.Deployment_Mode != "limited" && var.use_route53_hz == true ? 1 : 0
  load_balancer_arn = aws_lb.alb_webapps[count.index].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "It's a Trap !!"
      status_code  = "503"
    }
  }
  tags = {
    "Name"        = "${var.Tenant}-ALB-LISTENER-80"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_lb_listener" "webapps443" {
  count             = var.Deployment_Mode != "limited" && var.use_route53_hz == true && var.POVAgent_Module == false || var.Deployment_Mode != "custom" && var.use_route53_hz && var.POVAgent_Module == false || var.Deployment_Mode != "custom" && var.use_route53_hz == true && var.POVAgent_Module == false ? 1 : 0
  load_balancer_arn = aws_lb.alb_webapps[count.index].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
  certificate_arn   = var.use_route53_hz ? module.acm[0].acm_certificate_arn : null
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "It's a Trap !!"
      status_code  = "503"
    }
  }
  tags = {
    "Name"        = "${var.Tenant}-ALB-LISTENER-443"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_lb_listener" "ivm443" {
  count             = var.Deployment_Mode != "limited" && var.use_route53_hz == true && var.POVAgent_Module == false || var.Deployment_Mode != "custom" && var.use_route53_hz && var.POVAgent_Module == false || var.Deployment_Mode != "custom" && var.use_route53_hz == true && var.POVAgent_Module == false ? 1 : 0
  load_balancer_arn = aws_lb.alb_ivm[count.index].arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
  certificate_arn   = var.use_route53_hz ? module.acmivm[0].acm_certificate_arn : null
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "It's a Trap !!"
      status_code  = "503"
    }
  }
  tags = {
    "Name"        = "${var.Tenant}-ALB-LISTENER-443"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_lb_listener" "webapps8025" {
  count             = var.Deployment_Mode != "limited" && var.use_route53_hz == true && var.POVAgent_Module == false || var.Deployment_Mode != "custom" && var.use_route53_hz == true && var.POVAgent_Module == false ? 1 : 0
  load_balancer_arn = aws_lb.alb_webapps[count.index].arn
  port              = "8025"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "It's a Trap !!"
      status_code  = "503"
    }
  }
  tags = {
    "Name"        = "${var.Tenant}-ALB-LISTENER-8025"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
