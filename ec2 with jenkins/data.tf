data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"] # ✅ Amazon's official AMIs

  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-x86_64"] # ✅ Fetch latest Amazon Linux 2023 AMI
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_availability_zones" "azs" {}
