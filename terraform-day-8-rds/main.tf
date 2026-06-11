resource "aws_vpc" "name" {
  cidr_block = var.vpc_cidr
  tags = {
    name = "my-vpc"
  }
}
resource "aws_subnet" "name" {
  vpc_id = aws_vpc.name.id
  cidr_block = var.aws_subnet_name
  availability_zone = "us-east-1a"
  tags = {
    Name ="my-subnet"
  }
}
resource "aws_subnet" "name2" {
  vpc_id = aws_vpc.name.id
  cidr_block = var.aws_subnet_name2
  availability_zone = "us-east-1b"
  tags = {
    Name = "my-subnet-2"
  }
  }
  resource "aws_internet_gateway" "name" {
    vpc_id = aws_vpc.name.id
    tags = {
      Name ="igw"
    }
  }
  resource "aws_route_table" "public" {
    vpc_id = aws_vpc.name.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.name.id
    }
  }
  resource "aws_route_table_association" "public-rt" {
    subnet_id = aws_subnet.name.id
    route_table_id = aws_route_table.public.id
  }
resource "aws_nat_gateway" "nat" {
    vpc_id = aws_vpc.name.id
    availability_mode = "regional"
  }
  resource "aws_route_table" "pvt" {
    vpc_id = aws_vpc.name.id
    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat.id
    }
  }
  resource "aws_route_table_association" "pvt-rt" {
    subnet_id = aws_subnet.name2.id
    route_table_id = aws_route_table.pvt.id
  }
  resource "aws_instance" "name" {
    ami = var.ami
    instance_type = var.instance_type
    availability_zone = "us-east-1a"
  }
resource "aws_db_instance" "name" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "sweety"
  password             = "123456789"
  db_subnet_group_name = "my-db-subnet-group"
  skip_final_snapshot  = true
}
resource "aws_db_subnet_group" "name" {
  name = "my-db-subnet-group"
  subnet_ids = [
    aws_subnet.name.id,
    aws_subnet.name2.id
  ]
}