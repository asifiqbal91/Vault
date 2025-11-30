output "container_id" {
  description = "ID of the MariaDB container."
  value       = docker_container.mariadb.id
}

output "container_name" {
  description = "Name of the MariaDB container."
  value       = docker_container.mariadb.name
}

