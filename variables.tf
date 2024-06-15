variable "region_name" {
  type    = string
  default = "us-east-1"
}

variable "sg_name" {
  type    = string
  default = "Apache SG"
}

variable "vpc_id" {
  type    = string
  default = "vpc-00bdbfa80f37bd0fe"
}

variable "ssh_desc" {
  type    = string
  default = "SSH"
}

variable "http_desc" {
  type    = string
  default = "HTTP"
}

variable "ssh_port" {
  type    = number
  default = 22
}

variable "http_port" {
  type    = number
  default = 80
}

variable "outbound_port" {
  type    = number
  default = 0
}

variable "protocol_tcp" {
  type    = string
  default = "tcp"
}

variable "protocol_outbound" {
  type    = string
  default = "-1"
}

variable "cidr_block" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "sg_tag" {
  type    = string
  default = "TF_SG"
}

variable "bucket_name" {
  type    = string
  default = "my-tf-jenkins-bucket-may-2024-i382k4m2l"
}

variable "bucket_tag" {
  type    = string
  default = "Jenkins Buckets"
}

variable "ami_id" {
  type    = string
  default = "ami-00beae93a2d981137"
}

variable "instance_type_name" {
  type    = string
  default = "t2.micro"
}

variable "instance_name_a" {
  type    = string
  default = "ApacheInstanceA"
}

variable "instance_name_b" {
  type    = string
  default = "ApacheInstanceB"
}

variable "ud_filepath" {
  type    = string
  default = "~/environment/week23-proj/user-data.sh"
}


# New variables
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}