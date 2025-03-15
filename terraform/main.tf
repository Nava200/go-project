provider "aws" {
  region = "us-east-1"  # Change to your AWS region
}

resource "aws_instance" "go_app" {
  ami           = "ami-01f5a0b78d6089704"  # Latest Amazon Linux 2 AMI for us-east-1
  instance_type = "t2.micro"
  key_name      = "webapp"  # Replace with your actual EC2 key pair name

  security_groups = [aws_security_group.allow_http.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras enable docker
              yum install -y docker
              service docker start
              usermod -aG docker ec2-user
              docker pull navaneetha084/go-app:latest  # ✅ Correct Docker image
              docker stop go-app || true
              docker rm go-app || true
              docker run -d -p 80:8080 --name go-app navaneetha084/go-app:latest  # ✅ Runs the app
              EOF

  tags = {
    Name = "go-app-instance"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP access"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
