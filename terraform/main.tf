provider "kubernetes" {}

resource "kubernetes_namespace" "flashcards" {
  metadata {
    name = "flashcards"
  }
}
