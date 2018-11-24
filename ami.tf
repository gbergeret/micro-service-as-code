data "aws_ami" "core" {
  most_recent = true
  owners      = ["595879546273"]

  filter {
    name   = "name"
    values = ["CoreOS-stable*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
