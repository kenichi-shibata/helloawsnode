module "cloud_network" {
  source           ="./infra/setup-cloud-network"
  pre_tag          ="${var.pre_tag}"
  platform_name    ="${var.platform_name}"
  environment      ="${var.environment}"
  service_name     ="${var.service_name}"
  business_region  ="${var.business_region}"
  aws_region       ="${var.aws_region}"
}

module "application_server" {
  source             = "./infra/setup-application"
  instance_type      ="${var.instance_type}"
  vpc_id             ="${module.cloud_network.vpc_id}"
  primary_subnet     ="${module.cloud_network.primary_public_subnet}"
  secondary_subnet   ="${module.cloud_network.secondary_public_subnet}"
  application_name   ="${var.application_name}"
  aws_region         ="${var.aws_region}"
}

output "elb_dns" {
    value = "${module.application_server.elb_dns}"
}
