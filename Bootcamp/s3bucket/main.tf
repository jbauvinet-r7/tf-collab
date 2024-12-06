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
    "Lab_Number"  = "S3Bucket"
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

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  S3 Bucket ACL                                                                                                                                                                                                                                                       
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_s3_bucket_acl" "terraform" {
  depends_on = [aws_s3_bucket_ownership_controls.terraform]
  bucket     = aws_s3_bucket.s3.id
  acl        = "private"
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  S3 Bucket Obkects                                                                                                                                                                                                                                                       
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
# Upload an object
resource "aws_s3_object" "object" {
  for_each = {
    for file in fileset("${path.module}/../../s3bucket/files/", "**/*") : file => file
    if !(file == ".DS_Store" || file == "${path.module}/../../s3bucket/files/")
  }

  bucket      = aws_s3_bucket.s3.id
  key         = replace(each.value, "${path.module}/../../s3bucket/files/", "")                                                   # Remove the local path prefix
  source      = "${path.module}/../../s3bucket/files/${replace(each.value, "${path.module}/../../s3bucket/files/", "")}"          # Correct source path
  source_hash = filemd5("${path.module}/../../s3bucket/files/${replace(each.value, "${path.module}/../../s3bucket/files/", "")}") # Correct file path

  tags = {
    "Name"        = "${var.Tenant}-S3Bucket"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
