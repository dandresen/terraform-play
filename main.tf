# set up a multi-tier vpc with  pub and prv ec2, sg, nat gateway, route table

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

# vpc
# resource "aws_vpc" "helloVpc" {
#   cidr_block = "10.0.0.0/16"
# }

# public ec2
resource "aws_instance" "web" {
  ami               = "ami-0cd3dfa4e37921605"
  instance_type     = "t2.micro"
  #security_group_id = "${aws_security_group.dmz_2.id}"
  key_name          = "andresen-work"

  tags = {
    Name = "Web EC2"
  }

  provisioner "local-exec" {
    command = "echo ${aws_instance.web.public_ip} > pub_ip_address.txt"
  }
}

# resource "vpc" "my-vpc" {
#   aws_region = ""
#   cidr_block = ""
# }

### Security Group- dmz_2
# resource "aws_security_group" "dmz_2" {
#   name        = "dmz-2"
#   description = "SG for DMZ"
#
#   tags {
#     "Name" = "dmz_2"
#   }
#
#   resource "aws_security_group_rule" "dmz_egress_all" {
#     type              = "egress"
#     protocol          = "all"
#     from_port         = 0
#     to_port           = 0
#     cidr_blocks       = ["0.0.0.0/0"]
#     security_group_id = "${aws_security_group.dmz_2.id}"
#     description       = "All outbound traffic"
#   }
#
#   resource "aws_security_group_rule" "dmz_ingress_ssh" {
#     type              = "ingress"
#     protocol          = "tcp"
#     from_port         = 22
#     to_port           = 22
#     cidr_blocks       = ["0.0.0.0/0"]
#     security_group_id = "${aws_security_group.dmz_2.id}"
#     description       = "SSH from anywhere"
#   }
# }

# resource "aws_security_group_rule" "sg_allow_ssh" {
#   # dmz  # create one for private subnet
# }
#
# resource "aws_security_group_rule" "sg_allow_http" {
#   # dmz  # create one for private subnet
# }


# resource "aws_route_table" "my-rt" {}
#
# resource "aws_nat_gateway" "my-nat-gtwy" {}
