data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

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
  ami             = data.aws_ami.ubuntu.id
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
              sudo docker run -d -p 3000:3000 amitabhdevops/modern-node-app
              EOF

  tags = {
    Name = "CloudDeploy"
  }

