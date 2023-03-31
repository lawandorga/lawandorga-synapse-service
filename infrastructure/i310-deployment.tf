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
            container_port = 8008
          }
        }
      }
    }
  }
}
