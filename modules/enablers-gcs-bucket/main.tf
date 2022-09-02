terraform {
  required_version = ">= 1.0.3"
}

resource "google_storage_bucket" "enablers-gcs-bucket" {
  name          = var.bucket_name
  location      = var.primary_region
  force_destroy = true
  uniform_bucket_level_access = true
 
}