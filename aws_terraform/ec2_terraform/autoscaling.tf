resource "aws_autoscaling_group" "scaling-vm" {
    name = "autoscaling"
    availability_zones = var.availability_zones// what is availability_zone
    vpc_zone_identifier = [${aws_subnet.main-public-1.id}]
    desired_capacity   = 1 //the number of EC2 instance running
    max_size           = 2 //the maximum size of Autoscaling group
    min_size           = 1 //the minimum size of Autoscaling group
    health_check_grace_period = 300
    health_check_type = "ALB"
    load_balancers = ["${aws_alb.my-alb.id}"]

    //nested argument to launch instance
    launch_template = {
      id      = "${aws_launch_template.smallcase.id}" 
      version = "$Latest"
    }
}

resource "aws_autoscaling_policy" "cpu-policy"{
   name = "cpu-policy"
   autoscaling_group_name = "${aws_autoscaling_group.scaling-vm.id}"
   adjustment_type = "ChangeInCapacity"
   scaling_adjustment = 1
   cooldown = "300"
   policy_type = "SimpleScaling"

}

resource "aws_cloudwatch_metric_alarm" "cpu-alarm"{
   name = "cpu-alarm"
   comparsionOperator = "GreaterThanOrEqualToThreshold"
   evaluations_periods = "2"
   metricname = CPUUtilization
   period = 120
   statics = Average
   threshold = 30 // we compare threshold 0f 30% for period of 120s

   dimensation = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.scaling-vm.name}"
   }

   action_enabled = true

   alarm_action = ["${aws_autoscaling_policy.cpu-policy.arn}"]


}

resource "aws_sns_topic" "cpu-sns"{
  name = "sg_cpu_sns"
  display_name = "example ASG SNS Topic"
}

#sns needs a topic
resource "aws_autoscaling_notification" "example-notify"{
  group_names = ["${aws_autoscaling_group.scaling-vm.name}"]
  topic_arn = "${aws_sns_topic.cpu-sns.arn}"
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH"
    "autoscaling:EC2_INSTANCE_TERMINATE"
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR"
  ]
}