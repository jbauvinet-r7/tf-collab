#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                       Networking Outputs                                                                                      #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  VPC                                                                                                                                                                                                                                                          
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
output "vpc_id" {
  value = aws_vpc.main.id
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Route Table                                                                                                                                                                                                                                                     
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# output "route_NAT_GW" {
#   value = "${aws_route_table.nat_gateway.id}"
# }


#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Prefix Lists                                                                                                                                                                                                                                       
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# IAS Cloud Engines #############
output "ias_engine_prefix_id" {
  value = aws_ec2_managed_prefix_list.r7_iasengineprefixlist.id
}

############# R7 VPN #############
output "r7_vpn_prefix_id" {
  value = aws_ec2_managed_prefix_list.r7_vpnprefixlist.id
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Subnets                                                                                                                                                                                                                                      
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# output "subnet_nat_id" {
#   value = "${aws_subnet.subnet_NAT.id}"
# }
# output "subnet_admin_jumpbox_id" {
#   value = "${aws_subnet.subnet_Admin_JUMPBOX.id}"
# }
# output "subnet_IDR" {
#   value = "${aws_subnet.subnet_IDR.id}"
# }

############# DMZ #############
output "subnet_dmz_id" {
  value = one(aws_subnet.subnet_dmz[*].id)
}

############# DMZ WebApp1 #############
output "subnet_dmzwebapp1_id" {
  value = one(aws_subnet.subnet_dmz_webapp1[*].id)
}

############# DMZ WebApp2 #############
output "subnet_dmzwebapp2_id" {
  value = one(aws_subnet.subnet_dmz_webapp2[*].id)
}

############# FW Intra #############
output "subnet_fw_intra_id" {
  value = one(aws_subnet.subnet_fw_intra[*].id)
}

############# IT #############
output "subnet_it_id" {
  value = one(aws_subnet.subnet_it[*].id)
}

############# HQ #############
output "subnet_hq_id" {
  value = one(aws_subnet.subnet_hq[*].id)
}

############# POVAgent #############
output "subnet_povagent_ext_id" {
  value = one(aws_subnet.subnet_povagent_ext[*].id)
}
output "subnet_povagent_int_id" {
  value = one(aws_subnet.subnet_povagent_int[*].id)
}

############# Jumpbox #############
output "subnet_jumpbox_id" {
  value = one(aws_subnet.subnet_jumpbox[*].id)
}

############# Rapid7 #############
output "subnet_rapid7_id" {
  value = one(aws_subnet.subnet_rapid7[*].id)
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Security Groups                                                                                                                                                                                                                                 
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# output "external_admin_jumpbox_sg" {
#   value = "${aws_security_group.external_admin_jumpbox_sg.id}"
# }
# output "nat_gateway_sg" {
#   value = "${aws_security_group.nat_gateway_sg.id}"
# }
# output "global_idr_gateway_sg" {
#   value = "${aws_security_group.global_idr_gateway_sg.id}"
# }

############# FW Intra #############
output "sg_fw_id" {
  value = one(aws_security_group.fw_sg[*].id)
}

############# FW Pub #############
output "sg_fw_public_id" {
  value = one(aws_security_group.fw_public_sg[*].id)
}

############# DMZ #############
output "sg_dmz_id" {
  value = one(aws_security_group.dmz_sg[*].id)
}

############# DMZ IVM #############
output "sg_dmz_ivm_id" {
  value = one(aws_security_group.dmz_ivm_sg[*].id)
}

############# DMZ IVM #############
output "sg_dmz_ivm_ltd_id" {
  value = one(aws_security_group.dmz_ivm_ltd_sg[*].id)
}

############# POVAgent #############
output "sg_povagent_ext_id" {
  value = one(aws_security_group.povagent_ext_sg[*].id)
}
output "sg_povagent_int_id" {
  value = one(aws_security_group.povagent_int_sg[*].id)
}

############# HQ #############
output "sg_hq_id" {
  value = one(aws_security_group.hq_sg[*].id)
}

############# IT #############
output "sg_it_id" {
  value = one(aws_security_group.it_sg[*].id)
}

############# Jumpbox #############
output "sg_jumpbox_id" {
  value = one(aws_security_group.jumpbox_sg[*].id)
}

############# Rapid7 #############
output "sg_rapid7_id" {
  value = one(aws_security_group.rapid7_sg[*].id)
}

############# ECS #############
output "ecs_service_sg_id" {
  value = one(aws_security_group.ecs_service_sg[*].id)
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Network Interface                                                                                                                                                                                                                              
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# FW #############
output "eni_fw_publicprivate_id" {
  value = one(aws_network_interface.fw_publicprivate_eni[*].id)
}
output "eni_fw_int_id" {
  value = one(aws_network_interface.fw_private_eni[*].id)
}
output "eni_fw_public_id" {
  value = one(aws_network_interface.fw_public_eni[*].id)
}

############# DMZ #############
output "eni_dmz_id" {
  value = one(aws_network_interface.dmz_eni[*].id)
}

############# HQ #############
output "eni_hq_id" {
  value = one(aws_network_interface.hq_eni[*].id)
}

############# IT #############
output "eni_it_id" {
  value = one(aws_network_interface.it_eni[*].id)
}

############# Jumpbox #############
output "eni_jumpbox_id" {
  value = one(aws_network_interface.jumpbox_eni[*].id)
}

############# Rapid7 #############
output "eni_rapid7_id" {
  value = one(aws_network_interface.rapid7_eni[*].id)
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Application Load Balancer                                                                                                                                                                                                               
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# ALB #############
output "aws_lb_alb_webapps_dnsname" {
  value = one(aws_lb.alb_webapps[*].dns_name)
}
output "aws_lb_alb_webapps_zoneid" {
  value = one(aws_lb.alb_webapps[*].zone_id)
}
output "aws_lb_alb_ivm_dnsname" {
  value = one(aws_lb.alb_ivm[*].dns_name)
}
output "aws_lb_alb_ivm_zoneid" {
  value = one(aws_lb.alb_ivm[*].zone_id)
}

############# ALB : Listener #############
output "aws_lb_listener_webapps80_id" {
  value = one(aws_lb_listener.webapps80[*].id)
}
output "aws_lb_listener_webapps443_id" {
  value = one(aws_lb_listener.webapps443[*].id)
}
output "aws_lb_listener_ivm443_id" {
  value = one(aws_lb_listener.ivm443[*].id)
}
output "aws_lb_listener_webapps8025_id" {
  value = one(aws_lb_listener.webapps8025[*].id)
}
