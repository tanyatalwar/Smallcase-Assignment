resource "aws_launch_template" "smallcase" {
    name_prefix   = "smallcase"    //create a unique name beginning with the specified prefix
    image_id      = var.image_id  //The AMI from which to launch the instance
    instance_type = var.instance_type // The instance type

    #the vpc subnet
    subnet_id = "${aws_subnet.main-public-1.id}"

    #the security group
    vpc_security_group_ids = "${aws_security_group.allow-ssh.id}"

    #the public ssh key
    key_name = "${aws_key_pair.mykeypair.key_name}"
}


resource "aws_eip" "main-eip"{
   instance = "${aws_instance.main.id}"
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