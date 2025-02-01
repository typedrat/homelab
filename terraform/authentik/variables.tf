variable "discordKey" {
  description = "The Discord OAuth2 client key for the application used by Authentik"
  type        = string
}

variable "discordSecret" {
  description = "The Discord OAuth2 client secret for the application used by Authentik"
  type        = string
}

variable "guildId" {
  description = "The Discord ID for the guild used by Authentik"
  type        = string
}

variable "guildName" {
  description = "The human-readable name of the guild used by Authentik"
  type        = string
}

variable "userRoleId" {
  description = "The Discord ID for the role representing ordinary users"
  type        = string
}

variable "sysopRoleId" {
  description = "The Discord ID for the role representing sysops"
  type        = string
}

variable "jellyfinKey" {
  description = "The Authentik OAuth2 client key for the application used by Jellyfin"
  type        = string
}

variable "jellyfinSecret" {
  description = "The Authentik OAuth2 client secret for the application used by Jellyfin"
  type        = string
}

variable "grafanaKey" {
  description = "The Authentik OAuth2 client key for the application used by Grafana"
  type        = string
}

variable "grafanaSecret" {
  description = "The Authentik OAuth2 client secret for the application used by Grafana"
  type        = string
}
