variable "region" {
  type    = string
  default = "ca-central-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.50.0.0/16"
}

variable "subnet1_cidr" {
  type    = string
  default = "10.50.1.0/24"
}

variable "subnet2_cidr" {
  type    = string
  default = "10.50.2.0/24"
}

variable "subnet3_cidr" {
  type    = string
  default = "10.50.3.0/24"
}

variable "subnet4_cidr" {
  type    = string
  default = "10.50.4.0/24"
}

variable "az1" {
  type    = string
  default = "ca-central-1a"
}

variable "az2" {
  type    = string
  default = "ca-central-1b"
}

variable "ec2_ami" {
  type    = string
  default = "ami-0d1e3f2707b2b8925"
}

variable "ec2_instance_type" {
  type    = string
  default = "t2.micro"
}



