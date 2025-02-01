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

resource "sonarr_root_folder" "root_folder" {
  path = var.libraryPath
}

resource "sonarr_naming" "naming" {
  rename_episodes            = true
  replace_illegal_characters = true
  colon_replacement_format   = 4 # smart
  multi_episode_style        = 5 # prefixed range
  series_folder_format       = "{Series Title}"
  season_folder_format       = "Season {season:00}"
  specials_folder_format     = "Specials"

  standard_episode_format = "{Series TitleYear} - S{season:00}E{episode:00} - {Episode CleanTitle} [{Custom Formats }{Quality Full}]{[MediaInfo VideoDynamicRangeType]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels]}{[MediaInfo VideoCodec]}{-Release Group}"
  daily_episode_format    = "{Series TitleYear} - {Air-Date} - {Episode CleanTitle} [{Custom Formats }{Quality Full}]{[MediaInfo VideoDynamicRangeType]}{[Mediainfo AudioCodec}{ Mediainfo AudioChannels]}{[MediaInfo VideoCodec]}{-Release Group}"
  anime_episode_format    = "{Series TitleYear} - S{season:00}E{episode:00} - {absolute:000} - {Episode CleanTitle} [{Custom Formats }{Quality Full}]{[MediaInfo VideoDynamicRangeType]}[{MediaInfo VideoBitDepth}bit]{[MediaInfo VideoCodec]}[{Mediainfo AudioCodec} { Mediainfo AudioChannels}]{MediaInfo AudioLanguages}{-Release Group}"
}
