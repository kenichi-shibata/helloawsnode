# Distributed Hello World in AWS and Docker Containers NodeJS

## Prerequisites
* Terraform v0.10.4
* Packer v1.0.0
* aws-cli/1.11.147
  1. via os package manager
  2. via pip3 
* Docker 17.06. 
* jq
* or if you are running debian based distros use `./dev install-deb`
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
              ASG Instance 1                                                        ASG Instance 2
```

### Features

* Two layers of high availability (containers and instances)
* Auto restarting docker containers (via docker) and ec2 instances (via asg)
* Ability to scale on both infrastructure and container level
* Resilient against from container level failures to AWS AZ Data Center Failure
* Two layers of health checks (container and instance level)

## Usage
### Setup AWS Credentials
`Credentials should be able to create vpc resources and ec2 resources`

* `aws configure --profile test.builder`
   1. `Add Access Key, Secret Key, Region (eu-west-2), Output`(json)
* alternatively use EC2 instance role with enough permissions 

## Setup Hello World NodeJS App AMI 
   1. `./deploy ami`
   1. The AMI is tagged using `infra/vm/variables.json` please update version key to create a new one. AMI does not accept duplicate names
   
### Initialize your terraform modules

    $ terraform get # will get the modules under infra
    $ terraform init # will get the aws provisioners

### Setup your terraform.tfvars

    $ cp terraform.dummy terraform.tfvars
    $ # update the terraform.tfvars

### Setup AWS Infrastructure

    $ terraform plan

Check the output of the terraform plan and see if all necessary network
resources are planned properly. 
You can also save this plan to a file to make sure that the displayed plan
will be the one carried out

    $ terraform plan -out helloawsnode.plan

If you haven't created any resources before this you have `Plan: 22 to add, 0
to change, 0 to destroy.` as your last output before the ending `-----`

To apply changes run

    $ terraform apply "helloawsnode.plan"
    
* Done! You now have an ASG running behind an elb with containerized instances of helloawsnode app
* Please check the url of your elb; after all instances are healthy you should be able to access the elb url. Elb url is similar to `<http://helloawsnode-elb-1362671146.eu-west-2.elb.amazonaws.com/>`

## Customizing Tags
To customize tags,
* `terraform.tfvars` update the value
* `infra/vm/variable.json` update value
## Cleaning up
* On the root directory run `terraform destroy`
* Have to delete ami created by packer manually for now

## Development Mode
* Install vagrant
* `./dev start` start the dev VM
* `./dev bash` to go inside dev VM
* `cd /helloawsnode`
* `./dev up` to start docker compose up inside the docker VM
* Test `curl localhost:80`
* `./dev scale 5` to scale the number of helloworld servers to 5
* `sudo docker ps` to check the running containers
* `sudo docker-compose ps` to check the single node(instance) cluster
* Watch the logs by `./dev logs`
* In another shell `./dev test`

> dev uses vagrant for start and end ; uses docker compose for up and down 

> dev uses dev-docker-compose and Dev-Dockerfile

> dev is a vagrant default VM machine using docker as provider

> dev VM mounts the entire repo so any changes will be reflected 

> dev VM also mounts the docker socket so the docker daemon running on the host machine is the same as the one in the VM 

## Cleaning up Dev Mode
```
./dev down
./dev end
./clean both
```

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

## Improvement
* [x] Use modules instead of ${var} and jq
* [ ] Reuse vm to docker compose container on ./dev up

