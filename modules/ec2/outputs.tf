output "instance_id" {
  description = "The ID of the EC2 instance"
  value = aws_instance.main.id
}

output "private_ip" {
  description = "The private IP address of the EC2 instance"
  value = aws_instance.main.private_ip
}

output "public_ip" {
  description = "The public IP address of the EC2 instance"
  value = aws_instance.main.public_ip
}

output "vpc_security_group_id" {
  description = "The ID of the security group attached to the instance"
  value = aws_security_group.main.id
}

output "arn" {
  description = "The ARN of the EC2 instance"
  value = aws_instance.main.arn
}

output "instance_name" {
  description = "The Name tag of the EC2 instance"
  value       = try(aws_instance.main.tags_all["Name"], var.ec2_tags["Name"], "Unnamed-Instance")
}