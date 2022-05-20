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
