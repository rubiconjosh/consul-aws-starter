#!/bin/bash

# Install Consul
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt-get update && apt-get install consul

# Create server config
cat > /etc/consul.d/consul.hcl <<EOF
data_dir = "/opt/consul"
EOF

# Enable & Start Server
systemctl enable consul
systemctl start consul