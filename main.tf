terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-1"
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "dinislam"
  public_key = tls_private_key.pk.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.key_pair.key_name}.pem"
  content = tls_private_key.pk.private_key_pem
}

resource "aws_instance" "task1" {
  ami           = "ami-06bb3ee01d992f30d"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key_pair.key_name
}
