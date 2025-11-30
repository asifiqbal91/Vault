output "container_id" {
  description = "ID of the phpMyAdmin container."
  value       = docker_container.phpmyadmin.id
}

output "container_name" {
  description = "Name of the phpMyAdmin container."
  value       = docker_container.phpmyadmin.name
}

