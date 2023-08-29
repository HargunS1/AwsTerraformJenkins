# AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  access_key =  var.aws_access_key
  secret_key =  var.aws_secret_key
  region     =  var.aws_region
}


resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create the Key Pair
resource "aws_key_pair" "key_pair" {
  key_name   = "${lower(var.app_name)}-${lower(var.app_environment)}-linux-${lower(var.aws_region)}"  
  public_key = tls_private_key.key_pair.public_key_openssh
}

# Save file
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.key_pair.key_name}.pem"
  content  = tls_private_key.key_pair.private_key_pem
}

# Application Definition 
app_name        = "kopicloud" # Do NOT enter any spaces
app_environment = "dev"       # Dev, Test, Staging, Prod, etc

# Network
vpc_cidr = "10.11.0.0/16"
public_subnet_cidr = "10.11.1.0/24"

# AWS Settings
aws_access_key = "AKIAZYRLZZ47ZON3VA2P" 
aws_secret_key = "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" 
aws_region     = "us-east-1"

variable "aws_access_key" {
  type = string
  description = "AKIAZYRLZZ47ZON3VA2P"
}

variable "aws_secret_key" {
  type = string
  description = "suOPrAo+y0bncrqnpCVRcgTZfMg50ydFsv/qzcrf"
}

variable "aws_region" {
  type = string
  description = "us-east-1"
}


variable "app_environment" {
  type        = string
  description = "Application environment"
}

# VPC Variables
variable "vpc_cidr" {
  type        = string
  description = "CIDR for the VPC"
  default     = "10.1.64.0/18"
}

# Subnet Variables
variable "public_subnet_cidr" {
  type        = string
  description = "CIDR for the public subnet"
  default     = "10.1.64.0/24"
}


# Create the VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${lower(var.app_name)}-${lower(var.app_environment)}-vpc"
    Environment = var.app_environment
  }
}

# Define the public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.aws_az
  tags = {
    Name = "${lower(var.app_name)}-${lower(var.app_environment)}-public-subnet"
    Environment = var.app_environment
  }
}


resource "aws_security_group" "example_sg" {
  name = "example-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example_instance" {
  ami           = "ami-0c55b159cbfafe1f0"  # Ubuntu 20.04 LTS in us-east-1; change as needed
  instance_type = "t2.micro"
  subnet_id                   = aws_subnet.public-subnet.id
  vpc_security_group_ids      = [aws_security_group.example_sg.id]
  key_name                    = aws_key_pair.key_pair.key_name
  

  tags = {
    Name = "example-instance"
  }

  root_block_device {
    volume_size = 20  # Change this to desired storage size in GB
  }
}
