terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"] 

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "devlog_server" {
  ami           = data.aws_ami.latest_amazon_linux.id 
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.devlog_sg.id]

  tags = {
    Name = var.name
  }
}

resource "aws_security_group" "devlog_sg" {
  name        = "devlog_security_group"
  description = "Allow SSH and HTTP access"
  
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "devlog_security_group"
  }   
}

resource "local_file" "ansible_inventory" {
  content  = <<EOT
[devlog_servers]
${aws_instance.devlog_server.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/${var.key_name}.pem
EOT
  filename = "../Ansible/hosts.ini"
}
