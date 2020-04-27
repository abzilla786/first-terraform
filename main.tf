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
      Name = var.name
    }
}

# route tables
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default-gw.id
  }
  tags = {
    Name = "${var.name}-public-table"
  }
}

resource "aws_route_table_association" "assoc" {
  subnet_id = aws_subnet.app_subnet.id
  route_table_id = aws_route_table.public.id

}

# we dont need a new Internet Gateway
# we can query our exiting vpc/infrastructure with the 'data' handler
data "aws_internet_gateway" "default-gw" {
  filter {
    # on the hashicorp docs it references AWS-APi that has this filter
    name = "attachment.vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_security_group" "app_sg" {
  name        = "app-sg-abz-name"
  vpc_id      = var.vpc_id
  description = "security group that allows port 80 from anywhere"

  ingress {
    description = "allows port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allows port 3000"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allows port 22 on my ip"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["5.64.99.193/32"]
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

data "template_file" "app_init" {
  template = file("./scripts/app/init.sh.tpl")
}
# launching an instance

resource "aws_instance" "app_instance" {

    ami   = var.ami_id
    instance_type = "t2.micro"
    associate_public_ip_address = true
    subnet_id = aws_subnet.app_subnet.id
    vpc_security_group_ids = [aws_security_group.app_sg.id]
    tags = {
        Name = var.name
    }
    key_name = "abz-eng54"

    user_data = data.template_file.app_init.rendered


    # provisioner "remote-exec" {
    #   inline = [
    #     "cd /home/ubuntu/appjs",
    #     "npm start",
    #   ]
    # }
    # connection {
    #   type = "ssh"
    #   user = "ubuntu"
    #   host = self.public_ip
    #   private_key = "${file("~/.ssh/abz-eng54.pem")}"
    # }
    #
}
