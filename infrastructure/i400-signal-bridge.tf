# Secret: registration.yaml (shared between bridge and Synapse)
resource "kubernetes_secret_v1" "signal_bridge_registration" {
  metadata {
    name = "mautrix-signal-registration"
  }
  data = {
    "registration.yaml" = <<-EOT
      id: signal
      url: http://mautrix-signal:29328
      as_token: ${var.signal_as_token}
      hs_token: ${var.signal_hs_token}
      sender_localpart: signalbot
      rate_limited: false
      org.matrix.msc3202: true
      push_ephemeral: true
      de.sorunome.msc2409.push_ephemeral: true
      namespaces:
        users:
          - regex: '@signal_.*:law-orga\.de'
            exclusive: true
          - regex: '@signalbot:law-orga\.de'
            exclusive: true
    EOT
  }
}

# Secret: rendered bridge config (contains DB password and tokens)
resource "kubernetes_secret_v1" "signal_bridge_config" {
  metadata {
    name = "mautrix-signal-config"
  }
  data = {
    "config.yaml" = templatefile("${path.module}/../src/signal/config.yaml.tpl", {
      signal_db_password = urlencode(var.signal_db_password)
      signal_as_token    = var.signal_as_token
      signal_hs_token    = var.signal_hs_token
      signal_pickle_key  = var.signal_pickle_key
    })
  }
}

# PVC: persistent bridge state (crypto store, etc.)
resource "kubernetes_persistent_volume_claim_v1" "signal_bridge_data" {
  metadata {
    name = "mautrix-signal-data"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}

# Deployment: mautrix-signal bridge
resource "kubernetes_deployment_v1" "signal_bridge" {
  metadata {
    name = "mautrix-signal"
    labels = {
      app = "mautrix-signal"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "mautrix-signal"
      }
    }

    template {
      metadata {
        labels = {
          app = "mautrix-signal"
        }
      }

      spec {
        container {
          image = "dock.mau.dev/mautrix/signal:latest"
          name  = "mautrix-signal-container"

          port {
            container_port = 29328
          }

          volume_mount {
            name       = "data"
            mount_path = "/data"
          }

          volume_mount {
            name       = "config"
            mount_path = "/data/config.yaml"
            sub_path   = "config.yaml"
          }

        }

        volume {
          name = "data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.signal_bridge_data.metadata[0].name
          }
        }

        volume {
          name = "config"
          secret {
            secret_name = kubernetes_secret_v1.signal_bridge_config.metadata[0].name
          }
        }
      }
    }
  }
}

# Service: ClusterIP only — no external access needed
resource "kubernetes_service_v1" "signal_bridge" {
  metadata {
    name = "mautrix-signal"
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.signal_bridge.spec[0].selector[0].match_labels.app
    }
    port {
      name        = "http"
      port        = 29328
      target_port = 29328
    }
  }
}
