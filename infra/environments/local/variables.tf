variable "docker_host" {
  description = "Docker API endpoint (defaults to local socket)."
  type        = string
  default     = "unix:///var/run/docker.sock"
}

variable "docker_socket_path" {
  description = "Path to the Docker socket on the target host."
  type        = string
  default     = "/var/run/docker.sock"
}

variable "project_root" {
  description = "Absolute path to the Vault project root (auto-detected when null)."
  type        = string
  default     = null
}

variable "storage_path" {
  description = "Absolute path where configs and data are stored (required for sync-configs)."
  type        = string
  default     = null
}

variable "public_network_name" {
  description = "Existing Docker public network name."
  type        = string
  default     = "public"
}

variable "kitchen_network_name" {
  description = "Existing Docker kitchen network name."
  type        = string
  default     = "kitchen"
}

variable "vault_admin_token" {
  description = "Vaultwarden admin token."
  type        = string
  sensitive   = true
}

variable "vault_database_url" {
  description = "Database connection URL for Vaultwarden."
  type        = string
  sensitive   = true
}

variable "vault_hostname" {
  description = "Hostname for Vaultwarden (used by Traefik labels)."
  type        = string
}
