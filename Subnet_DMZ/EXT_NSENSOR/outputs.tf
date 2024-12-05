#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                               Rapid7 Subnet Network Sensor Outputs Definitions                                                                #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Network Sensor                                                                                                                                                                                                                                                      
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Instance ID #############
output "traffic_nic_id" {
description = "List of private IP addresses ENI"
value       = one(aws_instance.nsensor_node[*].primary_network_interface_id)
}

############# Instance IP #############
output "traffic_nic_ip" {
description = "List of private IP addresses ENI"
value       = one(aws_network_interface.traffic_nic[*].private_ip)
}

############# Instance ID #############
output "traffic_instance" {
description = "Traffic Instance ID"
value       = one(aws_instance.nsensor_node[*].id)
}