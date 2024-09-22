variable "vpc_id" {
  description = "The VPC ID to place the subnet in"
  type = string
}

variable "subnet_cidr" {
  description = "CIDR block for the private subnet"
  type = string
}
variable "az_name" {
  description = "The availability zone to place the subnet in"
  type = string
}
variable "environment" {
  description = "Environment tag for this resources"
  type        = string
}


resource "aws_subnet" "private" {
  vpc_id = var.vpc_id
  cidr_block = var.subnet_cidr
  availability_zone = var.az_name
  tags = {
    Name = "private-subnet"
    Environment = var.environment
  }
}


output "private_subnet_id" {
  value = aws_subnet.private.id
}

