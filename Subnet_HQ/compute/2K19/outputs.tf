#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                   Subnet HQ 2k19 Outputs Definitions                                                                          #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  2K19                                                                                                                                                                                                                                                    
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
output "private_ip_eni_id" {
  description = "List of private IP address ENI AD"
  value       = one(aws_instance.win2k19_node[*].primary_network_interface_id)
}