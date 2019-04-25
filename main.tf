# set up a multi-tier vpc with  pub and prv ec2, sg, nat gateway, route table

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

# vpc
resource "aws_vpc" "mainVpc" {
  cidr_block = "10.0.0.0/16"
}

# internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.mainVpc.id}"
}

# this is not the main route table
# need to associate the pub subnet with the main rt
# use below to associate priv sub with nat
# main route table
resource "aws_route_table" "mainRt" {
  vpc_id = "${aws_vpc.mainVpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"

    # instance_id = "${aws_instance.web.id}"
  }

  tags {
    Name = "VPC-RT"
  }
}

# assocaite subnet with route table
resource "aws_route_table_association" "rt-assoc" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.mainRt.id}"
}

# subnets
# public subnet
resource "aws_subnet" "public" {
  vpc_id           = "${aws_vpc.mainVpc.id}"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "Public Subnet"
  }
}

# private subnet
resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.mainVpc.id}"
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "Private Subnet"
  }
}

# public ec2
resource "aws_instance" "web" {
  depends_on                  = ["aws_internet_gateway.gw"]
  ami                         = "ami-0cd3dfa4e37921605"
  instance_type               = "t2.micro"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids      = ["${aws_security_group.dmz_2.id}"]
  subnet_id                   = "${aws_subnet.public.id}"
  associate_public_ip_address = true

  tags = {
    Name = "Web Terraform EC2"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.web.public_ip} > pub_ip_address.txt"
  }
}

# Security Group- dmz_2
resource "aws_security_group" "dmz_2" {
  name        = "dmz-2"
  description = "SG for DMZ"
  vpc_id      = "${aws_vpc.mainVpc.id}"

  egress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "dmz_2"
  }
}
