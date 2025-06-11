data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "minecraft" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.small"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  associate_public_ip_address = true
  key_name               = var.key_name
  tags = {
    Name = "MinecraftServer"
  }
}
