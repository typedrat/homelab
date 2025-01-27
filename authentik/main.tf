locals {
  flows = {
    authentication = {
      slug = "default-source-authentication"
      policy = {
        name       = "discord-auth-policy"
        template   = "discordAuthPolicy.py"
      }
    }
    enrollment = {
      slug = "default-source-enrollment"
      policy = {
        name       = "discord-enrollment-policy"
        template   = "discordEnrollmentPolicy.py"
      }
    }
  }
}

data "authentik_flow" "flows" {
  for_each = local.flows
  slug     = each.value.slug
}

resource "authentik_policy_expression" "discord_policies" {
  for_each   = local.flows
  name       = each.value.policy.name
  expression = templatefile("${path.module}/${each.value.policy.template}", {
    guildId   = var.guildId
    guildName = var.guildName
  })
}

resource "authentik_policy_binding" "discord_policy_bindings" {
  for_each = local.flows
  target   = data.authentik_flow.flows[each.key].id
  policy   = authentik_policy_expression.discord_policies[each.key].id
  order    = 0
}

resource "authentik_source_oauth" "discord" {
  name                = "Discord"
  slug                = "discord"
  authentication_flow = data.authentik_flow.flows["authentication"].id
  enrollment_flow     = data.authentik_flow.flows["enrollment"].id

  provider_type     = "discord"
  consumer_key      = var.discordKey
  consumer_secret   = var.discordSecret
  additional_scopes = "guilds guilds.members.read"
}


resource "authentik_group" "discord-user" {
    name       = "Discord Users"
    attributes = jsonencode({
        discord_role_id = var.userRoleId
    })
    users      = []
}

resource "authentik_group" "discord-sysop" {
    name       = "Discord Sysops"
    attributes = jsonencode({
        discord_role_id = var.sysopRoleId
    })
    users      = []
}
