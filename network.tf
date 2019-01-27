resource "aws_vpc" "common_tools_vpc" {
  cidr_block           = "${var.vpc_cidr_block}"
  instance_tenancy     = "${var.instance_tenancy}"
  enable_dns_support   = "${var.dns_support}"
  enable_dns_hostnames = "${var.dns_host_names}"

  tags {
    Name = "common_tools_vpc"
  }
}

resource "aws_network_acl" "common_tools_public_nacl" {
  vpc_id     = "${aws_vpc.common_tools_vpc.id}"
  subnet_ids = ["${aws_subnet.bastion_subnet.id}"]

  # allow port 22
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.ingress_home_cidr}"
    from_port  = 22
    to_port    = 22
  }

  # allow port 22
  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "178.143.34.185/32"
    from_port  = 22
    to_port    = 22
  }

  # allow ingress ephemeral ports 
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "${var.whitelist_world}"
    from_port  = 1024
    to_port    = 65535
  }

  # allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "${var.whitelist_world}"
    from_port  = 0
    to_port    = 65535
  }

  tags {
    Name = "common_tools_public_nacl"
  }
}

resource "aws_internet_gateway" "common_tools_igw" {
  vpc_id = "${aws_vpc.common_tools_vpc.id}"

  tags {
    Name = "common_tools_igw"
  }
}

resource "aws_route_table" "common_tools_public_route" {
  vpc_id = "${aws_vpc.common_tools_vpc.id}"

  tags {
    Name = "common_tools_public_route"
  }
}

resource "aws_route" "common_tools_internet_access" {
  route_table_id         = "${aws_route_table.common_tools_public_route.id}"
  destination_cidr_block = "${var.whitelist_world}"
  gateway_id             = "${aws_internet_gateway.common_tools_igw.id}"
}

resource "aws_eip" "common_tools_nat" {
  vpc = true
}

resource "aws_nat_gateway" "common_tools_nat_gw" {
  allocation_id = "${aws_eip.common_tools_nat.id}"
  subnet_id     = "${aws_subnet.jenkins_subnet.id}"
  depends_on    = ["aws_internet_gateway.common_tools_igw"]
}

resource "aws_route_table" "common_tools_private_route" {
  vpc_id = "${aws_vpc.common_tools_vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.common_tools_nat_gw.id}"
  }

  tags {
    Name = "common_tools_nat_gw"
  }
}
