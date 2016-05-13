# Public A record
resource "aws_route53_record" "public-a" {
  zone_id = "${terraform_remote_state.csd.output.r53_notes_zone_id}"
  name = "${var.domain_prefix}"
  type = "A"

  alias {
    name = "${aws_elb.web.dns_name}"
    zone_id = "${aws_elb.web.zone_id}"
    evaluate_target_health = true
  }
}

# SSH A record
resource "aws_route53_record" "ssh-a" {
  zone_id = "${terraform_remote_state.csd.output.r53_notes_zone_id}"
  name = "ssh.${var.domain_prefix}"
  type = "A"
  ttl = "300"
  records = ["${aws_instance.ssh-bastion.public_ip}"]
}
