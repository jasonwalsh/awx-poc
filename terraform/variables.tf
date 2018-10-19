variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
}

variable "image_id" {
  description = "The AMI from which to launch the instance"
}

variable "max_size" {
  description = "The maximum size of the auto scale group"
}

variable "min_size" {
  description = "The minimum size of the auto scale group"
}
