resource "aws_iam_role" "traefik" {
  name = "traefik"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "traefik_policy" {
  name = "traefik_policy"
  role = aws_iam_role.traefik.id

  policy = data.aws_iam_policy_document.traefik_policy.json
}

data "aws_iam_policy_document" "traefik_policy" {
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

resource "aws_iam_role" "ecs_role" {
  name = "ecs_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_role.name
}

resource "aws_iam_role_policy_attachment" "ecs_policy_secrets" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = aws_iam_role.ecs_role.name
}