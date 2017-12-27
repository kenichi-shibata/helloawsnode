module "cloud-network" {
  source ="./infra/setup-cloud-network"
  pre_tag="dev"
  platform_name="integration"
  environment="development"
  service_name="infra"
  business_region="london"
  aws_region="eu-west-2"
}

module "application-server" {
  source = "./infra/setup-application"
  instance_type="t2.micro"
  vpc_id=""
  primary_subnet=""
  secondary_subnet=""
  application_name="helloworld"
  aws_region="eu-west-2"
}
