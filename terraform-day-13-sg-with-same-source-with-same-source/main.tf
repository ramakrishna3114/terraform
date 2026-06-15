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
  vpc_id = aws_vpc.name.id
  ingress = [
    for port in var.sgrule : {
     description = "allows"
      from_port = port
      to_port = port
       ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups   = []
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        self             = false
      protocol = "tcp"
      cidr_block = ["0.0.0.0/0"]
  }
  ]
}

resource "aws_instance" "name" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.name.id
  vpc_security_group_ids =  [aws_security_group.name.id]
  tags = {
    Name = "test"
  }
}