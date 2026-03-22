resource "kubernetes_deployment_v1" "deployment" {
  metadata {
    name = "${var.repository_name}"
    labels = {
      app = "${var.repository_name}"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "${var.repository_name}"
      }
    }

    template {
      metadata {
        labels = {
          app = "${var.repository_name}"
        }
      }

      spec {
        service_account_name            = kubernetes_service_account_v1.synapse.metadata[0].name
        automount_service_account_token = false

        image_pull_secrets {
          name = data.terraform_remote_state.cluster.outputs.image_pull_secret_name
        }

        container {
          image = "${data.terraform_remote_state.cluster.outputs.registry_endpoint}/${var.repository_name}:${var.image_version}"
          name  = "${var.repository_name}-container"

          dynamic "env" {
            for_each = nonsensitive(toset(keys(var.env_vars)))
            content {
              name  = env.key
              value = var.env_vars[env.key]
            }
          }

          port {
            container_port = 8080
          }

          volume_mount {
            name       = "signal-registration"
            mount_path = "/data/signal-registration.yaml"
            sub_path   = "registration.yaml"
          }

          readiness_probe {
            http_get {
              port = 8080
              path = "/"
              http_header {
                name = "Host"
                value = "synapse.law-orga.de"
              }
            }
          }
        }

        volume {
          name = "signal-registration"
          secret {
            secret_name = kubernetes_secret_v1.signal_bridge_registration.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service_account_v1" "synapse" {
  metadata {
    name = "${var.repository_name}"
  }
}
