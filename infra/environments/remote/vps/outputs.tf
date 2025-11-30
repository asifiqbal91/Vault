output "networks" {
  description = "Managed Docker networks."
  value = {
    public  = module.networks.public_network_name
    kitchen = module.networks.kitchen_network_name
  }
}

output "containers" {
  description = "Container information for all services."
  value = merge(
    local.routed_services_enabled.traefik ? {
      traefik = {
        id   = module.traefik[0].container_id
        name = module.traefik[0].container_name
      }
    } : {},
    var.enable_mariadb ? {
      mariadb = {
        id   = module.mariadb[0].container_id
        name = module.mariadb[0].container_name
      }
    } : {},
    local.routed_services_enabled.phpmyadmin && local.routed_services_enabled.traefik && var.enable_mariadb ? {
      phpmyadmin = {
        id   = module.phpmyadmin[0].container_id
        name = module.phpmyadmin[0].container_name
      }
    } : {},
    var.enable_postgres ? {
      postgres = {
        id   = module.postgres[0].container_id
        name = module.postgres[0].container_name
      }
    } : {},
    local.routed_services_enabled.dash && local.routed_services_enabled.traefik ? {
      dash = {
        id   = module.dash[0].container_id
        name = module.dash[0].container_name
      }
    } : {},
    local.routed_services_enabled.prometheus && local.routed_services_enabled.traefik ? {
      prometheus = {
        id   = module.prometheus[0].container_id
        name = module.prometheus[0].container_name
      }
    } : {},
    local.routed_services_enabled.grafana && local.routed_services_enabled.prometheus && local.routed_services_enabled.traefik ? {
      grafana = {
        id   = module.grafana[0].container_id
        name = module.grafana[0].container_name
      }
    } : {}
  )
}

output "router_hostnames" {
  description = "Resolved hostnames used by Traefik."
  value       = var.router_hostnames
}
