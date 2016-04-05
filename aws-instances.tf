# SSH bastion host
resource "aws_instance" "ssh-bastion" {
  instance_type = "t2.micro"
  ami = "ami-f95ef58a"
  key_name = "${var.key_name}"
  subnet_id = "${aws_subnet.public-a.id}"
  vpc_security_group_ids = ["${aws_security_group.ssh-bastion.id}"]
  associate_public_ip_address = true

  tags {
    Name = "notes-ssh-${var.environment}"
    Environment = "${var.environment}"
  }
}
