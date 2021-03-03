resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx"

    labels = {
      name = "nginx"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "neinkeinkaffee/flashcards-nginx:${var.commit_sha}"

          env {
            name = "BASE_URL"

            value_from {
              secret_key_ref {
                name = "flashcards-credentials"
                key  = "baseUrl"
              }
            }
          }

          image_pull_policy = "Always"
        }

        restart_policy = "Always"
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx"

    labels = {
      service = "nginx"
    }
  }

  spec {
    port {
      name        = "http"
      port        = 80
      target_port = "80"
    }

    selector = {
      app = "nginx"
    }
  }
}

