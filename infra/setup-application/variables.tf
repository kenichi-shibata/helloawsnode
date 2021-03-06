variable "instance_type"  {
  description = "instance type of the first ec2 instance"
}

variable "aws_region" {
  description = "aws region"
  default = "eu-west-2"
}

variable "primary_subnet" {}
variable "secondary_subnet" {}
variable "vpc_id" {}
variable "application_name" {}
