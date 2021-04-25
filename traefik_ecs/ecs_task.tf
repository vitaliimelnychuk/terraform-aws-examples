data "aws_region" "current" {}

resource "aws_ecs_task_definition" "traefik" {
  family = "traefik"
  container_definitions = templatefile("task-definitions/traefik.json.tpl", {
    aws_access_key   = var.access_key
    loggroup         = aws_cloudwatch_log_group.traefik.name
    region           = data.aws_region.current.name
    ecs_cluster_name = aws_ecs_cluster.traefik.name
    secret_arn       = var.secret_access_key_id
  })
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_role.arn
  task_role_arn            = aws_iam_role.traefik.arn
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
}

resource "aws_ecs_task_definition" "whoami" {
  family = "whoami"
  container_definitions = templatefile("task-definitions/whoami.json.tpl", {
    alb_endpoint = aws_lb.traefik.dns_name
  })
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
}