# resource "aws_key_pair" "auth" {
#   key_name   = "${var.key_name}"
#   public_key = "${file(var.public_key_path)}"
# }

resource "terraform_remote_state" "csd" {
    backend = "s3"
    config {
        bucket = "csd-terraform"
        key = "terraform.tfstate"
        region = "eu-west-1"
    }
}
