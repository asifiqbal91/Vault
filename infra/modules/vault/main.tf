locals {
  detected_project_root = abspath("${path.module}/../../..")
  project_root          = var.project_root != null ? abspath(var.project_root) : local.detected_project_root
  storage_path          = var.storage_path

  config_dir = "${local.storage_path}/config"
  container_labels = {
    "traefik.enable"                             = "true"
    "traefik.http.routers.dash.rule"             = "Host(`${var.hostname}`)"
    "traefik.http.routers.dash.tls.certresolver" = "localResolver"
  }
}

resource "docker_image" "dash" {
  name = "kitchen/dash:latest"

  build {
    context    = path.module
    dockerfile = "${path.module}/Dockerfile"
  }
}

resource "docker_container" "dash" {
  name    = "dash"
  image   = docker_image.dash.image_id
  restart = "always"

  mounts {
    target    = "/www/assets/pages"
    source    = "${local.config_dir}/dash/pages"
    type      = "bind"
    read_only = true
  }

  mounts {
    target    = "/www/assets/icons"
    source    = "${local.config_dir}/dash/assets/icons"
    type      = "bind"
    read_only = true
  }

  mounts {
    target    = "/www/assets/config.yml"
    source    = "${local.config_dir}/dash/config.yml"
    type      = "bind"
    read_only = true
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
}
