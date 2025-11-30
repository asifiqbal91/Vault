output "container_id" {
  description = "ID of the Vault container."
  value       = docker_container.vault.id
}

output "container_name" {
  description = "Name of the Vault container."
  value       = docker_container.vault.name
}
