variable "app_version" {}

locals {
  "name_prefix" = "test-app-module-"
}

module "vpc" {
  source = "github.com/gbergere/tf-vpc-module?ref=v1.0"

  name_prefix = "${local.name_prefix}"

  price_saving_enabled = "1"
}

module "app" {
  source = "../../../terraform/"

  name_prefix = "${local.name_prefix}"

  vpc_id                     = "${module.vpc.vpc_id}"
  subnets                    = "${module.vpc.subnets}"
  additional_security_groups = ["${module.vpc.default_security_group}"]

  app_version = "${var.app_version}"
}

output "app_url" {
  value = "${module.app.url}"
}
