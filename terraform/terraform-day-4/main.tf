resource "aws_vpc" "name" {
  cidr_block = var.cidr_block
}
resource "aws_subnet" "name" {
    vpc_id = var.vpc_id
    cidr_block = var.aws_subnet
}