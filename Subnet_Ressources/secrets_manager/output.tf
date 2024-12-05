#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                       Secrets Manager Outputs                                                                                 #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Credentials                                                                                                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
output "sm_idr_service_account_pwd_arn" {
  value = aws_secretsmanager_secret_version.idr_service_account_pwd.arn
}
output "sm_AdminSafeModePassword_arn" {
  value = aws_secretsmanager_secret_version.AdminSafeModePassword.arn
}
output "sm_Password_arn" {
  value = aws_secretsmanager_secret_version.Password.arn
}
output "sm_AdminPD_arn" {
  value = aws_secretsmanager_secret_version.AdminPD.arn
}
