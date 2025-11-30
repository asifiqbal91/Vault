variable "project_root" {
  description = "Absolute path to the kitchen project root (auto-detected when null)."
  type        = string
  default     = null
}

variable "storage_path" {
  description = "Absolute path where configs and data are stored."
  type        = string
}

variable "public_network_name" {
  description = "Name of the public Docker network."
  type        = string
}

variable "user" {
  description = "Postgres admin user."
  type        = string
}

variable "password" {
  description = "Password for the Postgres admin user."
  type        = string
  sensitive   = true
}
