variable "aws_region" {
  default = "us-east-2"
  type    = string
}

variable "ami" {
  default = "ami-04581fbf744a7d11f"
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
  default = "jenkins-s3-bucket-ae-2023"
  type    = string
}

variable "acl" {
  default = "private"
  type    = string
}
