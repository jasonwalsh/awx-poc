provider "aws" {}

// Query for the most recent ECS-Optimized Amazon Linux AMI.
data "aws_ami" "ami" {
  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  most_recent = true

  owners = ["591542846629"]
}

data "aws_availability_zones" "available" {}

data "aws_iam_policy" "iam_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

data "aws_subnet_ids" "subnet_ids" {
  vpc_id = "${data.aws_vpc.vpc.id}"
}

data "aws_vpc" "vpc" {
  default = true
}

data "template_file" "file" {
  template = "${file("${path.module}/templates/ecs.config")}"

  vars {
    ecs_cluster = "${random_pet.pet.id}"
  }
}

data "template_cloudinit_config" "cloudinit_config" {
  part {
    content = "${data.template_file.file.rendered}"
  }
}

resource "aws_autoscaling_group" "autoscaling_group" {
  availability_zones = [
    "${data.aws_availability_zones.available.names}",
  ]

  desired_capacity     = "${var.desired_capacity}"
  launch_configuration = "${aws_launch_configuration.launch_configuration.name}"
  max_size             = "${var.max_size}"
  min_size             = "${var.min_size}"

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "${random_pet.pet.id}"
  }
}

resource "aws_ecr_repository" "ecr_repository" {
  name = "${random_pet.pet.id}"
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${random_pet.pet.id}"
}

resource "aws_ecs_service" "awx_web" {
  cluster       = "${aws_ecs_cluster.ecs_cluster.id}"
  desired_count = "${var.desired_capacity}"
  launch_type   = "EC2"

  load_balancer {
    container_name   = "awx_web"
    container_port   = 8080
    target_group_arn = "${aws_lb_target_group.lb_target_group.arn}"
  }

  name                = "awx_web"
  scheduling_strategy = "REPLICA"
  task_definition     = "${aws_ecs_task_definition.ecs_task_definition.arn}"
}

resource "aws_ecs_task_definition" "ecs_task_definition" {
  container_definitions = "${file("${path.module}/templates/definitions.json")}"
  family                = "${random_pet.pet.id}"
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
  role = "${aws_iam_role.iam_role.name}"
}

resource "aws_iam_role" "iam_role" {
  assume_role_policy = <<EOF
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Sid": ""
    }
  ],
  "Version": "2008-10-17"
}
EOF
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment" {
  policy_arn = "${data.aws_iam_policy.iam_policy.arn}"
  role       = "${aws_iam_role.iam_role.name}"
}

resource "aws_key_pair" "key_pair" {
  public_key = "${file("${pathexpand("~/.ssh/id_rsa.pub")}")}"
}

resource "aws_launch_configuration" "launch_configuration" {
  iam_instance_profile = "${aws_iam_instance_profile.iam_instance_profile.name}"
  image_id             = "${data.aws_ami.ami.id}"
  instance_type        = "${var.instance_type}"
  key_name             = "${aws_key_pair.key_pair.key_name}"

  security_groups = [
    "${aws_security_group.launch_configuration.id}",
  ]

  user_data = "${data.template_cloudinit_config.cloudinit_config.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "lb" {
  internal           = false
  load_balancer_type = "application"
  name               = "${random_pet.pet.id}"

  security_groups = [
    "${aws_security_group.security_group.id}",
  ]

  subnets = [
    "${data.aws_subnet_ids.subnet_ids.ids}",
  ]
}

resource "aws_lb_listener" "lb_listener" {
  default_action {
    target_group_arn = "${aws_lb_target_group.lb_target_group.arn}"
    type             = "forward"
  }

  load_balancer_arn = "${aws_lb.lb.arn}"
  port              = 80
  protocol          = "HTTP"
}

resource "aws_lb_target_group" "lb_target_group" {
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "${data.aws_vpc.vpc.id}"

  depends_on = ["aws_lb.lb"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "launch_configuration" {
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
  }
}

resource "aws_security_group" "security_group" {
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 8080
    protocol    = "TCP"
    to_port     = 8080
  }
}

resource "random_pet" "pet" {}
