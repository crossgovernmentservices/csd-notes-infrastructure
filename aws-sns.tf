resource "aws_sns_topic" "s3-email" {
    name = "csd-notes-${var.environment}-s3-email"
    policy = <<EOF
{
  "Version": "2008-10-17",
  "Id": "default_policy",
  "Statement": [
    {
      "Sid": "root_account",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish",
        "SNS:Receive"
      ],
      "Resource": "arn:aws:sns:${var.aws_region}:${var.aws_account_id}:csd-notes-${var.environment}-s3-email",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "${var.aws_account_id}"
        }
      }
    },
    {
      "Sid": "s3_publish",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "SNS:Publish",
      "Resource": "arn:aws:sns:${var.aws_region}:${var.aws_account_id}:csd-notes-${var.environment}-s3-email",
      "Condition": {
        "ArnLike": {
          "aws:SourceArn": "arn:aws:s3:${var.aws_region}:${var.aws_account_id}:csd-notes-${var.environment}-email"
        }
      }
    }
  ]
}
EOF
}



resource "aws_sns_topic" "s3-attachments" {
    name = "csd-notes-${var.environment}-s3-attachments"
    policy = <<EOF
{
  "Version": "2008-10-17",
  "Id": "default_policy",
  "Statement": [
    {
      "Sid": "root_account",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish",
        "SNS:Receive"
      ],
      "Resource": "arn:aws:sns:${var.aws_region}:${var.aws_account_id}:csd-notes-${var.environment}-s3-attachments",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "${var.aws_account_id}"
        }
      }
    },
    {
      "Sid": "s3_publish",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "SNS:Publish",
      "Resource": "arn:aws:sns:${var.aws_region}:${var.aws_account_id}:csd-notes-${var.environment}-s3-attachments",
      "Condition": {
        "ArnLike": {
          "aws:SourceArn": "arn:aws:s3:${var.aws_region}:${var.aws_account_id}:csd-notes-${var.environment}-email"
        }
      }
    }
  ]
}
EOF
}

resource "aws_sns_topic" "ses-email" {
    name = "csd-notes-${var.environment}-ses-email"
    policy = <<EOF
{
  "Version": "2008-10-17",
  "Id": "default_policy",
  "Statement": [
    {
      "Sid": "root_account",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish",
        "SNS:Receive"
      ],
      "Resource": "arn:aws:sns:${var.aws_region}:${var.aws_account_id}:csd-notes-dev-ses-email",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "${var.aws_account_id}"
        }
      }
    }
  ]
}
EOF
}
