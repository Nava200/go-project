provider "aws" {
  region = "us-east-1"  # Update with your desired region
}

# Fetch the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filters = {
    name = "amzn2-ami-hvm-*-x86_64-gp2"
  }
}

# Security group to allow SSH and HTTP access
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP and SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance setup with user data to install Docker
resource "aws_instance" "go_app" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = "t2.micro"
  key_name        = "myfirst"  # Your SSH key pair name
  security_groups = [aws_security_group.allow_http.name]

  tags = {
    Name = "go-app-instance"
  }

  # User data to install Docker and run the app in a container
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y docker
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker ec2-user

    # Optionally, pull and run the Go app Docker image (remove if handled by GitHub Actions)
    sudo docker run -d -p 80:8080 --name go-app navaneetha084/go-app:latest
  EOF
}

# Output the public IP of the instance
output "instance_public_ip" {
  value = aws_instance.go_app.public_ip
}
