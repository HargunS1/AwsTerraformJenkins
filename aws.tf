provider "aws" {
  region = "eu-west-1"
  access_key = "AKIAZYRLZZ47ZON3VA2P"
  secret_key = "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"
}

resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "custom" {
  vpc_id     = aws_vpc.custom.id
  cidr_block = "10.0.1.0/24"
}


resource "aws_instance" "tfvm" {
  ami = "ami-01dd271720c1ba44f"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.websg.id ]
  subnet_id = aws_subnet.custom.id
  user_data = <<-EOF
                #!/bin/bash
                echo "I LOVE TERRAFORM" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF
    tags = {
      Name = "WEB-demo"
    }
}
resource "aws_security_group" "websg" {
  name = "web-sg01"
   vpc_id = aws_vpc.custom.id
  ingress {
    protocol = "tcp"
    from_port = 8080
    to_port = 8080
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}
output "instance_ips" {
  value = aws_instance.tfvm.public_ip
}
