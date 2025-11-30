output "container_id" {
  description = "ID of the Grafana container."
  value       = docker_container.grafana.id
}

output "container_name" {
  description = "Name of the Grafana container."
  value       = docker_container.grafana.name
}

