provider "aws" {
    region = "eu-west-1"
}

# creating a vpc

resource "aws_vpc" "app_vpc" {
   cidr_block = "10.0.0.0/16"
   tags = {
       Name = "${var.name}-vpc2"
   }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "${var.name}-ig"
  }
}

data "external" "myipaddr" {
  program = ["bash", "-c", "curl -s 'https://api.ipify.org?format=json'"]
}


# we dont need a new Internet Gateway
# we can query our exiting vpc/infrastructure with the 'data' handler
# data "aws_internet_gateway" "default-gw" {
#   filter {
#     # on the hashicorp docs it references AWS-APi that has this filter
#     name = "attachment.vpc-id"
#     values = [var.vpc_id]
#   }
# }

module "app" {
  source = "./modules/app_tier"
  vpc_id = aws_vpc.app_vpc.id
  name = var.name
  ami_id = var.ami_id
  igtw = aws_internet_gateway.igw.id
  db_ip = module.mongod.instance_ip_addr
  my_ip = data.external.myipaddr.result.ip
  # gateway_id = data.aws_internet_gateway.default-gw.id
}

module "mongod" {
  source = "./modules/mongod_tier"
  vpc_id = aws_vpc.app_vpc.id
  name2 = var.name2
  mongod_ami_id = var.mongod_ami_id
}



# Inbout and outbound rules for public subnet

### Creating DB

# create private subnet

# make route table association

# Inbount and outbound rules for private subnet

# Deploying instance with AMI that has mongodb inside

# SG rules for private instance

# Initi script for private instance


### Bastion
# create instance with bastion server

# sg for bastion server

# init script for bastion server
