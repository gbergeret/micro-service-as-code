variable "name_prefix" {
  default = "tf-"
}

variable "vpc_id" {}

variable "app_version" {}

variable "subnets" {
  type = "map"
}

variable "additional_security_groups" {
  type    = "list"
  default = []
}
