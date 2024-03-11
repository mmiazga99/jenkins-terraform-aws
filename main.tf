terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.38.0"
    }
  }
}

provider "aws" {
    region = "eu-central-1"
#    access_key = ""
#    secret_key = ""
}

variable "instance_count" {
  default = 3
}

resource "aws_key_pair" "ssh-key" {
  key_name   = "deployer-ssh-key"
  public_key = file("id_rsa.pub")
}

resource "aws_instance" "xyz_app_ec2" {
    ami = "ami-0faab6bdbac9486fb" # ubuntu 22.04 LTS
    instance_type = "t2.micro"
    key_name = aws_key_pair.ssh-key.key_name
    count = var.instance_count

    tags = {
        Name = "xyz_app_cluster_${count.index + 1}"
    }
}
