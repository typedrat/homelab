resource "authentik_group" "discord-user" {
  name = "Discord Users"
  attributes = jsonencode({
    discord_role_id = var.userRoleId
  })
  users = []
}

resource "authentik_group" "discord-sysop" {
  name = "Discord Sysops"
  attributes = jsonencode({
    discord_role_id = var.sysopRoleId
  })
  users = []
}
