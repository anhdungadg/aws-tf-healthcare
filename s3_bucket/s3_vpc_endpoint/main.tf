variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

# variable "private_subnet_ids" {
#   description = "List of private subnet IDs"
#   type        = list(string)
# }

variable "public_subnet_id" {
  description = "Public subnet ID"
  type        = string
}

variable "private_subnet_id" {
  description = "Private subnet ID"
  type        = string
}

variable "public_routetable_id" {
  description = "Public route table ID"
  type        = string
}

variable "private_routetable_id" {
  description = "Private route table ID"
  type        = string
}

variable "environment" {
  description = "Environment tag for this resources"
  type        = string
}



resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table_association.private.route_table_id,
    # aws_route_table_association.public.route_table_id
  ]

  tags = {
    Name = "s3-vpc-endpoint"
    Environment = var.environment
  }
}


resource "aws_route_table_association" "private" {
  subnet_id      = var.private_subnet_id
  # route_table_id = data.aws_route_table.private.id
  route_table_id = var.private_routetable_id
}


output "s3_endpoint_id" {
  value = aws_vpc_endpoint.s3.id
}
