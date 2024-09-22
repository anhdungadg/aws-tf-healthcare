variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}
variable "environment" {
  description = "Environment tag for this resources"
  type        = string
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  
  tags = {
    Name = var.bucket_name
    Environment = var.environment
  }
}

output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}
