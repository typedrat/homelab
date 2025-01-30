terraform {
  required_providers {
    radarr = {
      source = "devopsarr/radarr"
    }

    prowlarr = {
      source = "devopsarr/prowlarr"
    }
  }
}

resource "radarr_download_client_flood" "flood" {
  enable           = true
  priority         = 1
  name             = "Flood"
  host             = "flood.media.svc.cluster.local"
  port             = 80
  destination      = var.downloadPath
  field_tags       = [var.serviceName]
  post_import_tags = ["imported"]
}

resource "prowlarr_application_radarr" "radarr" {
  name         = "Radarr (${var.serviceName})"
  api_key      = var.apiKey
  base_url     = "http://${var.serviceName}.media.svc.cluster.local"
  prowlarr_url = "http://prowlarr.media.svc.cluster.local"
  sync_categories = setunion(var.extraSyncCategories, [
    2000, # Movies
    2010, # Movies/Foreign
    2020, # Movies/Other
    2030, # Movies/SD
    2040, # Movies/HD
    2045, # Movies/UHD
    2050, # Movies/BluRay
    2060, # Movies/3D
    2070, # Movies/DVD
    2080, # Movies/WEB-DL
    2090  # Movies/x265
  ])
  sync_level = "fullSync"
  tags       = [var.tagId]
}
