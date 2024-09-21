provider "aws" {
  region = "us-east-1"
}

# Create a VPC
module "vpc" {
  source   = "./vpc"
  vpc_cidr = "10.0.0.0/16"
}

# Create an Internet Gateway for the VPC
# For billing, scheduling application
module "internet_gtw" {
  source = "./vpc/internet_gtw"
  vpc_id = module.vpc.vpc_id
}

module "public_subnet" {
  depends_on     = [module.internet_gtw.public_route_table_id]
  source         = "./vpc/public_subnet"
  vpc_id         = module.vpc.vpc_id
  subnet_cidr    = "10.0.1.0/24"
  route_table_id = module.internet_gtw.public_route_table_id
}

module "private_subnet" {
  source      = "./vpc/private_subnet"
  vpc_id      = module.vpc.vpc_id
  subnet_cidr = "10.0.2.0/24"
  az_name = "us-east-1a"
}

module "public_subnetb" {
  depends_on     = [module.internet_gtw.public_route_table_id]
  source         = "./vpc/public_subnet"
  vpc_id         = module.vpc.vpc_id
  subnet_cidr    = "10.0.3.0/24"
  route_table_id = module.internet_gtw.public_route_table_id
  az_name = "us-east-1b"
}
module "private_subnetb" {
  source      = "./vpc/private_subnet"
  vpc_id      = module.vpc.vpc_id
  subnet_cidr = "10.0.4.0/24"
  az_name = "us-east-1b"
}

# module "ec2_billing" {
#   asg_name         = "billing"
#   source           = "./ec2_application"
#   vpc_id           = module.vpc.vpc_id
#   public_subnet_id = module.public_subnet.public_subnet_id
# }

# module "ec2_scheduling" {
#   asg_name         = "scheduling"
#   source           = "./ec2_application"
#   vpc_id           = module.vpc.vpc_id
#   public_subnet_id = module.public_subnet.public_subnet_id
# }

module "rds" {
  source = "./rds"
  vpc_id = module.vpc.vpc_id
  subnet_id_aza = module.private_subnet.private_subnet_id
  subnet_id_azb = module.private_subnetb.private_subnet_id
}

# module "s3_bucket" {
#   source      = "./s3_bucket"
#   bucket_name = "my-private-s3-bucket"
# }

# module "s3_lifecycle" {
#   source = "./s3_bucket/s3_lifecycle"
#   bucket_name = "my-private-s3-bucket"
# }

# module "s3_vpc_endpoint" {
#   source             = "./s3_bucket/s3_vpc_endpoint"
#   vpc_id             = module.vpc.vpc_id
# #   private_subnet_ids = [module.private_subnet.subnet_id, module.public_subnet.subnet_id]
#   private_subnet_id = module.private_subnet.private_subnet_id
#   public_subnet_id = module.public_subnet.public_subnet_id
#   private_routetable_id = module.internet_gtw.public_route_table_id
#   public_routetable_id = module.vpc.default_route_table_id
# }
