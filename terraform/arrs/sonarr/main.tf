terraform {
  required_providers {
    sonarr = {
      source = "devopsarr/sonarr"
    }

    prowlarr = {
      source = "devopsarr/prowlarr"
    }
  }
}

resource "sonarr_download_client_flood" "flood" {
  enable           = true
  priority         = 1
  name             = "Flood"
  host             = "flood.media.svc.cluster.local"
  port             = 80
  destination      = var.downloadPath
  field_tags       = [var.serviceName]
  post_import_tags = ["imported"]
}

resource "prowlarr_application_sonarr" "sonarr" {
  name         = "Sonarr (${var.serviceName})"
  api_key      = var.apiKey
  base_url     = "http://${var.serviceName}.media.svc.cluster.local"
  prowlarr_url = "http://prowlarr.media.svc.cluster.local"
  sync_level   = "fullSync"
  tags         = [var.tagId]
}
