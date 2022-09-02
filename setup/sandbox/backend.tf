terraform {
  backend "gcs" {
    bucket  = "enablers-gcs-tf-state"
    prefix  = "terraform/state"
    impersonate_service_account = "gitlab-runner-service-account@sandbox-db-enablers.iam.gserviceaccount.com"
 }
}

