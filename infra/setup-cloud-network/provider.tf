provider "aws" {
  region = "${var.aws_region}" 
  profile = "test.builder"
  shared_credentials_file = "${var.aws_credentials}"
}
