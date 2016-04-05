resource "aws_route53_zone" "notes" {
  name = "${var.r53_notes_zone_name}"
}

resource "aws_route53_record" "notes-ns" {
    zone_id = "${var.r53_main_zone_id}"
    name = "${var.r53_notes_zone_name}"
    type = "NS"
    ttl = "30"
    records = [
        "${aws_route53_zone.notes.name_servers.0}",
        "${aws_route53_zone.notes.name_servers.1}",
        "${aws_route53_zone.notes.name_servers.2}",
        "${aws_route53_zone.notes.name_servers.3}"
    ]
}
