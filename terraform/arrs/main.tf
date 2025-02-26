module "radarr" {
  source = "./radarr"

  downloadPath = "/data/torrents/movies"
  libraryPath  = "/data/movies"
  apiKey       = var.radarrApiKey
  tagId        = module.prowlarr.western_tag_id
}

module "radarr-anime" {
  source = "./radarr"

  providers = {
    radarr = radarr.anime
  }

  serviceName         = "radarr-anime"
  libraryPath         = "/data/anime-movies"
  downloadPath        = "/data/torrents/anime-movies"
  apiKey              = var.radarrAnimeApiKey
  extraSyncCategories = [5070]
  tagId               = module.prowlarr.anime_tag_id
}

module "sonarr" {
  source = "./sonarr"

  libraryPath  = "/data/tv-shows"
  downloadPath = "/data/torrents/tv-shows"
  apiKey       = var.sonarrApiKey
  tagId        = module.prowlarr.western_tag_id
}

module "sonarr-anime" {
  source = "./sonarr"

  providers = {
    sonarr = sonarr.anime
  }

  serviceName  = "sonarr-anime"
  libraryPath  = "/data/anime"
  downloadPath = "/data/torrents/anime"
  apiKey       = var.sonarrAnimeApiKey
  tagId        = module.prowlarr.anime_tag_id
}

module "prowlarr" {
  source = "./prowlarr"
}
