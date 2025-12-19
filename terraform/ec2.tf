resource "aws_key_pair" "CloudDeploy_key" {
  key_name   = "clouddeploy-key"
  public_key = file("${path.module}/clouddeploy-key.pub") 
}

resource "aws_security_group" "CloudDeploy_sg" {
  name        = "CloudDeploy-sg"
  description = "Allow inbound traffic for Node.js app and SSH"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
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

resource "aws_instance" "CloudDeploy" {
  ami             = "ami-0c1c30571d2dae953" # Ubuntu 24.04 LTS in eu-west-1
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.CloudDeploy_key.key_name
  vpc_security_group_ids = [aws_security_group.CloudDeploy_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              sudo systemctl enable docker
              # Pull and run your app from Docker Hub
              sudo docker run -d -p 3000:3000 amitabhdevops/clouddeploy
              EOF

  tags = {
    Name = "CloudDeploy"
  }
}

