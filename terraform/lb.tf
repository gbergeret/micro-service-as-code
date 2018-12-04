resource "random_id" "lb" {
  byte_length = 2
}

resource "random_id" "target_group" {
  byte_length = 2
}

resource "aws_lb" "lb" {
  name            = "${var.name_prefix}lb-${random_id.lb.hex}"
  subnets         = ["${var.subnets}"]
  security_groups = ["${aws_security_group.lb.id}"]

  enable_cross_zone_load_balancing = true
  idle_timeout                     = 300

  tags {
    Name = "${var.name_prefix}-lb"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "l" {
  load_balancer_arn = "${aws_lb.lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.g.arn}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "g" {
  name     = "${var.name_prefix}tg-${random_id.target_group.hex}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 2
    path                = "/health"
    matcher             = "200"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "lb" {
  name_prefix = "${var.name_prefix}lb-"
  vpc_id      = "${var.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "lb_http_inbound" {
  security_group_id = "${aws_security_group.lb.id}"
  type              = "ingress"
  description       = "Allow HTTP Inbound from Internet"

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lb_http_alt_outbound" {
  security_group_id = "${aws_security_group.lb.id}"
  type              = "egress"
  description       = "Allow HTTP Alt Outbound to EC2 Security Group"

  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.ec2.id}"
}
