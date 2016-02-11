# web autoscaling launch config
resource "aws_launch_configuration" "web" {
  name = "web_config"
  image_id = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "t2.small"
  security_groups = ["${aws_security_group.web.id}"]
  key_name = "${aws_key_pair.auth.id}"
}

# web autoscaling group
resource "aws_autoscaling_group" "web" {
  name = "web_asg"
  launch_configuration = "${aws_launch_configuration.web.id}"
  vpc_zone_identifier = [
    "${aws_subnet.private-a.id}",
    "${aws_subnet.private-b.id}",
    "${aws_subnet.private-c.id}"
  ]
  load_balancers = ["${aws_elb.web.id}"]
  max_size = 6
  min_size = 3
  desired_capacity = 3
}

# SSH bastion host
resource "aws_instance" "ssh-bastion" {
  instance_type = "t2.micro"
  ami = "ami-f95ef58a"
  key_name = "${aws_key_pair.auth.id}"
  subnet_id = "${aws_subnet.public-a.id}"
  vpc_security_group_ids = ["${aws_security_group.ssh-bastion.id}"]
  associate_public_ip_address = true
}
