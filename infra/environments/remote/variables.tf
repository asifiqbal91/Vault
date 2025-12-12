variable "docker_host" {
  description = "Docker API endpoint (ssh://, tcp://, or unix://)."
  type        = string
}

variable "docker_ca_material" {
  description = "PEM-formatted CA certificate for TLS-secured Docker endpoints."
  type        = string
  default     = null
}

variable "docker_cert_material" {
  description = "PEM-formatted client certificate for TLS-secured Docker endpoints."
  type        = string
  default     = null
}

variable "docker_key_material" {
  description = "PEM-formatted client key for TLS-secured Docker endpoints."
  type        = string
  default     = null
  sensitive   = true
}

variable "docker_socket_path" {
  description = "Path to the Docker socket on the target host."
  type        = string
  default     = "/var/run/docker.sock"
}

variable "project_root" {
  description = "Absolute path to the Vault project root on the remote host."
  type        = string
}

variable "storage_root" {
  description = "Absolute path where configs and data are stored."
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
