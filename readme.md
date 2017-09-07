# Distributed Hello World in AWS NodeJS

## Prerequisites
* Terraform v0.10.4
* Packer v1.0.0
* aws-cli/1.11.147
  1. via os package manager
  2. via pip3 
* Docker 17.06. 
  
## Local Development 
Vagrant


## Setup AWS Credentials
* `aws configure`
   1. `Add Access Key, Secret Key, Region, Output`
* alternatively use EC2 instance with Role 
   1. Should be able to create vpc resources, route53 resources and ec2 resources

## Setup AWS Infrastructure
```
git clone https://github.com/kenichi-shibata/hellownode
cd hellownode/infra/
cp terraform.mars terraform.tfvars

# update the contents of terraform.tfvars
terraform plan

# check the aws resources to be created
terraform show

# once you are satisfied
terraform apply

# once the infrastructure has been created and there is no error
terraform output -json > vm/out.json
```
