locals {
  outpost_config = {
    authentik_host                 = "https://auth.thisratis.gay/"
    authentik_host_browser         = ""
    authentik_host_insecure        = false
    container_image                = null
    docker_labels                  = null
    docker_map_ports               = true
    docker_network                 = null
    kubernetes_disabled_components = []
    kubernetes_image_pull_secrets  = []
    kubernetes_ingress_annotations = {}
    kubernetes_ingress_class_name  = null
    kubernetes_ingress_secret_name = "authentik-outpost-tls"
    kubernetes_json_patches        = null
    kubernetes_namespace           = "authentik"
    kubernetes_replicas            = 1
    kubernetes_service_type        = "ClusterIP"
    log_level                      = "info"
    object_naming_template         = "ak-outpost-%(name)s"
    refresh_interval               = "minutes=5"
  }
}
