locals {
  detected_project_root = abspath("${path.module}/../../..")
  project_root          = var.project_root != null ? abspath(var.project_root) : local.detected_project_root
  storage_root          = abspath(var.storage_root)

  volumes_dir = "${local.storage_root}/volumes"
  container_labels = {
    "traefik.enable"                                   = "true"
    "traefik.http.routers.vault.rule"                  = "Host(`${var.hostname}`)"
    "traefik.http.routers.vault.entrypoints"           = "websecure"
    "traefik.http.routers.vault.tls.certresolver"      = "cloudflare"
  }
}

resource "docker_image" "vault" {
  name = "kitchen/vault:latest"

  build {
    context    = path.module
    dockerfile = "${path.module}/Dockerfile"
  }
}

resource "null_resource" "ensure_volume_dir" {
  triggers = {
    path = "${local.volumes_dir}"
  }

  provisioner "local-exec" {
    command = "mkdir -p ${self.triggers.path}"
  }
}

resource "docker_container" "vault" {
  name    = "vault"
  image   = docker_image.vault.image_id
  restart = "always"

  env = [
    "ADMIN_TOKEN=${var.admin_token}",
    "DATABASE_URL=${var.database_url}"
  ]

  mounts {
    target = "/data"
    source = "${local.volumes_dir}"
    type   = "bind"
  }

  dynamic "labels" {
    for_each = local.container_labels

    content {
      label = labels.key
      value = labels.value
    }
  }

  networks_advanced {
    name = var.public_network_name
  }

  networks_advanced {
    name = var.kitchen_network_name
  }

  depends_on = [null_resource.ensure_volume_dir]
}
