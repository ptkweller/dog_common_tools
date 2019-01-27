resource "aws_subnet" "bastion_subnet" {
  vpc_id                  = "${aws_vpc.common_tools_vpc.id}"
  cidr_block              = "${var.bastion_subnet_cidr}"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1c"

  tags = {
    Name = "bastion_subnet"
  }
}

resource "aws_security_group" "bastion_security_group" {
  vpc_id      = "${aws_vpc.common_tools_vpc.id}"
  name        = "bastion_security_group"
  description = "bastion_security_group"

  ingress {
    cidr_blocks = "${var.ingress_cidr_list}"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = "${var.egress_cidr_list}"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
  }

  tags = {
    Name = "bastion_security_group"
  }
}

resource "aws_instance" "bastion" {
  ami                    = "${var.ami_id}"
  instance_type          = "${var.ami_size}"
  vpc_security_group_ids = ["${aws_security_group.bastion_security_group.id}"]
  subnet_id              = "${aws_subnet.bastion_subnet.id}"
  key_name               = "common_tools_instances"

  tags = {
    Name = "bastion"
  }
}

resource "aws_route_table_association" "bastion_route_table_association" {
  subnet_id      = "${aws_subnet.bastion_subnet.id}"
  route_table_id = "${aws_route_table.common_tools_public_route.id}"
}
