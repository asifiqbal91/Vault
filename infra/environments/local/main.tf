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
  host = trimspace(var.docker_host)
}

locals {
  vault_hostname = trimspace(var.vault_hostname)
}

module "vault" {
  source = "../../modules/vault"

  project_root         = var.project_root == null ? null : trimspace(var.project_root)
  storage_root         = var.storage_root == null ? null : trimspace(var.storage_root)
  public_network_name  = trimspace(var.public_network_name)
  kitchen_network_name = trimspace(var.kitchen_network_name)
  hostname             = local.vault_hostname
  admin_token          = trimspace(var.vault_admin_token)
  database_url         = trimspace(var.vault_database_url)
}
