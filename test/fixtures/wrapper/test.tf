locals {
  "name_prefix" = "test-app-module-"
}

module "vpc" {
  source = "github.com/gbergere/tf-vpc-module"

  name_prefix = "${local.name_prefix}"
}

module "app" {
  source = "../../../"

  name_prefix = "${local.name_prefix}"

  vpc_id                     = "${module.vpc.vpc_id}"
  subnets                    = ["${module.vpc.subnets["public"]}"]
  additional_security_groups = ["${module.vpc.default_security_group}"]
}

output "app_url" {
  value = "${module.app.url}"
}
