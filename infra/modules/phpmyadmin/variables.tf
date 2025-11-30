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

variable "kitchen_network_name" {
  description = "Name of the kitchen Docker network."
  type        = string
}

variable "hostname" {
  description = "Hostname for phpMyAdmin."
  type        = string
}
