terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

provider "aws" {
  alias  = "us"
  region = "us-east-1"
}

data "aws_ami" "ubuntu_mumbai" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "aws_ami" "ubuntu_virginia" {
  provider    = aws.us
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "mumbai_ec2" {
  ami           = data.aws_ami.ubuntu_mumbai.id
  instance_type = "t3.micro"
  tags = {
    Name = "Mumbai-ec2"
  }
}

resource "aws_instance" "virginia_ec2" {
  provider      = aws.us
  ami           = data.aws_ami.ubuntu_virginia.id
  instance_type = "t3.micro"

  tags = {
    Name = "Virginia-EC2"
  }
}
