variable "aws_access_key" {
  description = "AWS access key"
}

variable "aws_secret_key" {
  description = "AWS secret key"
}

variable "aws_region" {
  description = "AWS region"
}

variable "app_name" {
  description = "Application name"
}

variable "app_environment" {
  description = "Application environment"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.1.64.0/18"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.1.64.0/24"
}
