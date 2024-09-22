
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}
# variable "environment" {
#   description = "Environment tag for this resources"
#   type        = string
# }

data "aws_s3_bucket" "name" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_lifecycle_configuration" "name" {
  bucket = data.aws_s3_bucket.name.id

  rule {
    id = "rule-1"
    filter {
      prefix = "phi/"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    status = "Enabled"
  }
}