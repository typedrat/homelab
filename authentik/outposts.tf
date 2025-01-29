resource "authentik_service_connection_kubernetes" "local" {
  name  = "local"
  local = true
}

resource "authentik_outpost" "ldap" {
  name               = "LDAP Outpost"
  type               = "ldap"
  service_connection = authentik_service_connection_kubernetes.local.id
  protocol_providers = [
    authentik_provider_ldap.jellyfin_ldap.id
  ]
}

resource "authentik_outpost" "proxy" {
  name               = "Proxy Outpost"
  type               = "proxy"
  service_connection = authentik_service_connection_kubernetes.local.id
  protocol_providers = [
    authentik_provider_proxy.flood.id,
    authentik_provider_proxy.prowlarr.id,
    authentik_provider_proxy.radarr.id,
    authentik_provider_proxy.sonarr.id
  ]
}
