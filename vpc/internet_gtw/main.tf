variable "vpc_id" {
  description = "The VPC ID to attach the Internet Gateway to"
  type        = string
}
variable "environment" {
  description = "Environment tag for this resources"
  type        = string
}


resource "aws_internet_gateway" "this" {
    vpc_id = var.vpc_id
    tags = {
        Name = "healthcare-internet-gateway"
        Environment = var.environment
    }
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name = "public_route_table"
    Environment = var.environment
  }
}

output "internet_gateway_id" {
  value = aws_internet_gateway.this.id
}


output "public_route_table_id" {
  value = aws_route_table.public.id
}
