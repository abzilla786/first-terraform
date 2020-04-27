variable "vpc_id" {
  description = "the vpc it launches resources into"
}

variable "name" {
  description = "the name of the EC2 it launches"
}

variable "ami_id" {
  description = "the name of the ami to use for creating the EC2"
}

variable "igtw" {
  description = "igtw for querying our db"
}
