data "aws_region" "current" {}

resource "aws_ecs_task_definition" "traefik" {
  family = "traefik"
  container_definitions = templatefile("${path.module}/task-definitions/traefik.json.tpl", {
    aws_access_key   = var.traefik_access_key
    loggroup         = aws_cloudwatch_log_group.traefik.name
    region           = data.aws_region.current.name
    ecs_cluster_name = aws_ecs_cluster.main.name
    secret_arn       = var.traefik_secret_access_key_id
  })
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_role.arn
  task_role_arn            = aws_iam_role.traefik.arn
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  tags = {
    ENV = var.env
    APP = var.app
  }
}

# Applications
resource "aws_ecs_task_definition" "app" {
  count  = length(var.ecs_services)
  family = "${var.env}-${var.resources_prefix}-${var.ecs_services[count.index].service_name}"
  container_definitions = templatefile("${path.module}/task-definitions/whoami.json.tpl", {
    name        = "${var.env}-${var.resources_prefix}-${var.ecs_services[count.index].service_name}"
    host        = var.root_domain_name
    path_prefix = "/${var.ecs_services[count.index].service_name}"
  })
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  tags = {
    ENV = var.env
    APP = var.app
  }
}
