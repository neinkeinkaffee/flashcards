resource "kubernetes_deployment" "postgres" {
  metadata {
    name = "postgres"

    labels = {
      name = "database"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        service = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          service = "postgres"
        }
      }

      spec {
        volume {
          name = "postgres-volume-mount"

          persistent_volume_claim {
            claim_name = "postgres-pvc"
          }
        }

        init_container {
          name    = "pgsql-data-permission-fix"
          image   = "busybox"
          command = ["/bin/chmod", "-R", "777", "/data"]

          volume_mount {
            name       = "postgres-volume-mount"
            mount_path = "/data"
          }
        }

        container {
          name  = "postgres"
          image = "postgres:9.6.16-alpine"

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

          volume_mount {
            name       = "postgres-volume-mount"
            mount_path = "/var/lib/postgresql"
          }
        }

        restart_policy = "Always"
      }
    }
  }
}

resource "kubernetes_service" "postgres" {
  metadata {
    name = "postgres"

    labels = {
      service = "postgres"
    }
  }

  spec {
    port {
      port = 5432
    }

    selector = {
      service = "postgres"
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_persistent_volume_claim" "postgres_pvc" {
  metadata {
    name      = "postgres-pvc"
    namespace = "default"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "500Mi"
      }
    }

    storage_class_name = "nfs-client"
  }
}

