locals {
  detected_project_root = abspath("${path.module}/../../..")
  project_root          = var.project_root != null ? abspath(var.project_root) : local.detected_project_root
  storage_path          = var.storage_path

  config_dir  = "${local.storage_path}/config"
  volumes_dir = "${local.storage_path}/volumes"
  container_labels = {
    "traefik.enable"                                = "true"
    "traefik.http.routers.grafana.rule"             = "Host(`${var.hostname}`)"
    "traefik.http.routers.grafana.tls.certresolver" = "localResolver"
  }
}

resource "docker_image" "grafana" {
  name = "kitchen/grafana:latest"

  build {
    context    = path.module
    dockerfile = "${path.module}/Dockerfile"
  }
}

resource "null_resource" "ensure_directories" {
  triggers = {
    data_dir         = "${local.volumes_dir}/grafana/data"
    logs_dir         = "${local.volumes_dir}/grafana/logs"
    provisioning_dir = "${local.volumes_dir}/grafana/provisioning"
  }

  provisioner "local-exec" {
    command = "mkdir -p ${self.triggers.data_dir} ${self.triggers.logs_dir} ${self.triggers.provisioning_dir}"
  }
}

resource "docker_container" "grafana" {
  name    = "grafana"
  image   = docker_image.grafana.image_id
  restart = "always"
  user    = "0:0"

  env = [
    "GF_SECURITY_ADMIN_USER=${var.user}",
    "GF_SECURITY_ADMIN_PASSWORD=${var.password}"
  ]

  dynamic "labels" {
    for_each = local.container_labels

    content {
      label = labels.key
      value = labels.value
    }
  }

  mounts {
    target    = "/etc/grafana/grafana.ini"
    source    = "${local.config_dir}/grafana/grafana.ini"
    type      = "bind"
    read_only = true
  }

  mounts {
    target = "/var/lib/grafana"
    source = "${local.volumes_dir}/grafana/data"
    type   = "bind"
  }

  mounts {
    target = "/var/log/grafana"
    source = "${local.volumes_dir}/grafana/logs"
    type   = "bind"
  }

  mounts {
    target = "/etc/grafana/provisioning"
    source = "${local.volumes_dir}/grafana/provisioning"
    type   = "bind"
  }

  networks_advanced {
    name = var.public_network_name
  }

  depends_on = [null_resource.ensure_directories]
}
