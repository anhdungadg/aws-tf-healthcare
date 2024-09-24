variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}
variable "vpc_id" {
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

resource "aws_s3_bucket_policy" "log_bucket_policy" {
  depends_on = [ aws_s3_bucket.log_bucket ]
  bucket = aws_s3_bucket.log_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "*"
        },
        Action = "s3:PutObject",
        Resource = "${aws_s3_bucket.log_bucket.arn}/log/*",
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Deny",
        Principal = "*",
        Action    = "s3:*",
        Resource = [
          "arn:aws:s3:::${aws_s3_bucket.this.bucket}",
          "arn:aws:s3:::${aws_s3_bucket.this.bucket}/*"
        ],
        Condition = {
          StringNotEquals = {
            "aws:SourceVpc" = var.vpc_id
          }
        }
      }
    ]
  })
}



output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}
