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

locals {
  indexers = yamldecode(var.indexersYaml)

  tag_mapping = {
    "western" = [module.prowlarr.western_tag_id]
    "anime"   = [module.prowlarr.anime_tag_id]
  }
}

resource "prowlarr_indexer" "indexers" {
  for_each = { for idx, indexer in local.indexers.indexers : indexer.name => indexer }

  name            = each.value.name
  app_profile_id  = 1
  enable          = each.value.enable
  priority        = each.value.priority
  implementation  = each.value.implementation
  config_contract = each.value.config_contract
  protocol        = "torrent"
  fields          = each.value.fields
  tags            = local.tag_mapping[each.value.content_type]
}
