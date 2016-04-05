variable "aws_region" {
  description = "AWS region to launch servers."
  default = "eu-west-1"
}

variable "r53_main_zone_id" {
  description = "Main parent DNS zone ID in R53"
}

variable "r53_notes_zone_name" {
    description = "DNS zone for 'notes' services"
}
