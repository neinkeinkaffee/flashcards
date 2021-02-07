resource "kubernetes_deployment" "flask" {
  metadata {
    name = "flask"

    labels = {
      name = "flask"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "flask"
      }
    }

    template {
      metadata {
        labels = {
          app = "flask"
        }
      }

      spec {
        container {
          name  = "flask"
          image = "neinkeinkaffee/flashcards-flask:latest"

          env {
            name  = "FLASK_ENV"
            value = "development"
          }

          env {
            name  = "APP_SETTINGS"
            value = "flashcards.config.DevelopmentConfig"
          }

          env {
            name = "POSTGRES_USER"

            value_from {
              secret_key_ref {
                name = "flashcards-credentials"
                key  = "postgresUser"
              }
            }
          }

          env {
            name = "POSTGRES_PASSWORD"

            value_from {
              secret_key_ref {
                name = "flashcards-credentials"
                key  = "postgresPassword"
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

resource "kubernetes_service" "flask" {
  metadata {
    name = "flask"

    labels = {
      service = "flask"
    }
  }

  spec {
    port {
      port        = 5000
      target_port = "5000"
    }

    selector = {
      app = "flask"
    }
  }
}

