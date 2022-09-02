// Generic setup variables
variable "project" {
  type = string
  description = "The Google Cloud Platform project ID to target."
  default = "sandbox-db-enablers"
}

variable "primary_region" {
  type = string
  description = "The primary region provision resources within."
  default = "us-central1"
}

variable "primary_zone" {
  type = string
  description = "The primary zone to provision resources within."
  default = "us-central1-a"
}

// storage bucket used for module gcs enablers
variable "bucket_name" {
  type = string
  description = "storage bucket name to passed to module"
  default = "enablers-gcs-storage-module-test"
}
