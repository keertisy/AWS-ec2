terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "ap-south-1"
  access_key = "<access_key>"
  secret_key = "<secret_key>"
}

resource "tls_private_key" "rsa-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

variable "key_name" {}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa-key.public_key_openssh
}

resource "local_file" "private_key" {
    content = tls_private_key.rsa-key.private_key_pem
    filename = var.key_name
}

resource "aws_instance" "terraform_ec2" {
  ami           = "ami-0e670eb768a5fc3d4"
  instance_type = "t2.micro"


  key_name = aws_key_pair.key_pair.key_name

  tags = {
    Name = "terraform_ec2"
  }
}