resource "aws_launch_template" "template" {
  block_device_mappings   = []
  disable_api_termination = "${var.disable_api_termination}"
  ebs_optimized           = "${var.ebs_optimized}"
  image_id                = "${var.image_id}"
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity = "${var.desired_capacity}"

  launch_template {
    id = "${aws_launch_template.template.id}"
  }

  max_size = "${var.max_size}"
  min_size = "${var.min_size}"
  tags     = {}
}
