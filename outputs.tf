output "elb_address" {
  value = "${aws_elb.web.dns_name}"
}

output "elb_name" {
  value = "${aws_elb.web.name}"
}


output "web_sg_id" {
    value = "${aws_security_group.web.id}"
}

output "availability_zones" {
    value = "${join(",", aws_elb.web.availability_zones)}"
}

output "public_subnets" {
    value = "${join(",", aws_elb.web.subnets)}"
}

output "private_subnets" {
    value = "${aws_subnet.private-a.id},${aws_subnet.private-b.id},${aws_subnet.private-c.id}"
}

output "environment" {
    value = "${var.environment}"
}

output "rds_main_address" {
    value = "${aws_db_instance.main.address}"
}
