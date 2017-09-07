
#Pre tag to append to all resources
variable "pre_tag" {
  description = "Pre Tag for all the resources"
}

variable "platform_name" {
  description = "Name of the platform or platform team or maybe even project name if you have high scale project"
}

variable "environment" {
  description = "Name of Environment"
  default = "dev"
}

variable "service_name" {
  description = "name of the service or team or cluster of services"
}

variable "business_region" {
  description = "business region for the company separate from aws_region"
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


variable "centos_amis" {
  description = "CentOS AMIs by region"
  default = {
    ap-southeast-1 = "ami-f068a193"
    ap-northeast-1 = "ami-eec1c380"
    ap-south-1 = "ami-95cda6fa"
    us-east-1 = "ami-6d1c2007"
    us-west-1 = "ami-af4333cf"
    us-west-2 = "ami-d2c924b2"
  }
}

variable "amazon_amis" {
  description = "Amazon AMIs by region"
  default = {
    ap-southeast-1 = "ami-b953f2da"
    ap-northeast-1 = "ami-0c11b26d"
    ap-south-1 = "ami-34b4c05b"
    us-east-1 = "ami-b73b63a0"
    us-west-1 = "ami-5ec1673e"
    us-west-2 = "ami-23e8a343"
  }
}
