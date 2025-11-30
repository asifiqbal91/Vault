output "container_id" {
  description = "ID of the Traefik container."
  value       = docker_container.traefik.id
}

output "container_name" {
  description = "Name of the Traefik container."
  value       = docker_container.traefik.name
}

