terraform {
  backend "s3" {
    bucket = "my-terraform-statefile-sweety"
    key ="terraform.tfstate"
    region = "us-east-1"
    use_lockfile = "true"
  }
}