resource "aws_security_group" "traefik" {
  name        = "traefik-front"
  description = "Allow http and https traffic from Internet"
  vpc_id      = var.aws_vpc.id

  ingress {
    description = "Non secured"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Secured"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Non secured"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "traefik_ecs" {
  name        = "traefik-ecs"
  description = "Allow http and https traffic from ALB"
  vpc_id      = var.aws_vpc.id

  ingress {
    description     = "Non secured"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.traefik.id]
  }

  ingress {
    description     = "Secured"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.traefik.id]
  }

  ingress {
    description     = "Non secured"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.traefik.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "whoami" {
  name        = "whoami"
  description = "Allow traffic from Traefik"
  vpc_id      = var.aws_vpc.id

  ingress {
    description     = "Non secured"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.traefik_ecs.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
