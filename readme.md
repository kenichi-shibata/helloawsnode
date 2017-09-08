# Distributed Hello World in AWS and Docker Containers NodeJS

## Prerequisites
* Terraform v0.10.4
* Packer v1.0.0
* aws-cli/1.11.147
  1. via os package manager
  2. via pip3 
* Docker 17.06. 
  
## Local Development 
* Above Prequisites
* docker-compose version 1.14.0 or above (should support dockercompose file ver2.1)

## Architecture 
```
                                             +------------------+
                                             |      ELB         |
                   +-------------------------+                  +---------------------------+
                   |                         +------------------+                           |
           AWS Avai|ability Zone 1                                                AWS Availa|ility Zone 2
                   |                                                                        |
+-------------+----+----+---------------+                          +-----------------+------+---+---------------+
| +-----------------------------------+ |                          |  +---------------------------------------+ |
| |           |         |             | |                          |  |              |  NGINX LB|             | |
| |           | NGINX LB|             | |                          |  |              |          |             | |
| |           |         |             | |                          |  |              +----------+             | |
| |           +---------+             | |                          |  |                                       | |
| |                                   | |                          |  +-------+  +-------+ +------+ +-------+ | |
| +------+  +------+  +------+  +-----+ |                          |  ||      |  |       | |      | |       | | |
| |      |  |      |  |      |  |     | |                          |  || APP  |  | APP   | | APP  | | APP   | | |
| | APP  |  | APP  |  |  APP |  | APP | |                          |  ||      |  |       | |      | |       | | |
| |      |  |      |  |      |  |     | |                          |  +-------+  +-------+ +------+ +-------+ | |
| +------+  +------+  +------+  +-----+ |                          |  |               APP Scale               | |
| |          App Scale 4              | |                          |  |                                       | |
| |                                   | |                          |  +---------------------------------------+ |
| +-----------------------------------+ |                          |               Docker Containers            |
|           Docker Containers           |                          +--------------------------------------------+
+---------------------------------------+                         

```

### Features

* Two layers for high availability
* Auto restarting docker containers and ec2 instances (via asg)
* Ability to scale on both infrastructure and container level
* Resilient against from container level failures to AWS AZ Data Center Failure
* Two layers of health checks (container and instance level)

## Single Machine Demo

## Setup AWS Credentials
`Credentials should be able to create vpc resources and ec2 resources`

* `aws configure --profile test.builder`
   1. `Add Access Key, Secret Key, Region (eu-west-2), Output`(json)
* `alternatively use EC2 instance role with enough permissions `

## Setup AWS Infrastructure
* Initialize your VPC, Subnets and its associations (route tables, igw)
```
git clone https://github.com/kenichi-shibata/hellownode
cd hellownode/infra/setup-cloud-network
./auto

# To manually provision
# To override the tag names cp terraform.mars terraform.tfvars
# update the contents of terraform.tfvars

terraform plan

# check the aws resources to be created
terraform show

# once you are satisfied
terraform apply

# once the infrastructure has been created and there is no error
terraform output -json > vm/out.json
```
* Setup your application 
```
cd hellownode/infra/setup-application

```

## Development Mode
* Use vagrant docker 

## Scale the node-app
```
docker-compose scale node-app=5
docker-compose ps # to check
```

## Docker Compose
We are using docker compose ver2.1 since it has better support for single host docker compose ver3 is mainly for swarm mode
[ref](https://github.com/docker/compose/issues/374#issuecomment-285151437)

Using ver3 is possible however we would need to fix the startup order ourselves [fix for ver3](https://docs.docker.com/compose/startup-order/)
 
[Further reading](https://github.com/docker/compose/issues/4305)

## Rebuilding nodejs app image
Update the infra/vm/provision.sh as usual then run `docker-compose build` to refresh the image

[Further Reading](https://github.com/docker/compose/issues/1487)

## Updating nodejs app 
Update the code in app normally, since the volume is mounted instead of added the container gets the updates

[Further Reading](https://stackoverflow.com/questions/27735706/docker-add-vs-volume)
