resource "aws_instance" "name" {
  ami = var.ami
  instance_type = var.instance_type
  for_each = toset(var.test)
  tags = {
    Name = each.key
  }
}