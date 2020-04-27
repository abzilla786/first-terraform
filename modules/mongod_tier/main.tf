resource "aws_subnet" "mongod_subnet" {
    vpc_id = var.vpc_id
    cidr_block = "10.0.20.0/24"
    availability_zone = "eu-west-1a"
    tags = {
      Name = var.name2
    }
}

# Creating NACLs
resource "aws_network_acl" "private-nacl" {
  vpc_id = var.vpc_id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.0.18.0/24"
    from_port  = 27017
    to_port    = 27017
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "10.0.18.0/24"
    from_port  = 22
    to_port    = 22
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.0.18.0/24"
    from_port  = 22
    to_port    = 22
  }


  tags = {
    Name = "${var.name2}-nacl"
  }
}
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.name2}-private-table"
  }
}

resource "aws_route_table_association" "assoc" {
  subnet_id = aws_subnet.mongod_subnet.id
  route_table_id = aws_route_table.private.id

}


resource "aws_security_group" "mongod_sg" {
  name        = "mongod-sg-abz-name"
  vpc_id      = var.vpc_id
  description = "security group that allows port 80 from anywhere"

  ingress {
    description = "allows port 80"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.18.0/24"]
  }
  ingress {
    description = "allows port 3000"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["10.0.18.0/24"]
  }
  ingress {
    description = "allows port 22 on my ip"
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.18.0/24"]
  }

  # default outbound rules for sg is it lets everything out
  egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
 egress {
  from_port   = 1025
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
  tags = {
    Name = "allow_tls"
  }
}
