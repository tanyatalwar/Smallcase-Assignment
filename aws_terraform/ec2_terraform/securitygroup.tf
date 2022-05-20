resource "aws_security_group" "myinstance"{
   vpc_id = "${aws_vpc.main.id}"
   name = "myinstance"
   egress{
     from_port = 0
     to_port = 0
     protocol = -1
     cidr_block = ["0.0.0.0/0"]
   }

   ingress{
     from_port = 22
     to_port = 22
     protocol = "tcp"
     cidr_block = ["0.0.0.0/0"]
   }

   ingress{
     from_port = 8000
     to_port = 8000
     protocol = "tcp"
     security_groups = ["${aws_security_group.alb-securitygroup.id}"]
   }

   tags{
     Name = "myinstance"
   }
}

resource "aws_security_group" "alb-securitygroup"{
  vpc_id = "${aws_vpc.main.id}"
  name = "alb"

  egress{
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_block = ["0.0.0.0/0"]
  }

  ingress{
    from_port = 8000
    to_port = 8000
    protocol = "tcp"
    cidr_block = ["0.0.0.0/0"]
  }
}

