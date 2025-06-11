# CS312-Project2

## Background

This project fully automates the provisioning and configuration of a dedicated Minecraft Java Edition server on AWS. The goal is to build a hands-free, repeatable infrastructure pipeline using the following technologies:
    - Terraform for infrastructure provisioning (VPC, subnet, security group, EC2 instance)
    - Ansible for server configuration (Java installation, Minecraft setup, systemd service)
    - Nmap or Minecraft client to verify server connectivity
    - No AWS Console or SSH is used in the pipeline—everything is automated and version-controlled.

## Requirements
1. AWS
2. An active AWS account
3. Access credentials (e.g., AWS Educate Learner Lab keys)
4. IAM permissions to launch EC2 and VPC resources
5. CLI Tools
6. Terraform (>= 1.5)
7. Ansible (>= 2.14)
8. AWS CLI
9. nmap (optional, for verification)

## Configuration

Before running the pipeline:

    - Export your AWS credentials:
        export AWS_ACCESS_KEY_ID=...
        export AWS_SECRET_ACCESS_KEY=...
        export AWS_SESSION_TOKEN=...

Ensure the EC2 key pair (labwk6key.pem) exists two directories above the project root (or adjust the path in inventory.ini)

Ensure the key has correct permissions:
    chmod 400 ../../labwk6key.pem

## Project Structure

<pre>
CS312-Project2/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── modules/
│   ├── ec2/
│   ├── vpc/
│   └── security_group/
├── ansible/
│   ├── inventory.ini
│   └── minecraft.yml
└── labwk6key.pem (2 levels up)
 </pre>

Infrastructure Pipeline Diagram

Terraform (IaC)
   ┗️ Provisions AWS:
      - VPC + Subnet
      - Security Group
      - EC2 Instance (Ubuntu)

Ansible (Provisioner)
   ┗️ Connects to EC2:
      - Installs Java
      - Downloads Minecraft server
      - Accepts EULA
      - Creates systemd service

## Commands to Run

From the root of your project folder:

1. Initialize Terraform
terraform init

2. Preview infrastructure changes
terraform plan

3. Apply and provision infrastructure
terraform apply -auto-approve

4. Run Ansible playbook to configure server
ansible-playbook -i ansible/inventory.ini ansible/minecraft.yml

5. Verify Minecraft port
nmap -sV -Pn -p 25565 $(terraform output -raw minecraft_server_ip)

## Connect to the Minecraft Server
1. Launch Minecraft Java Edition
2. Go to Multiplayer > Add Server
3. Use the IP shown from: terraform output minecraft_server_ip
4. Click Join Server

## Restart & Shutdown

The server is configured to restart automatically on instance reboot (via systemd enable)
It is set to shut down cleanly with ExecStop=/bin/kill -SIGINT $MAINPID, ensuring the world is saved safely
