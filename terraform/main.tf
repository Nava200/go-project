provider "aws" {
  region = "us-east-1"  # Change to your region
}

resource "aws_instance" "go_app" {
  ami           = "ami-05716d7e60b53d380"  # Amazon Linux AMI, change if needed
  instance_type = "t2.micro"
  key_name      = "your-key"  # Update with your key pair name

  security_groups = [aws_security_group.allow_http.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras enable docker
              yum install -y docker
              service docker start
              usermod -aG docker ec2-user
              docker pull navaneetha084/go-app:latest
              docker run -d -p 80:8080 navaneetha084/go-app:latest
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
