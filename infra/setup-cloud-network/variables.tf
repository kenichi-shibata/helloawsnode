
#Pre tag to append to all resources
variable "pre_tag" {
  description = "Pre Tag for all the resources can be brand/dept/subdivision environment abbreviation if not prod"
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

variable "aws_region" {
  description = "aws region"
  default = "eu-west-2"
}

