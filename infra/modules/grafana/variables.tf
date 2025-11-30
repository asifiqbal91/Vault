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
  description = "Grafana admin username."
  type        = string
  default     = "admin"
}

variable "password" {
  description = "Grafana admin password."
  type        = string
  sensitive   = true
}

variable "hostname" {
  description = "Hostname for Grafana."
  type        = string
}
