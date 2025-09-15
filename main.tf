provider "aws" {
  region = "us-east-1"
}

variable "cidr" {
  default = "10.0.0.0/16"
}

# Key Pair
resource "aws_key_pair" "example" {
  key_name   = "keypair_terraform_App"
  public_key = file("~/.ssh/id_rsa.pub")
}

# VPC
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}

# Subnet
resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

# Security Group
resource "aws_security_group" "webSg" {
  name        = "webSg"
  description = "Security group for web server"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Flask App on port 5000"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webSg"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}

# Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Route Table Association
resource "aws_route_table_association" "subnet_assoc" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.public_rt.id
}

# EC2 Instance
resource "aws_instance" "server" {
  instance_type          = "t3.micro"
  ami                    = "ami-0360c520857e3138f" # change if needed
  subnet_id              = aws_subnet.sub1.id
  vpc_security_group_ids = [aws_security_group.webSg.id]
  key_name               = aws_key_pair.example.key_name

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }

  # Copy Flask app
  provisioner "file" {
    source      = "app.py"
    destination = "/home/ubuntu/app.py"
  }

  # Install Python, create venv, install Flask, run app on port 5000
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y && sudo apt install -y python3-full python3-venv",
      "python3 -m venv /home/ubuntu/venv",
      "source /home/ubuntu/venv/bin/activate && pip install --upgrade pip flask",
      # Run Flask app on port 5000 in the background
      "nohup /home/ubuntu/venv/bin/python /home/ubuntu/app.py &"
    ]
  }
}
