job "podshift-example" {
  datacenters = ["dc1"]
  type        = "service"

  group "web" {
    network {
      port "http" {
        to     = 80
        static = 8080
      }
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "nginx:1.27-alpine"
        ports = ["http"]

        volumes = [
          "${NOMAD_TASK_DIR}/local/default.conf:/etc/nginx/conf.d/default.conf:ro",
          "${NOMAD_TASK_DIR}/local/site:/usr/share/nginx/html:ro",
        ]
      }

      template {
        destination = "local/default.conf"
        data        = <<EOF
server {
  listen 80;
  server_name _;
  root /usr/share/nginx/html;

  location / {
    try_files $uri $uri/ =404;
  }

  location /healthz {
    return 200 "ok\n";
    add_header Content-Type text/plain;
  }
}
EOF
      }

      template {
        destination = "local/site/index.html"
        data        = <<EOF
<!doctype html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Podshift Demo</title>
  </head>
  <body>
    <h1>It works ✅</h1>
    <p>Docker Compose → Podman Compose → Nomad</p>
  </body>
</html>
EOF
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}
