provider "aws" {
  region = "us-east-1"
}

# This resource is used to generate a unique ID for the S3 bucket.
# The generated string will contain only lowercase letters and digits,
# as special characters and uppercase letters are disabled.
resource "random_string" "random_id" {
  length  = 9
  special = false  # No special characters
  upper   = false  # No uppercase letters
}

# Creates a VPC with the specified CIDR block.
# This VPC is used to host the billing and scheduling application resources.
module "vpc" {
  source   = "./vpc"
  vpc_cidr = "10.0.0.0/16"
  environment = "sa-assignment"
}


# Creates an Internet Gateway for the VPC, which allows resources in the public subnets to communicate with the internet.
# The Internet Gateway is attached to the VPC and its ID is made available to other modules that need to reference it.
module "internet_gtw" {
  source = "./vpc/internet_gtw"
  vpc_id = module.vpc.vpc_id
  environment = "sa-assignment"
}


# Creates a public subnet in the VPC with the specified CIDR block and associates it with the public route table.
# The public subnet is created in the us-east-1a availability zone.
# This public subnet is used for the billing and scheduling application EC2 instances.
module "public_subnet" {
  depends_on     = [module.internet_gtw.public_route_table_id]
  source         = "./vpc/public_subnet"
  vpc_id         = module.vpc.vpc_id
  subnet_cidr    = "10.0.1.0/24"
  route_table_id = module.internet_gtw.public_route_table_id
  az_name        = "us-east-1a"
  environment = "sa-assignment"
}

# Creates a private subnet in the VPC with the specified CIDR block.
# The private subnet is created in the us-east-1a availability zone.
# This private subnet is used for resources that should not be publicly accessible, RDS MSSQL Server.
module "private_subnet" {
  source      = "./vpc/private_subnet"
  vpc_id      = module.vpc.vpc_id
  subnet_cidr = "10.0.2.0/24"
  az_name     = "us-east-1a"
  environment = "sa-assignment"
}


module "public_subnetb" {
  depends_on     = [module.internet_gtw.public_route_table_id]
  source         = "./vpc/public_subnet"
  vpc_id         = module.vpc.vpc_id
  subnet_cidr    = "10.0.3.0/24"
  route_table_id = module.internet_gtw.public_route_table_id
  az_name        = "us-east-1b"
  environment = "sa-assignment"
}

module "private_subnetb" {
  source      = "./vpc/private_subnet"
  vpc_id      = module.vpc.vpc_id
  subnet_cidr = "10.0.4.0/24"
  az_name     = "us-east-1b"
  environment = "sa-assignment"
}

# This module configuration sets up an EC2 instance and Auto Scaling Group (ASG) for the billing application.
# - asg_name: Specifies the name of the Auto Scaling Group.
# - vpc_id: References the VPC ID from the VPC module.
# - public_subnet_id: References the public subnet ID from the public subnet module.
# module "ec2_billing" {
#   asg_name         = "billing"
#   source           = "./ec2_application"
#   vpc_id           = module.vpc.vpc_id
#   public_subnet_id = module.public_subnet.public_subnet_id
#   environment = "sa-assignment"
# }

# module "ec2_scheduling" {
#   asg_name         = "scheduling"
#   source           = "./ec2_application"
#   vpc_id           = module.vpc.vpc_id
#   public_subnet_id = module.public_subnet.public_subnet_id
#   environment = "sa-assignment"
# }

# This module block configures an S3 bucket using a local module located at "./s3_bucket".
module "s3_bucket" {
  source      = "./s3_bucket"
  vpc_id = module.vpc.vpc_id
  bucket_name = "healthcare-s3-bucket-${random_string.random_id.result}"
  environment = "sa-assignment"
}

# This module configures the lifecycle policies for an S3 bucket.
# 
# Arguments:
# - source: The path to the module that sets up the S3 lifecycle policies.
# - bucket_name: The name of the S3 bucket to which the lifecycle policies will be applied.
module "s3_lifecycle" {
  depends_on  = [module.s3_bucket]
  source      = "./s3_bucket/s3_lifecycle"
  bucket_name = module.s3_bucket.bucket_name
}

# This module configures an S3 VPC endpoint within the specified VPC.
# 
# Arguments:
# - source: The path to the module that sets up the S3 VPC endpoint.
# - vpc_id: The ID of the VPC where the S3 VPC endpoint will be created.
# - private_subnet_id: The ID of the private subnet within the VPC.
# - public_subnet_id: The ID of the public subnet within the VPC.
# - private_routetable_id: The ID of the route table associated with the private subnet.
# - public_routetable_id: The ID of the route table associated with the public subnet.
module "s3_vpc_endpoint" {
  source                = "./s3_bucket/s3_vpc_endpoint"
  vpc_id                = module.vpc.vpc_id
  private_subnet_id     = module.private_subnet.private_subnet_id
  public_subnet_id      = module.public_subnet.public_subnet_id
  private_routetable_id = module.internet_gtw.public_route_table_id
  public_routetable_id  = module.vpc.default_route_table_id
  environment = "sa-assignment"
}

# This module block configures an RDS instance using the "rds" module.
# - source: Specifies the path to the RDS module.
# - vpc_id: Passes the VPC ID from the VPC module.
# - subnet_id_aza: Passes the ID of the first private subnet from the private_subnet module.
# - subnet_id_azb: Passes the ID of the second private subnet from the private_subnetb module.
# module "rds" {
#   source = "./rds"
#   vpc_id = module.vpc.vpc_id
#   subnet_id_aza = module.private_subnet.private_subnet_id
#   subnet_id_azb = module.private_subnetb.private_subnet_id
#   environment = "sa-assignment"
# }
