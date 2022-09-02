provider "google" {
  project = "${var.project}"
  region  = "${var.primary_region}"
  # credentials = file(".gcp_temp_cred.json")
  access_token	= data.google_service_account_access_token.default.access_token
  request_timeout 	= "60s"
}


provider "google" {
 alias = "impersonation"
 scopes = [
   "https://www.googleapis.com/auth/cloud-platform",
   "https://www.googleapis.com/auth/userinfo.email",
 ]
}

data "google_service_account_access_token" "default" {
 provider               	= google.impersonation
 target_service_account 	= local.terraform_service_account
 scopes                 	= ["userinfo-email", "cloud-platform"]
 lifetime               	= "1200s"
}

locals {
 terraform_service_account = "305808679572-compute@developer.gserviceaccount.com"
}