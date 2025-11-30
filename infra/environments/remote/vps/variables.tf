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
  description = "Absolute path to the kitchen project root on the remote host."
  type        = string
}

variable "storage_path" {
  description = "Absolute path where configs and data are stored (required for sync-configs)."
  type        = string
  default     = null
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

variable "enable_mariadb" {
  description = "Deploy the MariaDB database."
  type        = bool
  default     = false
}

variable "enable_postgres" {
  description = "Deploy the Postgres database."
  type        = bool
  default     = false
}

variable "mariadb_port" {
  description = "Host port that exposes MariaDB."
  type        = number
  default     = 3306
}

variable "mariadb_root_password" {
  description = "Root password for MariaDB."
  type        = string
  sensitive   = true
}

variable "postgres_user" {
  description = "Postgres admin user."
  type        = string
}

variable "postgres_password" {
  description = "Password for the Postgres admin user."
  type        = string
  sensitive   = true
}

variable "grafana_user" {
  description = "Grafana admin username."
  type        = string
  default     = "admin"
}

variable "grafana_password" {
  description = "Grafana admin password."
  type        = string
  sensitive   = true
}

variable "router_hostnames" {
  description = "Hostnames for routed services (traefik, phpmyadmin, dash, prometheus, grafana). Presence enables the service."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for hostname in values(var.router_hostnames) :
      length(trimspace(coalesce(hostname, ""))) > 0
    ])
    error_message = "router_hostnames values must be non-empty hostnames."
  }

  validation {
    condition = alltrue([
      !contains(keys(var.router_hostnames), "phpmyadmin") || contains(keys(var.router_hostnames), "traefik"),
      !contains(keys(var.router_hostnames), "dash") || contains(keys(var.router_hostnames), "traefik"),
      !contains(keys(var.router_hostnames), "prometheus") || contains(keys(var.router_hostnames), "traefik"),
      !contains(keys(var.router_hostnames), "grafana") || (contains(keys(var.router_hostnames), "traefik") && contains(keys(var.router_hostnames), "prometheus")),
      !contains(keys(var.router_hostnames), "phpmyadmin") || var.enable_mariadb
    ])
    error_message = "router_hostnames for routed apps require traefik (and prometheus for grafana); phpmyadmin also requires enable_mariadb = true."
  }
}
