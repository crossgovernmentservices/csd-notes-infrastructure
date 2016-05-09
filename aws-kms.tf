resource "aws_kms_key" "credstash" {
    description = "notes-${var.environment}-credentials"
    deletion_window_in_days = 7
}

resource "aws_kms_alias" "credstash" {
    name = "alias/notes-${var.environment}-credentials"
    target_key_id = "${aws_kms_key.credstash.key_id}"
}
