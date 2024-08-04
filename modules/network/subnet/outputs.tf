output "public_subnets" {
  value = [
    aws_subnet.postechfiap_pubsubnet_1a.id,
    aws_subnet.postechfiap_pubsubnet_1c.id
  ]
}

output "private_subnets" {
  value = [
    aws_subnet.postechfiap_pvtsubnet_1a.id,
    aws_subnet.postechfiap_pvtsubnet_1c.id
  ]
}