output "container_id" {
  description = "ID of the Dash container."
  value       = docker_container.dash.id
}

output "container_name" {
  description = "Name of the Dash container."
  value       = docker_container.dash.name
}

