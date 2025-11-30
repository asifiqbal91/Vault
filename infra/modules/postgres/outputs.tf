output "container_id" {
  description = "ID of the Postgres container."
  value       = docker_container.postgres.id
}

output "container_name" {
  description = "Name of the Postgres container."
  value       = docker_container.postgres.name
}

