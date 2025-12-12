variable "project_root" {
  description = "Absolute path to the Vault project root (auto-detected when null)."
  type        = string
  default     = null
}

variable "storage_root" {
  description = "Absolute path where configs and data are stored."
  type        = string
}

variable "public_network_name" {
  description = "Name of the public Docker network."
  type        = string
}

variable "kitchen_network_name" {
  description = "Name of the kitchen Docker network."
  type        = string
}

variable "hostname" {
  description = "Hostname for Vault."
  type        = string
}

variable "admin_token" {
  description = "Admin token for Vaultwarden."
  type        = string
  sensitive   = true
}

variable "database_url" {
  description = "Database connection URL for Vaultwarden."
  type        = string
  sensitive   = true
}
