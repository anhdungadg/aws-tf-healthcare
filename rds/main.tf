variable "vpc_id" {
  description = "value of the VPC ID"
  type = string
}

variable "subnet_id_aza" {
  description = "value of the subnet ID"
  type = string
}

variable "subnet_id_azb" {
  description = "value of the subnet ID"
  type = string
}

variable "environment" {
  description = "Environment tag for this resources"
  type        = string
}


resource "aws_db_subnet_group" "db_subnet" {
  name       = "db_subnet"
#   subnet_ids = ["${aws_subnet.private-subnet1.id}", "${aws_subnet.private-subnet2.id}"]
# The DB subnet group doesn't meet Availability Zone (AZ) coverage requirement. Current AZ coverage: us-east-1b. Add subnets to cover at least 2 AZs
subnet_ids = [ var.subnet_id_aza, var.subnet_id_azb ]
}

resource "aws_security_group" "rds" {
  name        = "rds_security_group"
  description = "Used in the RDS MSSQL server"
  vpc_id      = var.vpc_id
  # Keep the instance private by only allowing traffic from the web server.
  ingress {
    from_port = 1433
    to_port   = 1433
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "rds-security-group"
    Environment = var.environment
  }
}

resource "aws_db_instance" "default" {
  tags = {
    Name = "healthcare-rds-mssql"
    Environment = var.environment
  }
  db_subnet_group_name = aws_db_subnet_group.db_subnet.name

  identifier        = "healthcare-rds-mssql"
  allocated_storage = 20
  engine            = "sqlserver-ex"
  engine_version    = "13.00.6445.1.v1"
  instance_class    = "db.t3.micro"
  username          = "foo"
  password          = "foobar1baz"
  # parameter_group_name = "default.mysql8.0"
  skip_final_snapshot = true
  #   multi_az            = true
  # Error: creating RDS DB Instance: operation error RDS: CreateDBInstance, https response error StatusCode: 400, RequestID:, api error InvalidParameterCombination: VPC Multi-AZ DB Instances are not available for engine: sqlserver-ex
}

output "rds_endpoint" {
  value = [aws_db_instance.default.endpoint, aws_db_instance.default.username, aws_db_instance.default.password]
  description = "Endpoint of the RDS instance"
}