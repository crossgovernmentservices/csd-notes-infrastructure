resource "aws_route53_zone" "dev" {
  name = "dev.civilservice.digital"
  tags {
    Environment = "dev"
  }
}

resource "aws_route53_record" "ssh" {
    zone_id = "${aws_route53_zone.dev.zone_id}"
    name = "ssh.dev.civilservice.digital"
    type = "A"
    ttl = "300"
    records = [
       "${aws_instance.ssh-bastion.public_ip}"
    ]
}
