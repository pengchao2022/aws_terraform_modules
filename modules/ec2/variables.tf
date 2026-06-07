variable "instance_type" {
  type = string
  default = "t3.micro"  
}

variable "subnet_id" {
  type = string
  default = "subnet-placeholder"
}

variable "ami" {
  type = string
}

variable "ec2_tags" {
  type = map(string)
  default = {}
  
}

variable "volume_size" {
  type = number
  default = 20  
}

variable "vpc_id" {
  type = string
  default = ""
}

variable "public_subnet_list" {
  type = list(string)
  default = []
}