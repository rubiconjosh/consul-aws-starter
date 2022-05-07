output "bastion_ip_addr" {
  value = aws_instance.bastion.public_ip
}

output "client_ip_addr" {
  value = aws_instance.consul_client.public_ip
}

output "server_ips" {
  value = aws_instance.consul_server.*.private_ip
}
