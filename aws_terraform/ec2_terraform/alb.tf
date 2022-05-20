resource "aws_alb" "my-alb"{
	name = "my-alb"
	subnets = ["${aws_subnet.main-public-1.id}"]
	security_groups = ["${aws_security_group.alb-securitygroup.id}"]
}

//specify the target group
resource "aws_alb_target_group" "frontend-target-group"{
	name = "alb-target-group"
	port = 80 //check port here
	protocal = "HTTP"
	vpc_id = "${aws_vpc.main.id}""
}

resource "aws_alb_listener" "frontend-listeners"{
	load_balancer_arn = "${aws_alb.my-alb.arn}"
	port = "8000"

	default_action {
	  target_group_arn = "${aws_alb_target_group.frontend-target-group.arn}"
	  type = "forward"
	}
}

//alb rule
resource "aws_alb_listener_rule" "alb-rule"{
	listener_arn = "${aws_alb_listener.front_end.arn}"
	priority = 100

	action{
	  type = "forward"
	  target_group_arn = "${aws_alb_target_group.frontend-target-group.arn}"
	}

	condition{
	   field = "path-pattern"
	   values = ["/ec2/*"]
	}
}

//attach instance to target group
resource "aws_alb_target_group_attachment" "frontend-attachment"{
	target_group_arn = "${aws_alb_target_group.frontend-target-group}"
	target_id = "${aws_launch_template.mallcase.id}" 
	port = 8000
}

