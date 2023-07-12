variable "aws_region" {
  default = "us-east-2"
  type    = string
}

variable "ami" {
  default = "ami-069d73f3235b535bd"
  type    = string
}

variable "instance_type" {
  default = "t2.micro"
  type    = string
}

variable "key_name" {
  default = "tf-jenkins-aws-service"
  type    = string
}

variable "associate_public_ip_address" {
  default = "true"
  type    = bool
}

variable "jenkins-tag-name" {
  default = "Jenkins-Server"
  type    = string
}

variable "bucket" {
  default = "application-readwright-s3bucket"
  type    = string
}

variable "acl" {
  default = "private"
  type    = string
}
