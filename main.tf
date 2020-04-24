provider "aws" {
    region = "eu-west-1"
}

# creating a vpc

#resource "aws_vpc" "app_vpc" {
#    cidr_block = "10.0.0.0/16"
#    tags = {
#        Name = "Eng-54-ABZ-app_vpc"
#    }
#}

# Use our devops app_vpc
  # vpc-07e47e9d90d2076da
# create new subnet
# move our instance into said subnet
resource "aws_subnet" "app_subnet" {
    vpc_id = "vpc-07e47e9d90d2076da"
    cidr_block = "172.31.35.0/24"
    availability_zone = "eu-west-1a"
    tags = {
      Name = "eng54-subnet-public"
    }
}

resource "aws_security_group" "app_sg" {
  name        = "app-sg-abz-name"
  vpc_id      = "vpc-07e47e9d90d2076da"
  description = "security group that allows port 80 from anywhere"

  ingress {
    description = "allows port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # default outbound rules for sg is it lets everything out
  egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }


  tags = {
    Name = "allow_tls"
  }
}
# launching an instance

resource "aws_instance" "app_instance" {

    ami   = "ami-040bb941f8d94b312"
    instance_type = "t2.micro"
    associate_public_ip_address = true
    subnet_id = "${aws_subnet.app_subnet.id}"
    vpc_security_group_ids = [aws_security_group.app_sg.id]
    tags = {
        Name = "eng-54-ABZ-app"
    }
}

#route table
#
