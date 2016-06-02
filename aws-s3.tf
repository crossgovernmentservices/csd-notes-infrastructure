resource "aws_s3_bucket" "email" {
    bucket = "csd-notes-${var.environment}-email"
    acl = "private"

    lifecycle_rule {
        id = "emails"
        prefix = "emails"
        enabled = true
        expiration {
            days = 30
        }
    }

    policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "GiveSESPermissionToWriteEmail",
            "Effect": "Allow",
            "Principal": {
                "Service": "ses.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::csd-notes-${var.environment}-email/*",
            "Condition": {
                "StringEquals": {
                    "aws:Referer": "${var.aws_account_id}"
                }
            }
        }
    ]
}
EOF

    tags {
        Name = "csd-notes-${var.environment}-email"
        Environment = "${var.environment}"
    }
}
