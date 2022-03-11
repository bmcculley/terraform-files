terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.13.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_volume" "db_data" {}

resource "docker_network" "wpsite" {
  name = "wpsite"
}

resource "docker_container" "db" {
  name         = "db"
  image        = "mariadb:latest"
  restart      = "always"
  network_mode = "wpsite"
  env = [
    "MARIADB_ROOT_PASSWORD=${var.mariadb_root_password}",
    "MARIADB_DATABASE=wordpress",
    "MARIADB_USER=${var.mariadb_user}",
    "MARIADB_PASSWORD=${var.mariadb_password}"
  ]
  mounts {
    type   = "volume"
    target = "/var/lib/mysql"
    source = "db_data"
  }
}

resource "docker_container" "wordpress" {
  name         = "wordpress-dev-env"
  image        = "wordpress:latest"
  restart      = "always"
  network_mode = "wpsite"
  ports {
    internal = "80"
    external = var.wordpress_port
  }
  volumes {
    container_path = "/var/www/html"
    host_path      = var.wordpress_host_path
  }
  env = [
    "WORDPRESS_DB_HOST=db:3306",
    "WORDPRESS_DB_USER=${var.mariadb_user}",
    "WORDPRESS_DB_PASSWORD=${var.mariadb_password}"
  ]
  depends_on = [
    docker_container.db
  ]
}

resource "docker_container" "coder" {
  image      = "codercom/code-server:latest"
  name       = "coder-wordpress-devlopment"
  entrypoint = ["/usr/bin/entrypoint.sh", "--bind-addr", "0.0.0.0:8080", ".", "--auth", "none", "--disable-telemetry", "--disable-update-check"]
  env        = ["DOCKER_USER", "${var.docker_user}"]
  ports {
    internal = 8080
    external = 32880
  }
  user = "1000:1000"
  volumes {
    container_path = "/home/coder/project"
    host_path      = var.wordpress_host_path
  }
  volumes {
    container_path = "/home/coder/code-server/.config"
    host_path      = "/home/bmcculley/coder/.config"
  }
}
