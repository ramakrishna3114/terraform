resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}
resource "aws_subnet" "name" {
  vpc_id = aws_vpc.name.id
  cidr_block = var.cidr_block
}
resource "aws_security_group" "name" {
  name = "security"
  dynamic "ingress" {
    for_each = var.sgrule
    content {
     description = "Allow access to port ${ingress.key}"
      from_port = ingress.key
      to_port = ingress.key
      protocol = "tcp"
      cidr_blocks = [ingress.value]
    }
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "my-sg"
  }
}

