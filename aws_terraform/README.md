Step 1:
Running Application on local Setup
- Making Dockerfile present in aws_terraform/DockerImage/Dockerfile
- Dockerfile takes python:3.8-slim-buster as base image
- install required lib from requirement.yml(aws_terraform/DockerImage/Dockerfile/requirement.yml)
- I am using flask for serving my ec2/ api and boto3 lib for interation with AWS resource
- after building the image I pushed it to https://hub.docker.com/repository/docker/tanyatalwar/smallassignment

Step 2:
Started with terraform automation for AWS provider
all files are present in(Smallcase-Assignment/aws_terraform/ec2_terraform/)
1. providers.tf - contain AWS provider info
2. vpc.tf - contain VPC,subnet,internet gateway terraform code
3. instance.tf - Define launch template for EC2
4. autoscaling.tf - for autoscaling in AWS
5. securitygroup.tf - for security group defination
6. keypairs.tf - for getting keypair and pass
7. securitygroup.tf - for defining security group
8. vars.tf - for storing all variables


Step 3:
Running Ansible with terraform
1. provisioner.tf - for running Ansible on launched instance
2. provision.yml - to install docker and run docker image on EC2 launched instance
