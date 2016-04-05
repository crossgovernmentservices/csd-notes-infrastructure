resource "aws_elb" "web" {
  name = "notes-web-${var.environment}"

  subnets         = [
    "${aws_subnet.public-a.id}",
    "${aws_subnet.public-b.id}",
    "${aws_subnet.public-c.id}"
  ]
  security_groups = ["${aws_security_group.elb.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  tags {
    Name = "notes-web-${var.environment}"
    Environment = "${var.environment}"
  }
}
