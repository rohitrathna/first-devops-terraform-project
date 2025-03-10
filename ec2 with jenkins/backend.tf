terraform {
  backend "s3" {
    bucket = "my-first-db"
    key    = "jenkins/terraform.tfstate"
    region = "ap-south-1"
  }
}   