[
    {
      "name": "${name}",
      "image": "containous/whoami:v1.5.0",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ],
      "dockerLabels": 
        {
          "traefik.http.routers.${name}.rule": "PathPrefix(`${path_prefix}`)",
          "traefik.enable": "true"
        }
      
    }
]
