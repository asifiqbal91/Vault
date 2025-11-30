locals {
  detected_project_root = abspath("${path.module}/../../..")
  project_root          = var.project_root != null ? abspath(var.project_root) : local.detected_project_root
  storage_path          = var.storage_path

  container_labels = {
    "traefik.enable"                                   = "true"
    "traefik.http.routers.phpmyadmin.rule"             = "Host(`${var.hostname}`)"
    "traefik.http.routers.phpmyadmin.tls.certresolver" = "localResolver"
  }
}

resource "docker_image" "phpmyadmin" {
  name = "kitchen/phpmyadmin:latest"

  build {
    context    = path.module
    dockerfile = "${path.module}/Dockerfile"
  }
}

resource "docker_container" "phpmyadmin" {
  name    = "phpmyadmin"
  image   = docker_image.phpmyadmin.image_id
  restart = "always"

  env = [
    "PMA_ARBITRARY=1"
  ]

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
}
