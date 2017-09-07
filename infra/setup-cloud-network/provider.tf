provider "aws" {
  region = "${var.aws_region}" 
  profile = "kenichi.shibata"
  shared_credentials_file = "/home/ubuntu/.aws/credentials"
}
