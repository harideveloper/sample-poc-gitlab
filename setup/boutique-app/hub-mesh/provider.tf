terraform {
  required_version = ">=1.0.0"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.88.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = "3.88.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
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
