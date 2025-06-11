provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source            = "./modules/vpc"
  vpc_cidr          = "10.0.0.0/16"
  subnet_cidr       = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

module "security_group" {
  source  = "./modules/security_group"
  vpc_id  = module.vpc.vpc_id
  my_ip = "${chomp(data.http.my_ip.response_body)}/32"

}


module "ec2" {
  source            = "./modules/ec2"
  subnet_id         = module.vpc.subnet_id
  security_group_id = module.security_group.security_group_id
  key_name          = "labwk6key"
}

data "http" "my_ip" {
  url = "https://ipv4.icanhazip.com"
}

terraform {
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}
