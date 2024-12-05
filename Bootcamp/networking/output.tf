output "vpc_dhcp_options_in_terraform_state" {
  value = aws_vpc.vpc.dhcp_options_id
}
output "vpc_dhcp_options_in_aws" {
  value = aws_vpc_dhcp_options.dhcp.id
}
output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}
output "private_subnet_idr_id" {
  value = aws_subnet.private_subnet_idr.id
}
output "private_subnet_ivm_id" {
  value = aws_subnet.private_subnet_ivm.id
}
output "private_subnet_ias_id" {
  value = aws_subnet.private_subnet_ias.id
}
output "private_subnet_icon_id" {
  value = aws_subnet.private_subnet_icon.id
}
output "ig_id" {
  value = aws_internet_gateway.ig.id
}
output "external_sg_id" {
  value = aws_security_group.external_sg.id
}
output "internal_sg_id" {
  value = aws_security_group.internal_sg.id
}
