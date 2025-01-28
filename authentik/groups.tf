resource "authentik_group" "discord-user" {
  name = "Discord Users"
  attributes = jsonencode({
    discord_role_id = var.userRoleId
  })
}

resource "authentik_group" "discord-sysop" {
  name = "Discord Sysops"
  attributes = jsonencode({
    discord_role_id = var.sysopRoleId
  })
  is_superuser = true
}
