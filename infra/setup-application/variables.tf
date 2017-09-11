

variable "service_name" {
  description = "name of the service or team or cluster of services"
}

variable "instance_type"  {
  description = "instance type of the first ec2 instance"
}

variable "ebs_optimized" {
  description = "instance status"
}

variable "aws_region" {
  description = "aws region"
  default = "eu-west-2"
}

variable "key_pair" {
  description = "aws keypair"
  default = "id_rsa"
}

variable "primary_subnet" {}
variable "secondary_subnet" {}
variable "vpc_id" {}
