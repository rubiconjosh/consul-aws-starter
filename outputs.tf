output "server_ip_addr" {
  value = aws_instance.consul_server.public_ip
}

output "client_ip_addr" {
  value = aws_instance.consul_client.public_ip
}
