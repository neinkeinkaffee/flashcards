resource "kubernetes_ingress" "flashcards" {
  metadata {
    name = "flashcards"

    annotations = {
      "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
      "ingress.kubernetes.io/auth-secret" = "basic-auth"
      "ingress.kubernetes.io/auth-type" = "basic"
      "kubernetes.io/ingress.class" = "traefik"
    }
  }

  spec {
    tls {
      hosts       = ["flashcards.${var.domain}"]
      secret_name = "flashcards-things-on-top-of-other-things-de"
    }

    rule {
      host = "flashcards.${var.domain}"

      http {
        path {
          path = "/"

          backend {
            service_name = "nginx"
            service_port = "80"
          }
        }

        path {
          path = "/flashcards"

          backend {
            service_name = "flask"
            service_port = "5000"
          }
        }
      }
    }
  }
}

