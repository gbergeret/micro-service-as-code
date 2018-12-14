data "template_file" "bootstrap" {
  template = "${file("${path.module}/bootstrap.yml")}"

  vars {
    app_docker_image = "gbergere/micro-service-as-code:${var.app_version}"
  }
}

resource "aws_launch_configuration" "ec2" {
  name_prefix   = "${var.name_prefix}"
  image_id      = "${data.aws_ami.core.id}"
  instance_type = "t3.nano"

  security_groups = [
    "${aws_security_group.ec2.id}",
    "${var.additional_security_groups}",
  ]

  user_data_base64 = "${base64encode(data.template_file.bootstrap.rendered)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ec2" {
  depends_on = ["aws_lb_listener.l"]

  name_prefix          = "${var.name_prefix}"
  launch_configuration = "${aws_launch_configuration.ec2.name}"
  target_group_arns    = ["${aws_lb_target_group.g.arn}"]
  vpc_zone_identifier  = ["${var.subnets["private"]}"]

  min_size                  = 2
  max_size                  = 2
  wait_for_elb_capacity     = 1
  wait_for_capacity_timeout = "5m"
  health_check_grace_period = 300
  health_check_type         = "ELB"

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}ec2"
    propagate_at_launch = true
  }

  tag {
    key                 = "Version"
    value               = "${var.app_version}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "ec2" {
  name_prefix = "${var.name_prefix}ec2-"
  vpc_id      = "${var.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ec2_http_alt_inbound" {
  security_group_id = "${aws_security_group.ec2.id}"
  type              = "ingress"
  description       = "Allow HTTP Alt Inbound from LB Security Group"

  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.lb.id}"
}
