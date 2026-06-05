resource "aws_vpc" "name" {
cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "name" {
vpc_id = aws_vpc.name.id 
cidr_block = "10.0.1.0/24"
}
resource "aws_subnet" "subnet2" {
vpc_id = aws_vpc.name.id
cidr_block = "10.0.2.0/24"
}   
resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.name.id
 tags = {
   name = "gw"
 } 
}
resource "aws_route_table" "public_rt" {
 vpc_id = aws_vpc.name.id
 tags = {
   name = "public-rt"
 } 
}
resource "aws_route_table" "private_rt" {
 vpc_id = aws_vpc.name.id
 tags = {
   name = "private-rt"
 } 
}
resource "aws_route_table_association" "a" {
 subnet_id = aws_subnet.name.id
 route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "b" {
 subnet_id = aws_subnet.subnet2.id
 route_table_id = aws_route_table.private_rt.id
}
resource "aws_nat_gateway" "name" {
  allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.name.id
}
resource "aws_route" "public" {
 route_table_id = aws_route_table.public_rt.id
 destination_cidr_block = "0.0.0.0/0"
 gateway_id = aws_internet_gateway.gw.id
}
resource "aws_route" "private" {
 route_table_id = aws_route_table.private_rt.id
 destination_cidr_block = "0.0.0.0/0"
 nat_gateway_id = aws_nat_gateway.name.id
}
resource "aws_eip" "nat" {
  domain = "vpc"
}
resource "aws_instance" "name" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.name.id
}
resource "aws_instance" "instance2" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.subnet2.id
}
resource "aws_security_group" "name" {  
    name = "allow_ssh"
    description = "Allow SSH inbound traffic"
    vpc_id = aws_vpc.name.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]  
}
  }
resource "aws_db_instance" "name" {
  allocated_storage = 20
  engine = "mysql"
  engine_version = "8.0"
  instance_class = "db.t3.micro"
  db_name = var.db_name
  username = "admin"
  password = "password123"
}