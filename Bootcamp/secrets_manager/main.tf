#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                            Secrets Manager Main                                                                               #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Secrets Manager                                                                                                                                                                                                                                                         
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_secretsmanager_secret" "idr_service_account_pwd" {
  name                    = "${var.Tenant}-idr_service_account_pwd"
  recovery_window_in_days = "0"
  tags = {
    "Name"        = "Secrets_Manager-idr_service_account_pwd"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "SecretManager"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_secretsmanager_secret_version" "idr_service_account_pwd" {
  secret_id     = aws_secretsmanager_secret.idr_service_account_pwd.id
  secret_string = var.idr_service_account_pwd
}

resource "aws_secretsmanager_secret" "AdminSafeModePassword" {
  name                    = "${var.Tenant}-AdminSafeModePassword"
  recovery_window_in_days = "0"
  tags = {
    "Name"        = "Secrets_Manager-AdminSafeModePassword"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "SecretManager"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_secretsmanager_secret_version" "AdminSafeModePassword" {
  secret_id     = aws_secretsmanager_secret.AdminSafeModePassword.id
  secret_string = var.AdminSafeModePassword
}

resource "aws_secretsmanager_secret" "Password" {
  recovery_window_in_days = "0"
  name                    = "${var.Tenant}-Password"
  tags = {
    "Name"        = "Secrets_Manager-Password"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "SecretManager"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_secretsmanager_secret_version" "Password" {
  secret_id     = aws_secretsmanager_secret.Password.id
  secret_string = var.Password
}

resource "aws_secretsmanager_secret" "AdminPD" {
  name                    = "${var.Tenant}-AdminPD"
  recovery_window_in_days = "0"
  tags = {
    "Name"        = "Secrets_Manager-AdminPD"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "SecretManager"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_secretsmanager_secret_version" "AdminPD" {
  secret_id     = aws_secretsmanager_secret.AdminPD.id
  secret_string = var.AdminPD
}

resource "aws_secretsmanager_secret" "RandomP" {
  name                    = "${var.Tenant}-RandomP"
  recovery_window_in_days = "0"
  tags = {
    "Name"        = "Secrets_Manager-RandomP"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "SecretManager"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_secretsmanager_secret_version" "RandomP" {
  secret_id     = aws_secretsmanager_secret.RandomP.id
  secret_string = var.RandomP
}

resource "aws_vpc_endpoint" "secrets_manager" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.AWS_Region}.secretsmanager"
  vpc_endpoint_type = "Interface"
  tags = {
    "Name"        = "VPC_Endpoint_Secrets_Manager"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "SecretManager"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

