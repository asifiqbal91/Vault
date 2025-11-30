locals {
  detected_project_root = abspath("${path.module}/../../..")
  project_root          = var.project_root != null ? abspath(var.project_root) : local.detected_project_root
  storage_path          = var.storage_path

  config_dir      = "${local.storage_path}/config"
  logs_dir        = "${local.storage_path}/logs"
  letsencrypt_dir = "${local.storage_path}/letsencrypt"
  container_labels = {
    "traefik.enable"                                = "true"
    "traefik.http.routers.traefik.rule"             = "Host(`${var.hostname}`)"
    "traefik.http.routers.traefik.tls.certresolver" = "localResolver"
    "traefik.http.routers.traefik.service"          = "api@internal"
    "traefik.http.routers.traefik.middlewares"      = "auth"
    "traefik.http.middlewares.auth.basicauth.users" = var.traefik_credential
    "prometheus.scrape"                             = "true"
    "prometheus.port"                               = "8080"
    "prometheus.path"                               = "/metrics"
    "prometheus.job"                                = "traefik"
  }
}

resource "docker_image" "traefik" {
  name = "kitchen/traefik:latest"

  build {
    context    = path.module
    dockerfile = "${path.module}/Dockerfile"
  }
}

resource "null_resource" "ensure_directories" {
  triggers = {
    logs_dir        = "${local.logs_dir}/traefik"
    letsencrypt_dir = local.letsencrypt_dir
  }

  provisioner "local-exec" {
    command = "mkdir -p ${self.triggers.logs_dir} ${self.triggers.letsencrypt_dir}"
  }
}

resource "docker_container" "traefik" {
  name    = "traefik"
  image   = docker_image.traefik.image_id
  restart = "always"

  env = [
    "CF_API_EMAIL=${var.cf_api_email}",
    "CF_DNS_API_TOKEN=${var.cf_dns_api_token}"
  ]

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
    target = "/letsencrypt"
    source = local.letsencrypt_dir
    type   = "bind"
  }

  mounts {
    target    = "/etc/traefik/traefik.yml"
    source    = "${local.config_dir}/traefik/traefik.yml"
    type      = "bind"
    read_only = true
  }

  mounts {
    target    = "/etc/traefik/dynamic.yml"
    source    = "${local.config_dir}/traefik/dynamic.yml"
    type      = "bind"
    read_only = true
  }

  mounts {
    target = "/logs"
    source = "${local.logs_dir}/traefik"
    type   = "bind"
  }

  ports {
    internal = 80
    external = 80
    protocol = "tcp"
  }

  ports {
    internal = 443
    external = 443
    protocol = "tcp"
  }

  ports {
    internal = 8080
    external = 8080
    protocol = "tcp"
  }

  networks_advanced {
    name = var.public_network_name
  }

  depends_on = [null_resource.ensure_directories]
}
