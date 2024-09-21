variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "public_subnet_id" {
  description = "The subnet ID where the public EC2 instance will be created"
  type        = string
}

variable "asg_name" {
  description = "Name of Auto Scaling Group"
  type        = string
}

resource "aws_launch_template" "ec_webapp" {
  name_prefix = "healthcare-launch-template-"
  image_id = "ami-0ebfd941bbafe70c6"
  instance_type = "t2.micro"
  user_data = base64encode(file("./ec2_application/server-script.sh"))

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.web_server.id]
  }
}

resource "aws_autoscaling_group" "web_server_asg" {
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  vpc_zone_identifier  = [var.public_subnet_id]

  launch_template {
    id      = aws_launch_template.ec_webapp.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.asg_name
    propagate_at_launch = true
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300
}

resource "aws_security_group" "web_server" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2application_sg"
  }
}



output "asg_name" {
  value = aws_autoscaling_group.web_server_asg.name
}