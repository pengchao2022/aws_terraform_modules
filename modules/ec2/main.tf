resource "aws_security_group" "main" {
  name = "${var.ec2_tags["Name"]}-sg"
  description = "Security group for ${var.ec2_tags["Name"]}"
  vpc_id = var.vpc_id


# allow http and ssh
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ec2 instance
resource "aws_instance" "main" {
  instance_type = var.instance_type
  ami           = var.ami 
  subnet_id     = element(var.public_subnet_list, 0)

  vpc_security_group_ids = [aws_security_group.main.id]

  root_block_device {
    encrypted = true
    volume_size = var.volume_size
    volume_type = "gp3"   
  }
  tags = var.ec2_tags
  depends_on = [aws_security_group.main]
}
