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
  vault_hostname = trimspace(var.vault_hostname)
}

module "vault" {
  source = "../../../modules/vault"

  project_root         = var.project_root
  storage_path         = var.storage_path
  public_network_name  = var.public_network_name
  kitchen_network_name = var.kitchen_network_name
  hostname             = local.vault_hostname
  admin_token          = var.vault_admin_token
  database_url         = var.vault_database_url
}
