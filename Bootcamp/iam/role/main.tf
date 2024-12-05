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
    "Lab_Number"  = "IAM"
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

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  IAM Instance Profile                                                                                                                                                                                                                                                                         
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_iam_instance_profile" "rapid7_terraform_instance_profile" {
  name = var.Instance_Profile_Name
  role = aws_iam_role.rapid7_terraform_role.name
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
# resource "aws_key_pair" "key_name_internal" {
#   key_name   = var.Key_Name_Internal
#   public_key = tls_private_key.key_name_internal.public_key_openssh
#   provisioner "local-exec" {
#     command = "echo '${tls_private_key.key_name_internal.private_key_pem}' > ./certificates/${var.Key_Name_Internal}.pem"
#   }
# }
# #Resource to Download Key Pair on Windows
# resource "local_file" "local_Key_Name_Internal" {
#   filename = "${var.Key_Name_Internal}.pem"
#   file_permission = "0400"
#   content = tls_private_key.Key_Name_Internal.private_key_pem
# }
resource "aws_key_pair" "key_name_internal" {
  key_name   = var.Key_Name_Internal
  public_key = tls_private_key.key_name_internal.public_key_openssh
}
resource "local_file" "key_name_internal_private_key" {
  filename        = "./certificates/${var.Key_Name_Internal}.pem"
  file_permission = "0400"
  content         = tls_private_key.key_name_internal.private_key_pem
  depends_on      = [aws_key_pair.key_name_internal]
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  S3 Bucket Obkects                                                                                                                                                                                                                                                       
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# Upload an object
resource "aws_s3_object" "certs" {
  for_each    = fileset("./certificates/", "user-${var.Lab_Number}-BootCamp_Lab_Internal.pem")
  bucket      = var.Bucket_Name
  key         = each.value
  source      = "./certificates/${each.value}"
  source_hash = filemd5("./certificates/${each.value}")
  tags = {
    "Name"        = "${var.Tenant}-S3Bucket"
    "Tenant"      = "${var.Tenant}"
    "Lab_Number"  = "IAM"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
  depends_on = [local_file.key_name_internal_private_key]
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  SSH Key Pair + Certificate - External                                                                                                                                                                                                                                                                 
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# resource "aws_key_pair" "key_name_external" {
#   key_name   = var.Key_Name_External
#   public_key = tls_private_key.key_name_external.public_key_openssh
#   provisioner "local-exec" {
#     command = "echo '${tls_private_key.key_name_external.private_key_pem}' > ./certificates/${var.Key_Name_External}.pem"
#   }
# }
# #Resource to Download Key Pair on Windows
# resource "local_file" "local_Key_Name_External" {
#   filename = "${var.Key_Name_External}.pem"
#   file_permission = "0400"
#   content = tls_private_key.Key_Name_External.private_key_pem
# }
resource "aws_key_pair" "key_name_external" {
  key_name   = var.Key_Name_External
  public_key = tls_private_key.key_name_external.public_key_openssh
}
resource "local_file" "key_name_external_private_key" {
  filename        = "./certificates/${var.Key_Name_External}.pem"
  file_permission = "0400"
  content         = tls_private_key.key_name_external.private_key_pem
  depends_on      = [aws_key_pair.key_name_external]
}
