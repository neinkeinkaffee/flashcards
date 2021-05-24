provider "kubernetes" {}

terraform {
  backend "s3" {
    key = "flashcards"
  }
}

resource "kubernetes_namespace" "flashcards" {
  metadata {
    name = "flashcards"
  }
}
