variable "serviceName" {
  type        = string
  description = "The name of the Service for this instance."
  default     = "radarr"
}

variable "downloadPath" {
  type = string
}

variable "apiKey" {
  type        = string
  description = "Radarr API key"
}

variable "tagId" {
  type        = number
  description = "Tag ID to associate with this application instance"
}

variable "extraSyncCategories" {
  type    = set(number)
  default = []
}
