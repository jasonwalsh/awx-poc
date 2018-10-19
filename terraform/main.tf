provider "aws" {}

module "asg" {
  source = "modules/asg"

  desired_capacity = "${var.desired_capacity}"
  image_id         = "${var.image_id}"
  max_size         = "${var.max_size}"
  min_size         = "${var.min_size}"
}
