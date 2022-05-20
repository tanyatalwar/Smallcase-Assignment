terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region  = "us-east-2" // specify EC2 region here
  access_key =  var.access_key_cred
  secret_key =  var.secret_key_cred
}

resource "aws_launch_template" "smallcase" {
    name_prefix   = "smallcase"    //create a unique name beginning with the specified prefix
    image_id      = var.image_id  //The AMI from which to launch the instance
    instance_type = var.instance_type // The instance type
}

resource "aws_autoscaling_group" "scaling-vm" {
    availability_zones = ["us-east-1a"] // what is availability_zone
    desired_capacity   = 1 //the number of EC2 instance running
    max_size           = 2 //the maximum size of Autoscaling group
    min_size           = 1 //the minimum size of Autoscaling group

    //nested argument to launch instance
    launch_template = {
      id      = "${aws_launch_template.smallcase.id}" 
      version = "$Latest"
    }
}

resource "aws_vpc" "My_VPC" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = var.instanceTenancy 
  enable_dns_support   = var.dnsSupport 
  enable_dns_hostnames = var.dnsHostNames

  tags = {
    Name = "My VPC"
  }
}

resource "aws_subnet" "My_VPC_Subnet" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.subnetCIDRblock
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone

  tags = {
   Name = "My VPC Subnet"
  }
}

resource "aws_security_group" "My_VPC_Security_Group" {
  vpc_id       = aws_vpc.My_VPC.id
  name         = "My VPC Security Group"
  description  = "My VPC Security Group"
}

resource "aws_security_group_rule" "allow_all" {
  type         = "ingress"
  from_port    = 80
  to_port      = 80
  protocol     = "http"
  source_security_group_id = aws_security_group.My_VPC_Security_Group.id
  security_group_id = aws_security_group.My_VPC_Security_Group.id
}

resource "aws_lb" "aws-lb-1" {
    name = "test-lb-tf"
    internal           = false
    load_balancer_type = "application"
}

resource "aws_alb_target_group" "target-group-1" {
    name = "target-group-1" // create a unique name
    port = 80 // port on which target rece traffic
    protocol = "HTTP"

    health_check {
      path = "/ec2"
      port = 8000
      healthy_threshold = 4 \\ no of health check required before considering unhealthy target healthy
      unhealthy_threshold = 4 \\ no of health check required before conidering healthy target unhealthy 
      timeout = 2
      interval = 5
      matcher = "200"  # has to be HTTP 200 or fails
  }   
}

resource "aws_lb_listener" "my-alb-listener" {
    load_balancer_arn = aws_lb.front_end.arn

}

provisioner "remote-exec" {

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.ssh_key_private)}"
    }
  }


provisioner "local-exec" {
    command = "ansible-playbook -u ubuntu -i '${self.public_ip},' --private-key ${var.ssh_key_private} provision.yml" 
  }





//AWS EC2 Launch Template
We need to provide configuration to launch instance from EC2
//ASG stands for AWS Auto Scaling group
// an Elastic IP address is that dosent change a static IP address
//target group tells a load balancer where to direct traffic to : EC2 instances, fixed IP addresses
//AWS offer Load Balancer Elastic load Balancer
//you define health  check and the Load Balancer does not route traffic to an unhealthy  instance in the group
//The downside of CLBs is that you have only one health check per LB - Classic Load Balancer
//Application load balancer is a strict 7 layer LB - you can create target group which each have one health check
//Then you can configure a listener for  ALB and provide rules to the listener that tell it to route to a  particular target group.
//Two major resources that you need to pay attention are Listeners and Target
//Provides a Load Balancer Listener resource.
//AWS VPC - Virtual Private Network
//AWS Subnet - A subnet is a range of IP addresses in your VPC
//A Security group act as a virtual firewall control the traffic for one or more instances 

