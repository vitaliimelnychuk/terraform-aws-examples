resource "aws_ecs_cluster" "main" {
  name = "${var.env}-${var.resources_prefix}-cluster"

  tags = {
    ENV = var.env
    APP = var.app
  }
}
