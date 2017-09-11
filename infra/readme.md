# Manual Steps

# Conventions
 * Use underscores to concatenate variable names, and dashes for tags.     
 * Use odd numbers for private subnets and even number for public subnets 
 * Use terraform.tfvars instead of typing all variables using stdout      
 * Create a terrafurm.dummy file to make tfvars                           
 * Define output into output.tf same with variables, provider  
 * Separate out resources via aws styled categories                       
   1. on cases which tf is growing too large separate the files via _ e.g. ec2_instance, ec2_lorem, ec2_ipsum  
# Best Practice
 * Isolate, lock and share terraform.tfstate using s3 and dynamodb 
 * Pipeline infra builds into CICD builder like jenkins or other tools to make infra build observable 
 * Reuse a specific aws region into our business region
    1. i.e. Manila Region does not exists so we reuse AWS Tokyo as Manila Business Region


# Build AMI
## To build the AMI  
* `./deploy ami`
## To add dependencies to the AMI
* update provision.sh

# Override Tags
## To override tags for network (vpc resources)
* `cp terraform.mars terraform.tfvars
* update the terraform.tfvars with desired values
## To override tags for ami
* update the variables.json 
