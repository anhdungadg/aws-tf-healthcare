variable "vpc_cidr" {
  description = "CIDR block for the public subnet"
  type = string
}

resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "healthcare-vpc"
  }
}

# resource "aws_default_route_table" "default_rt_private" {
#   default_route_table_id = aws_vpc.main_vpc.default_route_table_id

#   tags = {
#     Name = "default-route-table-private"
#   }
# }

output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "default_route_table_id" {
  value = aws_vpc.main_vpc.default_route_table_id
}