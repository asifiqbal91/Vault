locals {
  detected_project_root = abspath("${path.module}/../../..")
  project_root          = var.project_root != null ? abspath(var.project_root) : local.detected_project_root
  storage_path          = var.storage_path

  volumes_dir = "${local.storage_path}/volumes"
}

resource "docker_image" "postgres" {
  name = "kitchen/postgres:latest"

  build {
    context    = path.module
    dockerfile = "${path.module}/Dockerfile"
  }
}

resource "null_resource" "ensure_volume_dir" {
  triggers = {
    path = "${local.volumes_dir}/postgres"
  }

  provisioner "local-exec" {
    command = "mkdir -p ${self.triggers.path}"
  }
}

resource "docker_container" "postgres" {
  name     = "postgres"
  image    = docker_image.postgres.image_id
  restart  = "always"
  shm_size = 134217728

  env = [
    "POSTGRES_USER=${var.user}",
    "POSTGRES_PASSWORD=${var.password}"
  ]

  mounts {
    target = "/var/lib/postgresql/data"
    source = "${local.volumes_dir}/postgres"
    type   = "bind"
  }

  networks_advanced {
    name = var.public_network_name
  }

  depends_on = [null_resource.ensure_volume_dir]
}
