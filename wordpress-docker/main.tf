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
  name         = "wordpress"
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