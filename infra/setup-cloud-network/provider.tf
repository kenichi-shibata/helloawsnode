provider "aws" {
  region = "${var.aws_region}" 
  profile = "test_builder"
  shared_credentials_file = "~/.aws/credentials"
}
