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

variable "docker_socket_path" {
  description = "Path to the Docker socket on the target host."
  type        = string
  default     = "/var/run/docker.sock"
}

variable "hostname" {
  description = "Hostname for Prometheus."
  type        = string
}
