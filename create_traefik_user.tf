terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 0.14.4"
}

provider "aws" {
  profile = ""
  region  = "us-east-1"
}

locals {
  app = ""
}

resource "aws_iam_user" "traefik" {
  name = "traefik"
}

resource "aws_iam_access_key" "traefik" {
  user = aws_iam_user.traefik.name
}

data "aws_iam_policy_document" "traefik_user" {
  statement {
    sid = "main"

    actions = [
      "ecs:ListClusters",
      "ecs:DescribeClusters",
      "ecs:ListTasks",
      "ecs:DescribeTasks",
      "ecs:DescribeContainerInstances",
      "ecs:DescribeTaskDefinition",
      "ec2:DescribeInstances"
    ]

    resources = [
      "*",
    ]
  }
}

# Traefik user
resource "aws_iam_user_policy" "traefik_user" {
  name   = "${local.app}_traefik_user"
  user   = aws_iam_user.traefik.name
  policy = data.aws_iam_policy_document.traefik_user.json
}

/*Store access keys in Secret manager to retrieve it with Fargate*/
resource "aws_secretsmanager_secret" "traefik_secret_access_key" {
  name        = "${local.app}_traefik_secret_access_key_value"
  description = "contains traefik secret access key"
}

resource "aws_secretsmanager_secret_version" "key" {
  secret_id     = aws_secretsmanager_secret.traefik_secret_access_key.id
  secret_string = aws_iam_access_key.traefik.secret
}


output "traefik_access_key" {
  value = aws_iam_access_key.traefik.id
}

output "traefik_secret_access_key_id" {
  value = aws_secretsmanager_secret.traefik_secret_access_key.id
}
