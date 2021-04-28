resource "aws_alb" "traefik" {
  name               = "${var.env}-${var.resources_prefix}-traefik-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.traefik.id]
  subnets            = var.aws_subnet_public.*.id

  tags = {
    ENV = var.env
    APP = var.app
  }
}

resource "aws_alb_target_group" "traefik_api" {
  name        = "${var.env}-${var.resources_prefix}-traefikapi-tg"
  target_type = "ip"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.aws_vpc.id
  health_check {
    path    = "/"
    matcher = "200-202,300-302"
  }

  tags = {
    ENV = var.env
    APP = var.app
  }
}


resource "aws_alb_target_group" "traefik" {
  name        = "${var.env}-${var.resources_prefix}-traefik-tg"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.aws_vpc.id
  health_check {
    path    = "/"
    matcher = "200-202,404"
  }

  tags = {
    ENV = var.env
    APP = var.app
  }
}

resource "aws_alb_listener" "http_https_redirect" {
  load_balancer_arn = aws_alb.traefik.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    order = 1
    type  = "redirect"
    redirect {
      host        = "#{host}"
      path        = "/#{path}"
      port        = "443"
      protocol    = "HTTPS"
      query       = "#{query}"
      status_code = "HTTP_301"
    }
  }

}

resource "aws_alb_listener" "front" {
  load_balancer_arn = aws_alb.traefik.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.certificate.arn

  default_action {
    target_group_arn = aws_alb_target_group.traefik.arn
    type             = "forward"
  }

}


resource "aws_alb_listener" "front_api" {
  load_balancer_arn = aws_alb.traefik.arn
  port              = "8080"
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.traefik_api.arn
  }
}


resource "aws_route53_record" "alias_route53_record" {
  zone_id = var.route53_hosting_zone_id
  name    = var.root_domain_name
  type    = "A"

  alias {
    name                   = aws_alb.traefik.dns_name
    zone_id                = aws_alb.traefik.zone_id
    evaluate_target_health = true
  }
  depends_on = [
    aws_alb.traefik,
  ]
}
