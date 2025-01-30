module "radarr" {
  source = "./radarr"

  downloadPath = "/data/torrents/movies"
  apiKey       = var.radarrApiKey
  tagId        = module.prowlarr.western_tag_id
}

module "radarr-anime" {
  source = "./radarr"

  providers = {
    radarr = radarr.anime
  }

  serviceName         = "radarr-anime"
  downloadPath        = "/data/torrents/anime_movies"
  apiKey              = var.radarrAnimeApiKey
  extraSyncCategories = [5070]
  tagId               = module.prowlarr.anime_tag_id
}

module "sonarr" {
  source = "./sonarr"

  downloadPath = "/data/torrents/tv_shows"
  apiKey       = var.sonarrApiKey
  tagId        = module.prowlarr.western_tag_id
}

module "sonarr-anime" {
  source = "./sonarr"

  providers = {
    sonarr = sonarr.anime
  }

  serviceName  = "sonarr-anime"
  downloadPath = "/data/torrents/anime"
  apiKey       = var.sonarrAnimeApiKey
  tagId        = module.prowlarr.anime_tag_id
}

module "prowlarr" {
  source = "./prowlarr"
}
