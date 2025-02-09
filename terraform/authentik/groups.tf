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

resource "authentik_group" "sftpgo-user" {
  name = "sftpgo-users"
  attributes = jsonencode({
    discord_role_id         = var.userRoleId
    discord_role_id_exclude = var.sysopRoleId
  })
}

resource "authentik_group" "sftpgo-sysop" {
  name = "sftpgo-sysops"
  attributes = jsonencode({
    discord_role_id = var.sysopRoleId
  })
}

resource "authentik_group" "grafana-admins" {
  name = "Grafana Admins"
}
