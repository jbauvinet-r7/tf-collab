#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                            IAM Main                                                                                           #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  IAM Policy                                                                                                                                                                                                                                                                          
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_iam_policy" "rapid7_terraform_iam_policy" {
  name = var.Iam_Policy_Name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : "s3:ListBucket",
        "Resource" : "arn:aws:s3:::${var.Bucket_Name}",
        "Condition" : {
          "StringLike" : {
            "s3:prefix" : "*"
          }
        }
      },
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : "s3:GetBucketLocation",
        "Resource" : "arn:aws:s3:::${var.Bucket_Name}/"
      },
      {
        "Sid" : "VisualEditor2",
        "Effect" : "Allow",
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${var.Bucket_Name}/*"
      },
      {
        "Sid" : "VisualEditor3",
        "Effect" : "Allow",
        "Action" : "s3:ListAllMyBuckets",
        "Resource" : "arn:aws:s3:::${var.Bucket_Name}/"
      },
      {
        "Action" : [
          "secretsmanager:GetSecretValue"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_policy" "rapid7_amilinuxaws_iam_policy" {
  count = var.POVAgent_Module ? 1 : 0
  name  = "${var.Iam_Policy_Name}-amilinuxaws"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Group s3 bucket-related actions
      {
        "Sid" : "S3BucketActions",
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        "Resource" : "arn:aws:s3:::${var.Bucket_Name}"
      },
      {
        "Sid" : "S3ObjectActions",
        "Effect" : "Allow",
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${var.Bucket_Name}/*"
      },
      # Agent-specific bucket actions
      {
        "Sid" : "S3BucketAgentActions",
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        "Resource" : "arn:aws:s3:::${var.Bucket_Name_Agent}"
      },
      {
        "Sid" : "S3ObjectAgentActions",
        "Effect" : "Allow",
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${var.Bucket_Name_Agent}/*"
      },
      # SecretsManager and SSM actions
      {
        "Sid" : "SecretsManagerGetSecret",
        "Effect" : "Allow",
        "Action" : "secretsmanager:GetSecretValue",
        "Resource" : "*"
      },
      {
        "Sid" : "SSMGetParameters",
        "Effect" : "Allow",
        "Action" : "ssm:GetParameters",
        "Resource" : "*"
      },
      # CloudFormation and IAM actions
      {
        "Sid" : "CloudFormationStackActions",
        "Effect" : "Allow",
        "Action" : [
          "cloudformation:CreateStack",
        "cloudformation:DeleteStack"],
        "Resource" : "*"
      },
      {
        "Sid" : "IAMRoleActions",
        "Effect" : "Allow",
        "Action" : [
          "iam:*" # Allows tagging IAM roles
        ],
        "Resource" : "*"
      },
      # EC2 management actions
      {
        "Sid" : "EC2InstanceActions",
        "Effect" : "Allow",
        "Action" : [
          "ec2:RunInstances",
          "ec2:DescribeInstances",
          "ec2:TerminateInstances",
          "ec2:CreateTags" # Allows tagging EC2 resources
        ],
        "Resource" : "*"
      }
    ]
  })
}


#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  IAM Role                                                                                                                                                                                                                                                                          
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_iam_role" "rapid7_terraform_role" {
  name = var.Role_Name

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  tags = {
    "Name"        = "${var.Tenant}-rapid7_terraform_role"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

resource "aws_iam_role" "rapid7_amilinuxaws_role" {
  count = var.POVAgent_Module == true ? 1 : 0
  name  = "${var.Role_Name}-amilinuxaws"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  tags = {
    "Name"        = "${var.Tenant}-rapid7_ami_linux_aws_role"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  IAM Policy Attachment                                                                                                                                                                                                                                                                          
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_iam_policy_attachment" "rapid7_terraform_role_policy_attachment" {
  name       = "Policy Attachement"
  policy_arn = aws_iam_policy.rapid7_terraform_iam_policy.arn
  roles      = [aws_iam_role.rapid7_terraform_role.name]
}

resource "aws_iam_policy_attachment" "rapid7_amilinuxaws_role_policy_attachment" {
  count      = var.POVAgent_Module == true ? 1 : 0
  name       = "Policy Attachement AMI AWS LINUX"
  policy_arn = aws_iam_policy.rapid7_amilinuxaws_iam_policy[0].arn
  roles      = [aws_iam_role.rapid7_amilinuxaws_role[0].name]
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  IAM Instance Profile                                                                                                                                                                                                                                                                         
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_iam_instance_profile" "rapid7_terraform_instance_profile" {
  name = var.Instance_Profile_Name
  role = aws_iam_role.rapid7_terraform_role.name
}

resource "aws_iam_instance_profile" "rapid7_amilinuxaws_instance_profile" {
  count = var.POVAgent_Module == true ? 1 : 0
  name  = "${var.Instance_Profile_Name}-amiawslinux"
  role  = aws_iam_role.rapid7_amilinuxaws_role[0].name
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  SSH Private Key                                                                                                                                                                                                                                                                      
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "tls_private_key" "key_name_internal" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "tls_private_key" "key_name_external" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  SSH Key Pair + Certificate - Internal                                                                                                                                                                                                                                                                 
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_key_pair" "key_name_internal" {
  key_name   = var.Key_Name_Internal
  public_key = tls_private_key.key_name_internal.public_key_openssh
  provisioner "local-exec" {
    command = "echo '${tls_private_key.key_name_internal.private_key_pem}' > ./certificates/${var.Key_Name_Internal}.pem"
  }
}
# #Resource to Download Key Pair on Windows
# resource "local_file" "local_Key_Name_Internal" {
#   filename = "${var.Key_Name_Internal}.pem"
#   file_permission = "0400"
#   content = tls_private_key.Key_Name_Internal.private_key_pem
# }

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  SSH Key Pair + Certificate - External                                                                                                                                                                                                                                                                 
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_key_pair" "key_name_external" {
  key_name   = var.Key_Name_External
  public_key = tls_private_key.key_name_external.public_key_openssh
  provisioner "local-exec" {
    command = "echo '${tls_private_key.key_name_external.private_key_pem}' > ./certificates/${var.Key_Name_External}.pem"
  }
}
# #Resource to Download Key Pair on Windows
# resource "local_file" "local_Key_Name_External" {
#   filename = "${var.Key_Name_External}.pem"
#   file_permission = "0400"
#   content = tls_private_key.Key_Name_External.private_key_pem
# }
