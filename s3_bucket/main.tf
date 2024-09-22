variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}
variable "environment" {
  description = "Environment tag for this resources"
  type        = string
}

resource "aws_s3_bucket" "this" {
  depends_on = [ aws_s3_bucket.log_bucket ]
  bucket = var.bucket_name

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }
  
  tags = {
    Name = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "${var.bucket_name}-logs"

  tags = {
    Name = "${var.bucket_name}-logs"
    Environment = var.environment
  }
}


output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}
