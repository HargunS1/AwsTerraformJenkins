provider "aws" {
  region = "eu-west-1"
  access_key = "AKIAZYRLZZ47ZON3VA2P"
  secret_key = "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"
}




resource "aws_instance" "tfvm" {
  ami = "ami-01dd271720c1ba44f"
  instance_type = "t2.micro"
  }
