variable "desired_capacity" {
  description = "The number of EC2 instances that should be running in the group"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "The instance type of the EC2 instance."
}

variable "max_size" {
  description = "The maximum size of the group."
}

variable "min_size" {
  description = "The minimum size of the group."
}
