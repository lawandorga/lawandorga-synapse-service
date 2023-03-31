resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name = var.repository_name
    annotations = {
      "nginx.ingress.kubernetes.io/proxy-body-size"    = "50m"
      "cert-manager.io/cluster-issuer"                 = "${data.terraform_remote_state.cert_manager.outputs.cluster_issuer_name}"
    }
  }

  spec {
    rule {
      host = "synapse.law-orga.de"
      http {
        path {
          backend {
            service {
              name = kubernetes_service_v1.service.metadata.0.name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
    tls {
      hosts       = ["synapse.law-orga.de"]
      secret_name = var.certificate_name
    }
  }
}
