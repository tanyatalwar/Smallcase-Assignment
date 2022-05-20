resource "aws_eip" "nat"{
	vpc = true
}

resource "aws_nat_gateway" "nat-gw"{
	allocation_id = "${aws_eip.nat.id}"
	subnet_id = "${aws_subnet.main-public-1.id}"
	depends_on = ["aws_internet_gateway.main-gw"]
}

#VPC for nat
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

#route assocaition
resource "aws_route_table_association" "main-private-1"{
    subnet_id = "${aws_subnet.main-private-1.id}"
	route_table_id = "${aws_route_table.main-private.id}"
}