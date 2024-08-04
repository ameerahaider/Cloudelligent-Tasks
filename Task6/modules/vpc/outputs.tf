output "vpc_id" {
  description = "The ID of the VPC"
  value = aws_vpc.main.id
}

output "public_subnets_id" {
  description = "The IDs of the public subnets"
  value = aws_subnet.public[*].id
}