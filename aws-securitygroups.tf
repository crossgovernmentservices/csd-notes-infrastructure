# A security group for the ELB so it is accessible via the web
resource "aws_security_group" "elb" {
  name        = "notes-elb-${var.environment}"
  vpc_id      = "${aws_vpc.default.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "web" {
  name        = "notes-web-${var.environment}"
  vpc_id      = "${aws_vpc.default.id}"

  # SSH access from SSH bastion host
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = ["${aws_security_group.ssh-bastion.id}"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = ["${aws_security_group.elb.id}"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh-bastion" {
  name        = "notes-ssh-bastion-${var.environment}"
  vpc_id      = "${aws_vpc.default.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web-to-main-postgres" {
  name        = "web-to-main-postgres-${var.environment}"
  vpc_id      = "${aws_vpc.default.id}"

  # Postgres access from web instances
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = ["${aws_security_group.web.id}"]
  }
}

resource "aws_security_group" "allopen" {
  name = "notes-allopen-${var.environment}"
  vpc_id      = "${aws_vpc.default.id}"

  # inbound internet access
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# defined as a separate resource so the port can easily be made available
# as a terraform output value
# resource "aws_security_group_rule" "mongo-inbound-from-web" {
#     type = "ingress"
#     security_group_id = "${aws_security_group.mongo.id}"
#     source_security_group_id = "${aws_security_group.web.id}"
#     from_port   = 27017
#     to_port     = 27017
#     protocol    = "tcp"
# }
