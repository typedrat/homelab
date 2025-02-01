variable "serviceName" {
  type        = string
  description = "The label to use in the download client for this instance."
  default     = "sonarr"
}

variable "libraryPath" {
  type = string
}

variable "downloadPath" {
  type = string
}

variable "apiKey" {
  type        = string
  description = "Sonarr API key"
}

variable "tagId" {
  type        = number
  description = "Tag ID to associate with this application instance"
}
