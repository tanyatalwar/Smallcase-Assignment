//creating VPC 
resource "aws_vpc" "main"{
	cidr_block = "10.0.0.0/16"
	instance_tenancy = "default" //to control one VPC on single physical machine
	enable_dns_support   = "true"
    enable_dns_hostnames = "true" // to get internal host name and domaine name
    enable_classiclink = "false" // to link your VPC to EC2-Classic
    tags = {
       Name = "main"
    }
}

//creating public subnet
resource "aws_subnet" "main-public-1"{
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.1.0/24"
	map_public_ip_on_launch = "true"
	availability_zone = var.availabilityZone // you can mention availabilityZone here
    tags = {
       Name = "main-public-1"
    }
}

//creating private subnet
resource "aws_subnet" "main-private-1"{
	vpc_id = "${aws_vpc.main.id}"
	cidr_block = "10.0.4.0/24"
	map_public_ip_on_launch = "false"
	availability_zone = var.availabilityZone // you can mention availabilityZone here
    tags = {
       Name = "main-private-1"
    }
}

//Internet Gateway
resource "aws_internet_gateway" "main-gw"{
	vpc_id = "${aws_vpc.main.id}"
	tags = {
       Name = "main"
    }
}

//Route table
resource "aws_route_table" "main-public"{
	vpc_id = "${aws_vpc.main.id}"

	route{
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.main-gw.id}"  // all IP address are going to be routed to internet gateway
	}

	tags = {
       Name = "main-private-1"
    }
}

//route assocation public
resource "aws_route_table_association" "main-private-1"{ 
	subnet_id = "${aws_subnet.main-private-1.id}"
	route_table_id = "${aws_route_table.main-public.id}"
}