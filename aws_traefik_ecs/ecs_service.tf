# Traefik service
resource "aws_ecs_service" "traefik" {
  depends_on = [
    aws_alb_target_group.traefik,
    aws_alb_target_group.traefik_api
  ]

  name            = "${var.env}-${var.resources_prefix}-traefik"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.traefik.arn
  desired_count   = 1
  launch_type     = "FARGATE"


  load_balancer {
    target_group_arn = aws_alb_target_group.traefik_api.arn
    container_name   = "${var.env}-${var.resources_prefix}-traefik"
    container_port   = 8080
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.traefik.arn
    container_name   = "${var.env}-${var.resources_prefix}-traefik"
    container_port   = 80
  }

  network_configuration {
    subnets          = var.aws_subnet_public.*.id
    security_groups  = [aws_security_group.traefik_ecs.id]
    assign_public_ip = true
  }

  tags = {
    ENV = var.env
    APP = var.app
  }
}

resource "aws_cloudwatch_log_group" "traefik" {
  name              = "${var.env}-${var.resources_prefix}-traefik"
  retention_in_days = 1

  tags = {
    ENV = var.env
    APP = var.app
  }
}

# Applications
resource "aws_ecs_service" "app" {
  count           = length(var.ecs_services)
  name            = "${var.env}-${var.resources_prefix}-${var.ecs_services[count.index].service_name}"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app[count.index].arn
  desired_count   = var.ecs_services[count.index].app_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.aws_subnet_public.*.id
    security_groups  = [aws_security_group.whoami.id]
    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      task_definition,
    ]
  }

  tags = {
    ENV = var.env
    APP = var.app
  }
}


resource "aws_cloudwatch_log_group" "app" {
  count             = length(var.ecs_services)
  name              = "${var.env}-${var.resources_prefix}-${var.ecs_services[count.index].service_name}"
  retention_in_days = 30

  tags = {
    ENV = var.env
    APP = var.app
  }
}
