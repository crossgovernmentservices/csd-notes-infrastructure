# SSH bastion host
resource "aws_instance" "ssh-bastion" {
  instance_type = "t2.micro"
  ami = "ami-f95ef58a"
  key_name = "${var.key_name}"
  subnet_id = "${aws_subnet.public-a.id}"
  vpc_security_group_ids = ["${aws_security_group.ssh-bastion.id}"]
  associate_public_ip_address = true
  user_data = <<EOF
#!/bin/bash
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDL/56dxiNa40Fp6Ii9fOafsWzjOGY2c6rOBndXVadmzivFkvnsU/ov3oMvKG+tYS5RrBFIfx1Al+L/Le9FCFUOBwJofoV2fKlr1WZLzAz3nND36Nbbsf8JNQ7uQeEAYED5mJUScAPhdzHANL43KBDM/rgdb+lJtenLFw0U5XzPKJmPybzTZIURmG5wA4cNIWkGZQsCMRQhJ5vTFUkqmLG29YrsxON0MQS0S4G+Jnu62MX/yPb0CjqF1w4thly4gUA4y/uZN788nZFb6yHDDJLCzFfn7bL8+F/qbPWw6OSc7TsMF6RW37eIGLTGnMTP7GLjv6NnxKQMKYM1wh9dxHlB1pOS6NMSNBUX0/E2O4k3hD52M+iAtbalQzm/iMu7DuI09c/GN99QzODdnJMdwBUUQYXZ4MWMbNJfGdtO62sGYYIChcIEcQoUHytY+yxhrit0Z4DqwL+hB8Yv6u2vU7mpkFH+rPAq2nZhFHRW58CSECWT2kpkmy4h+yGi8VPeczY6qQjr0RjKym7Ee5Td7Yia5dkReG5f4Xx5ZXs/rcr4oNEri3JW3z6gXmgNvqlG53s1OxwCBtwULCnVu9lKcMLr5+GgSYDd0oFzdtDGDrTv17G+AQ/32X4w68LilYXDKvSmW3zkbAvud9SE0NzRgJ887A2bsaYoYdogiuij5m8t3Q==" >> /home/ubuntu/.ssh/authorized_keys
EOF

  tags {
    Name = "notes-ssh-${var.environment}"
    Environment = "${var.environment}"
  }
}
