terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}


module "enabler-gcs-bucket-sample" {
    source       = "../../modules/enablers-gcs-bucket"
    bucket_name         = var.bucket_name
    primary_region      = var.primary_region
}