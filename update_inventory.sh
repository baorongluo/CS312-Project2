#!/bin/bash

# Fetch the latest IP from Terraform output
IP=$(terraform output -raw minecraft_server_ip)

# Write to inventory.ini in ansible/
cat > ansible/inventory.ini <<EOF
[minecraft]
$IP ansible_user=ubuntu ansible_ssh_private_key_file=../../labwk6key.pem
EOF

echo "Updated ansible/inventory.ini with IP: $IP"
