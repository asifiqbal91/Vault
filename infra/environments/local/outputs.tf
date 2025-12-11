output "containers" {
  description = "Container information for all services."
  value = {
    vault = {
      id   = module.vault.container_id
      name = module.vault.container_name
    }
  }
}
