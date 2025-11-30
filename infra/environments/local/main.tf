terraform {
  required_version = ">= 1.6.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 3.0.2"
    }
  }
}

provider "docker" {
  host = var.docker_host
}

locals {
  router_hostnames = {
    traefik    = lookup(var.router_hostnames, "traefik", "")
    phpmyadmin = lookup(var.router_hostnames, "phpmyadmin", "")
    dash       = lookup(var.router_hostnames, "dash", "")
    prometheus = lookup(var.router_hostnames, "prometheus", "")
    grafana    = lookup(var.router_hostnames, "grafana", "")
  }
}

locals {
  routed_services_enabled = {
    traefik    = length(trimspace(local.router_hostnames.traefik)) > 0
    phpmyadmin = length(trimspace(local.router_hostnames.phpmyadmin)) > 0
    dash       = length(trimspace(local.router_hostnames.dash)) > 0
    prometheus = length(trimspace(local.router_hostnames.prometheus)) > 0
    grafana    = length(trimspace(local.router_hostnames.grafana)) > 0
  }
}

# Networks
module "networks" {
  source = "../../modules/networks"
}

# Traefik (must be deployed first)
module "traefik" {
  count  = local.routed_services_enabled.traefik ? 1 : 0
  source = "../../modules/traefik"

  project_root        = var.project_root
  storage_path        = var.storage_path
  docker_socket_path  = var.docker_socket_path
  public_network_name = module.networks.public_network_name

  cf_api_email       = var.cf_api_email
  cf_dns_api_token   = var.cf_dns_api_token
  traefik_credential = var.traefik_credential
  hostname           = local.router_hostnames.traefik
}

# MariaDB
module "mariadb" {
  count  = var.enable_mariadb ? 1 : 0
  source = "../../modules/mariadb"

  project_root         = var.project_root
  storage_path         = var.storage_path
  kitchen_network_name = module.networks.kitchen_network_name

  port          = var.mariadb_port
  root_password = var.mariadb_root_password
}

# phpMyAdmin (depends on traefik and mariadb)
module "phpmyadmin" {
  count  = local.routed_services_enabled.phpmyadmin && local.routed_services_enabled.traefik && var.enable_mariadb ? 1 : 0
  source = "../../modules/phpmyadmin"

  project_root         = var.project_root
  storage_path         = var.storage_path
  public_network_name  = module.networks.public_network_name
  kitchen_network_name = module.networks.kitchen_network_name
  hostname             = local.router_hostnames.phpmyadmin

  depends_on = [
    module.traefik,
    module.mariadb
  ]
}

# Postgres
module "postgres" {
  count  = var.enable_postgres ? 1 : 0
  source = "../../modules/postgres"

  project_root        = var.project_root
  storage_path        = var.storage_path
  public_network_name = module.networks.public_network_name

  user     = var.postgres_user
  password = var.postgres_password
}

# Dash (depends on traefik)
module "dash" {
  count  = local.routed_services_enabled.dash && local.routed_services_enabled.traefik ? 1 : 0
  source = "../../modules/dash"

  project_root        = var.project_root
  storage_path        = var.storage_path
  public_network_name = module.networks.public_network_name
  hostname            = local.router_hostnames.dash

  depends_on = [module.traefik]
}

# Prometheus (depends on traefik)
module "prometheus" {
  count  = local.routed_services_enabled.prometheus && local.routed_services_enabled.traefik ? 1 : 0
  source = "../../modules/prometheus"

  project_root        = var.project_root
  storage_path        = var.storage_path
  docker_socket_path  = var.docker_socket_path
  public_network_name = module.networks.public_network_name
  hostname            = local.router_hostnames.prometheus

  depends_on = [module.traefik]
}

# Grafana (depends on traefik and prometheus)
module "grafana" {
  count  = local.routed_services_enabled.grafana && local.routed_services_enabled.prometheus && local.routed_services_enabled.traefik ? 1 : 0
  source = "../../modules/grafana"

  project_root        = var.project_root
  storage_path        = var.storage_path
  public_network_name = module.networks.public_network_name
  hostname            = local.router_hostnames.grafana

  user     = var.grafana_user
  password = var.grafana_password

  depends_on = [
    module.traefik,
    module.prometheus
  ]
}
