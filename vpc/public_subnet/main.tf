variable "vpc_id" {
  description = "The VPC ID to place the subnet in"
  type = string
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type = string
}

variable "route_table_id" {
  description = "Route table to associate with the subnet (used for public subnets)"
  type        = string
  default     = ""
}


resource "aws_subnet" "public" {
  vpc_id = var.vpc_id
  cidr_block = var.subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_route_table_association" "public" {
#   count = var.route_table_id != "" ? 1 : 0
  subnet_id      = aws_subnet.public.id
  route_table_id = var.route_table_id
}


output "public_subnet_id" {
  value = aws_subnet.public.id
  
}

