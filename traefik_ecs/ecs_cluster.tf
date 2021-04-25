resource "aws_ecs_cluster" "traefik" {
  name               = join("-", [var.namespace, "demo"])
  capacity_providers = ["FARGATE_SPOT"]
}