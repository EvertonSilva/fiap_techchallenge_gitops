output "public_route_table_id" {
  value = aws_route_table.postechfiap_pub_routetable
}

output "private_route_table_id" {
  value = aws_route_table.postechfiap_pvt_routetable
}