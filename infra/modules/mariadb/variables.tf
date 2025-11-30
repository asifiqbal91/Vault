variable "project_root" {
  description = "Absolute path to the kitchen project root (auto-detected when null)."
  type        = string
  default     = null
}

variable "storage_path" {
  description = "Absolute path where configs and data are stored."
  type        = string
}

variable "kitchen_network_name" {
  description = "Name of the kitchen Docker network."
  type        = string
}

variable "port" {
  description = "Host port that exposes MariaDB."
  type        = number
  default     = 3306
}

variable "root_password" {
  description = "Root password for MariaDB."
  type        = string
  sensitive   = true
}
