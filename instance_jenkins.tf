resource "aws_subnet" "jenkins_subnet" {
  vpc_id                  = "${aws_vpc.common_tools_vpc.id}"
  cidr_block              = "${var.jenkins_subnet_cidr}"
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-west-1a"

  tags = {
    Name = "jenkins_subnet"
  }
}

resource "aws_security_group" "jenkins_security_group" {
  vpc_id      = "${aws_vpc.common_tools_vpc.id}"
  name        = "jenkins_security_group"
  description = "jenkins_security_group"

  ingress {
    security_groups = ["${aws_security_group.bastion_security_group.id}"]
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
  }

  ingress {
    cidr_blocks = "${var.ingress_cidr_list}"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = "${var.egress_cidr_list}"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
  }

  tags = {
    Name = "jenkins_security_group"
  }
}

resource "aws_instance" "jenkins" {
  ami                    = "${var.ami_id}"
  instance_type          = "${var.ami_size}"
  vpc_security_group_ids = ["${aws_security_group.jenkins_security_group.id}"]
  subnet_id              = "${aws_subnet.jenkins_subnet.id}"
  key_name               = "common_tools_instances"

  tags = {
    Name = "jenkins"
  }
}

resource "aws_route_table_association" "jenkins_route_table_association" {
  subnet_id      = "${aws_subnet.jenkins_subnet.id}"
  route_table_id = "${aws_route_table.common_tools_public_route.id}"
}
