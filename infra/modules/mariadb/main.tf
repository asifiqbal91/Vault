locals {
  detected_project_root = abspath("${path.module}/../../..")
  project_root          = var.project_root != null ? abspath(var.project_root) : local.detected_project_root
  storage_path          = var.storage_path

  volumes_dir = "${local.storage_path}/volumes"
}

resource "docker_image" "mariadb" {
  name = "kitchen/mariadb:latest"

  build {
    context    = path.module
    dockerfile = "${path.module}/Dockerfile"
  }
}

resource "null_resource" "ensure_volume_dir" {
  triggers = {
    path = "${local.volumes_dir}/mariadb"
  }

  provisioner "local-exec" {
    command = "mkdir -p ${self.triggers.path}"
  }
}

resource "docker_container" "mariadb" {
  name    = "mariadb"
  image   = docker_image.mariadb.image_id
  restart = "always"

  env = [
    "MYSQL_TCP_PORT=${var.port}",
    "MARIADB_ROOT_PASSWORD=${var.root_password}"
  ]

  mounts {
    target = "/var/lib/mysql"
    source = "${local.volumes_dir}/mariadb"
    type   = "bind"
  }

  ports {
    internal = 3306
    external = var.port
    protocol = "tcp"
  }

  networks_advanced {
    name = var.kitchen_network_name
  }

  depends_on = [null_resource.ensure_volume_dir]
}
