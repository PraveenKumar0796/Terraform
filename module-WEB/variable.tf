variable "region" {
  default = "us-east-1a"
}

variable "VPC-cidr" {
  default = "10.0.0.0/16"
}

variable "sub1-cidr" {
  default = "10.0.0.0/24"
}

variable "sub2-cidr" {
  default = "10.0.1.0/24"
}

variable "sub1-availability_zone" {
  default = "us-east-1a"
}

variable "sub2-availability_zone" {
  default = "us-east-1b"
}

variable "ami" {
  default = "ami-04b70fa74e45c3917"
}

variable "instance-type" {
  default = "t2.micro"
}

variable "userdata-1" {
  default = "./module-WEB/userdata1.sh"
}

variable "userdata-2" {
  default = "./module-WEB/userdata2.sh"
}

variable "webser1" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "WEB-server-1"
}

variable "webser2" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "WEB-server-2"
}

variable "LB-name" {
  default = "MyALB"
}

variable "LB-type" {
  default = "application"
}
