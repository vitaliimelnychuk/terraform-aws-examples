[
    {
      "name": "${name}",
      "image": "traefik:v2.3.0-rc2",
      "entryPoint": ["traefik", "--providers.ecs.clusters", "${ecs_cluster_name}", "--log.level", "DEBUG", "--providers.ecs.region", "${region}", "--api.insecure"],
      "essential": true,
      "logConfiguration":{
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${loggroup}",
            "awslogs-region": "${region}",
            "awslogs-stream-prefix": "${name}"
        }
      },
      "Environment" : [{
        "name": "AWS_ACCESS_KEY_ID",
        "value": "${aws_access_key}"
      }],
      "Secrets" :[{
        "name": "AWS_SECRET_ACCESS_KEY",
        "valuefrom": "${secret_arn}"
      }],
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        },
        {
          "containerPort": 8080,
          "hostPort": 8080
        }
      ]
    }
  ]
