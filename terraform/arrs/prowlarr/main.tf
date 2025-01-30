terraform {
  required_providers {
    prowlarr = {
      source = "devopsarr/prowlarr"
    }
  }
}

resource "prowlarr_tag" "western" {
  label = "western"
}

resource "prowlarr_tag" "anime" {
  label = "anime"
}

output "western_tag_id" {
  value = prowlarr_tag.western.id
}

output "anime_tag_id" {
  value = prowlarr_tag.anime.id
}
