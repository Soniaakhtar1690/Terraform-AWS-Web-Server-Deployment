# Output the public IP of the EC2 instance
output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance running Flask app"
  value       = aws_instance.server.public_ip
}
