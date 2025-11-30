output "public_network_name" {
  description = "Name of the public Docker network."
  value       = docker_network.public.name
}

output "kitchen_network_name" {
  description = "Name of the kitchen Docker network."
  value       = docker_network.kitchen.name
}

