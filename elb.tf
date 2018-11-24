resource "random_id" "lb" {
  byte_length = 2
}

resource "aws_elb" "lb" {
  name            = "${var.name_prefix}lb-${random_id.lb.hex}"
  subnets         = ["${var.subnets}"]
  security_groups = ["${aws_security_group.elb.id}"]

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8080/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 300
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "${var.name_prefix}-lb"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "elb" {
  name_prefix = "${var.name_prefix}elb-"
  vpc_id      = "${var.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "elb_http_inbound" {
  security_group_id = "${aws_security_group.elb.id}"
  type              = "ingress"
  description       = "Allow HTTP Inbound from Internet"

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "elb_http_alt_outbound" {
  security_group_id = "${aws_security_group.elb.id}"
  type              = "egress"
  description       = "Allow HTTP Alt Outbound to EC2 Security Group"

  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.ec2.id}"
}
