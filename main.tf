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



# we dont need a new Internet Gateway
# we can query our exiting vpc/infrastructure with the 'data' handler
data "aws_internet_gateway" "default-gw" {
  filter {
    # on the hashicorp docs it references AWS-APi that has this filter
    name = "attachment.vpc-id"
    values = [var.vpc_id]
  }
}


module "app" {
  source = "./modules/app_tier"
  vpc_id = var.vpc_id
  name = var.name
  ami_id = var.ami_id
  gateway_id = var.gateway_id
}



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
