provider "aws" {
  region = "us-east-1"
  access_key = "AKIAZYRLZZ47ZON3VA2P"
  secret_key = "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"
}




resource "aws_instance" "tfvm" {
  ami = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  }
