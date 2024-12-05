#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                              S3  Main                                                                                         #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  S3 Bucket                                                                                                                                                                                                                                                          
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_s3_bucket" "s3" {
  bucket = var.Bucket_Name
  tags = {
    "Name"        = "Rapid7-S3Bucket"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

resource "aws_s3_bucket" "s3awscli" {
  count  = var.POVAgent_Module == true ? 1 : 0
  bucket = var.Bucket_Name_Agent
  tags = {
    "Name"        = "Rapid7-S3Bucket"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  S3 Bucket Ownership                                                                                                                                                                                                                                                       
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_s3_bucket_ownership_controls" "terraform" {
  bucket = aws_s3_bucket.s3.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_ownership_controls" "awscli" {
  count  = var.POVAgent_Module == true ? 1 : 0
  bucket = aws_s3_bucket.s3awscli[0].id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  S3 Bucket ACL                                                                                                                                                                                                                                                       
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_s3_bucket_acl" "terraform" {
  depends_on = [aws_s3_bucket_ownership_controls.terraform]
  bucket     = aws_s3_bucket.s3.id
  acl        = "private"
}

resource "aws_s3_bucket_acl" "awscli" {
  count      = var.POVAgent_Module == true ? 1 : 0
  depends_on = [aws_s3_bucket_ownership_controls.awscli]
  bucket     = aws_s3_bucket.s3awscli[0].id
  acl        = "private"
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  S3 Bucket Obkects                                                                                                                                                                                                                                                       
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# Upload an object
# resource "aws_s3_object" "object" {
#   for_each    = { for file in fileset("./s3bucket/files/", "*") : file => file if file != ".DS_Store" }
#   bucket      = aws_s3_bucket.s3.id
#   key         = each.value
#   source      = "./s3bucket/files/${each.value}"
#   source_hash = filemd5("./s3bucket/files/${each.value}")
#   tags = {
#     "Name"        = "${var.Tenant}-S3Bucket"
#     "Tenant"      = "${var.Tenant}"
#     "Owner_Email" = "${var.Owner_Email}"
#     "JIRA_ID"     = "${var.JIRA_ID}"
#   }
# }

resource "aws_s3_object" "object" {
  for_each = {
    for file in fileset("${path.module}/files/", "**/*") : file => file if length(regexall(".*\\.DS_Store$", file)) == 0 && file != "${path.module}/files/"
  }

  bucket      = aws_s3_bucket.s3.id
  key         = replace(each.value, "${path.module}/files/", "")                                    # Remove the local path prefix
  source      = "${path.module}/files/${replace(each.value, "${path.module}/files/", "")}"          # Ensure it points to the correct source path
  source_hash = filemd5("${path.module}/files/${replace(each.value, "${path.module}/files/", "")}") # Ensure it points to the correct file

  tags = {
    "Name"        = "${var.Tenant}-S3Bucket"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}


resource "aws_s3_object" "object-awscli" {
  for_each = var.POVAgent_Module ? {
    for file in fileset("${path.module}/files_awscli/", "**/*") : file => file if length(regexall(".*\\.DS_Store$", file)) == 0 && file != "${path.module}/files_awscli/"
  } : {}

  bucket      = aws_s3_bucket.s3awscli[0].id
  key         = replace(each.value, "${path.module}/files_awscli/", "")                                           # Remove the local path prefix
  source      = "${path.module}/files_awscli/${replace(each.value, "${path.module}/files_awscli/", "")}"          # Ensure it points to the correct source path
  source_hash = filemd5("${path.module}/files_awscli/${replace(each.value, "${path.module}/files_awscli/", "")}") # Ensure it points to the correct file

  tags = {
    "Name"        = "${var.Tenant}-S3Bucket-AWSCLI"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
