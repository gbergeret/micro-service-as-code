variable "name_prefix" {
  default = "tf-"
}

variable "vpc_id" {}

variable "subnets" {
  type = "list"
}

variable "additional_security_groups" {
  type    = "list"
  default = []
}
