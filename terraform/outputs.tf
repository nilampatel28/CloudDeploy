output "instance_public_ip" {
  value       = aws_instance.CloudDeploy.public_ip
  description = "The public IP of the EC2 instance"
}
