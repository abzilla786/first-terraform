output "instance_ip_addr" {
  value = aws_instance.mongod_instance.private_ip
}
