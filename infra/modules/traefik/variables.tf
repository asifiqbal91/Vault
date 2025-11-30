variable "project_root" {
  description = "Absolute path to the kitchen project root (auto-detected when null)."
  type        = string
  default     = null
}

variable "storage_path" {
  description = "Absolute path where configs and data are stored."
  type        = string
}

variable "docker_socket_path" {
  description = "Path to the Docker socket on the target host."
  type        = string
  default     = "/var/run/docker.sock"
}

variable "public_network_name" {
  description = "Name of the public Docker network."
  type        = string
}

variable "cf_api_email" {
  description = "Cloudflare API email for Traefik DNS challenges."
  type        = string
}

variable "cf_dns_api_token" {
  description = "Cloudflare DNS API token for Traefik."
  type        = string
  sensitive   = true
}

variable "traefik_credential" {
  description = "Traefik dashboard basic-auth credentials in htpasswd format."
  type        = string
  sensitive   = true
}

variable "hostname" {
  description = "Hostname for Traefik dashboard."
  type        = string
}
