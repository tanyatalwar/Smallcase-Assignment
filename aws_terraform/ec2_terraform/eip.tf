resource "aws_eip" "main-eip"{
   instance = "${aws_launch_template.smallcase.id}"
   vpc = true
}

resource "aws_route53_zone" "smallcase-come"{
   name = "smallcase.com"
}

resource "aws_route53_record" "server-1-record"{
   zone_id = "${aws_route53_zone.smallcase-come.id}"
   name = test.smallcase.com
   type = "A"
   ttl = "300"
   records = ["${aws_eip.smallcase-come.public_ip}"]
}
