resource "kubernetes_network_policy_v1" "mautrix_signal_default_deny_ingress" {
  metadata {
    name = "mautrix-signal-deny-ingress"
  }

  spec {
    pod_selector {
      match_labels = {
        app = "mautrix-signal"
      }
    }

    policy_types = ["Ingress"]
  }
}

resource "kubernetes_network_policy_v1" "mautrix_signal_allow_ingress_from_synapse" {
  metadata {
    name = "mautrix-signal-allow-from-synapse"
  }

  spec {
    pod_selector {
      match_labels = {
        app = "mautrix-signal"
      }
    }

    policy_types = ["Ingress"]

    ingress {
      from {
        pod_selector {
          match_labels = {
            app = var.repository_name
          }
        }
      }

      ports {
        protocol = "TCP"
        port     = 29328
      }
    }
  }
}
