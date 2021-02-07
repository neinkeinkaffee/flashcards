resource "kubernetes_secret" "flashcards_credentials" {
  metadata {
    name = "flashcards-credentials"
  }

  data = {
    baseUrl = "https://flashcards.${var.domain}"
    postgresUser = var.postgres_user
    postgresPassword = var.postgres_password
  }

  type = "Opaque"
}

resource "kubernetes_secret" "basic_auth" {
  metadata {
    name      = "basic-auth"
    namespace = "default"
  }

  data = {
    auth = "${var.basic_auth_user}:${var.basic_auth_password}"
  }

  type = "Opaque"
}

