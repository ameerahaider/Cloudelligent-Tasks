output "vpc_id" {
  description = "The ID of the VPC"
  value = aws_vpc.main.id
}

output "subnets" {
  description = "The IDs of the public subnets"
  value = aws_subnet.main[*].id
}

output "internet_gateway_id" {
  description = "The ID of the internet gateway"
  value       = aws_internet_gateway.main.id
}
