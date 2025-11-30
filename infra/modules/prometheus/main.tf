locals {
  detected_project_root = abspath("${path.module}/../../..")
  project_root          = var.project_root != null ? abspath(var.project_root) : local.detected_project_root
  storage_path          = var.storage_path

  config_dir = "${local.storage_path}/config"
  container_labels = {
    "traefik.enable"                                   = "true"
    "traefik.http.routers.prometheus.rule"             = "Host(`${var.hostname}`)"
    "traefik.http.routers.prometheus.tls.certresolver" = "localResolver"
    "prometheus.scrape"                                = "true"
    "prometheus.port"                                  = "9090"
    "prometheus.path"                                  = "/metrics"
    "prometheus.job"                                   = "prometheus"
  }
}

resource "docker_image" "prometheus" {
  name = "kitchen/prometheus:latest"

  build {
    context    = path.module
    dockerfile = "${path.module}/Dockerfile"
  }
}

resource "docker_container" "prometheus" {
  name    = "prometheus"
  image   = docker_image.prometheus.image_id
  restart = "always"
  user    = "0:0"

  dynamic "labels" {
    for_each = local.container_labels

    content {
      label = labels.key
      value = labels.value
    }
  }

  mounts {
    target    = "/var/run/docker.sock"
    source    = var.docker_socket_path
    type      = "bind"
    read_only = true
  }

  mounts {
    target    = "/etc/prometheus/prometheus.yml"
    source    = "${local.config_dir}/prometheus/prometheus.yml"
    type      = "bind"
    read_only = true
  }

  networks_advanced {
    name = var.public_network_name
  }
}
