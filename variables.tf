variable "region" {
  default = "eu-west-1"
}

variable "default_az" {
  default = "eu-west-1c"
}

variable "instance_tenancy" {
  default = "default"
}

variable "dns_support" {
  default = true
}

variable "dns_host_names" {
  default = true
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "bastion_subnet_cidr" {
  default = "10.0.10.0/24"
}

variable "jenkins_subnet_cidr" {
  default = "10.0.30.0/24"
}

variable "ingress_home_cidr" {
  default = "95.102.143.251/32"
}

variable "ingress_cidr_list" {
  type    = "list"
  default = ["95.102.143.251/32", "178.143.34.185/32"]
}

variable "whitelist_world" {
  default = "0.0.0.0/0"
}

variable "egress_cidr_list" {
  type    = "list"
  default = ["0.0.0.0/0"]
}

variable "enable_public_ip" {
  default = true
}

variable "ami_id" {
  default = "ami-08935252a36e25f85"
}

variable "ami_size" {
  default = "t2.micro"
}
