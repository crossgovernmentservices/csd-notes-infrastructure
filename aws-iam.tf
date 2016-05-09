resource "aws_iam_instance_profile" "web" {
  name = "notes-web"
  roles = [
    "${aws_iam_role.web.name}"
  ]
}

resource "aws_iam_role" "web" {
  name = "notes-web"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  {
    "Sid": "",
    "Effect": "Allow",
    "Principal": {
      "Service": "ec2.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
  }]
}
EOF
}

resource "aws_iam_role_policy" "web_kms_reader" {
  name = "web_kms_reader"
  role = "${aws_iam_role.web.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
  {
    "Action": [
      "kms:Decrypt"
    ],
    "Effect": "Allow",
    "Resource":
      "${aws_kms_key.credstash.arn}"
  },
  {
    "Action": [
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:Scan"
    ],
    "Effect": "Allow",
    "Resource": "${aws_dynamodb_table.credstash.arn}"
  }]
}
EOF
}


resource "aws_iam_role_policy" "ec2_instance_reader" {
  name = "ec2_instance_reader"
  role = "${aws_iam_role.web.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:DescribeReservedInstances"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}
