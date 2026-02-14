terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ----------------------
# Provider Configuration
# ----------------------
provider "aws" {
  region = var.aws_region
}

# ----------------------
# Get Default VPC
# ----------------------
data "aws_vpc" "default" {
  default = true
}

# ----------------------
# Get One Public Subnet Automatically
# (No hardcoded AZ to avoid mapping issues)
# ----------------------
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_subnet" "selected" {
  id = data.aws_subnets.default.ids[0]
}

# ----------------------
# Get Latest Amazon Linux 2 ARM AMI
# (Required for t4g.micro)
# ----------------------
data "aws_ami" "amazon_linux_arm" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-arm64-gp2"]
  }
}

# ----------------------
# Security Group
# ----------------------
resource "aws_security_group" "ec2_sg" {
  name        = "terraform-ec2-sg-v3"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
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
    Name = "terraform-ec2-sg-v3"
  }
}

# ----------------------
# EC2 Instance
# ----------------------
resource "aws_instance" "ec2" {
  ami                         = data.aws_ami.amazon_linux_arm.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnet.selected.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  key_name                    = var.existing_key_pair_name

  tags = {
    Name = "terraform-ec2"
  }
}
