resource "aws_vpc" "name" {
  cidr_block = var.cidr_block
}
resource "aws_subnet" "name" {
  vpc_id = var.vpc_id
  cidr_block = var.aws_subnet
}
resource "aws_subnet" "subnet2" {
  vpc_id = var.vpc_id
  cidr_block = var.aws_subnet2
}
resource "aws_instance" "name" {
  ami = var.ami
  instance_type = var.instance_type
}