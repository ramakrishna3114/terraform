resource "aws_vpc" "dev" {
  cidr_block = var.cidr_block
}
resource "aws_instance" "name" {
    ami = var.ami
     instance_type = var.instance_type
     tags = {
        Name = "sweety"
     }
}