terraform {
  required_version = ">=1.0.0"
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    google-beta = {
      source = "hashicorp/google-beta"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.6.1"
    }
  }
}

# Provider
provider "google" {
  project = "sandbox-db-enablers"
}
provider "google-beta" {
  project = "sandbox-db-enablers"
}
