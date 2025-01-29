output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC ID "
}


output "public_subnets_id" {
  value = [
    for a in aws_subnet.public_subnets : a.id
  ]
  description = "List of public subnet ids created in VPC"
}
output "private_subnets_id" {
  value = [
    for a in aws_subnet.private_subnets : a.id
  ]
  description = "List of private subnet ids created in VPC"
}
