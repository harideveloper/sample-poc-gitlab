terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

# Workload Identity
resource "random_id" "random" {
  byte_length = 4
}

resource "google_iam_workload_identity_pool" "gitlab-pool" {
  provider                  = google-beta
  workload_identity_pool_id = "gitlab-pool-${random_id.random.hex}"
  project = var.gcp_project_name
}

resource "google_iam_workload_identity_pool_provider" "gitlab-provider-jwt" {
  provider                           = google-beta
  workload_identity_pool_id          = google_iam_workload_identity_pool.gitlab-pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "gitlab-jwt-${random_id.random.hex}"
  project = var.gcp_project_name
  attribute_condition                = "assertion.namespace_path.startsWith(\"${var.gitlab_namespace_path}\")"
  attribute_mapping = {
    "google.subject"           = "assertion.sub", # Required
    "attribute.aud"            = "assertion.aud",
    "attribute.project_path"   = "assertion.project_path",
    "attribute.project_id"     = "assertion.project_id",
    "attribute.namespace_id"   = "assertion.namespace_id",
    "attribute.namespace_path" = "assertion.namespace_path",
    "attribute.user_email"     = "assertion.user_email",
    "attribute.ref"            = "assertion.ref",
    "attribute.ref_type"       = "assertion.ref_type",
  }
  oidc {
    issuer_uri        = var.gitlab_url
    allowed_audiences = [var.gitlab_url]
  }
}

# service accout 
resource "google_service_account" "gitlab-runner" {
  account_id   = var.gitlab_service_account
  display_name = var.gitlab_service_account_display_name
}

# IAM Service Account Binding
resource "google_service_account_iam_binding" "gitlab-runner-oidc" {
  provider           = google-beta
  service_account_id = google_service_account.gitlab-runner.name

  count = length(var.enabler-gitlab-sa-roles)
  role =  var.enabler-gitlab-sa-roles[count.index]
  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.gitlab-pool.name}/attribute.project_id/${var.gitlab_project_id}"
  ]
}

# To be Tested 
# data "google_iam_policy" "gitlabrunner-sa-iam-policy" {
#   binding {
#     role = "roles/storage.objectEditor"
#     members = [
#     "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.gitlab-pool.name}/attribute.project_id/${var.gitlab_project_id}"
#     ]
#     members = [google_service_account.gitlab-runner.email]
#   }
# }

# resource "google_service_account_iam_policy" "admin-account-iam" {
#   service_account_id = google_service_account.gitlab-runner.name
#   policy_data        = data.google_iam_policy.gitlabrunner-sa-iam-policy.policy_data
# }



# VPC
resource "google_compute_network" "vpc-enablers" {
  project = var.gcp_project_name
  name    = var.vpc_name
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet-enablers" {
  name          = var.subnet_name
  region        = var.primary_region
  network       = google_compute_network.vpc-enablers.name
  ip_cidr_range = var.subnet_ip_range
}


# Firewall
resource "google_compute_firewall" "firewall-rule-enablers" {
  name        = var.firewall_rule_name
  description = var.firewall_rule_desc
  network     = google_compute_network.vpc-enablers.name

  allow {
    protocol  = "icmp"
  }

  allow {
    protocol  = "tcp"
    ports     = ["22","80", "8080", "1000-2000"]
  }
  
  source_ranges = ["0.0.0.0/0"]
  priority      = "1000"

}

# VM
resource "google_compute_instance" "gitlab-runner-vm" {
  name         = var.name
  zone         = var.primary_zone
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  metadata_startup_script = file("${path.module}/script/setup.sh")
 

  network_interface {
    network = google_compute_network.vpc-enablers.name
    subnetwork = google_compute_subnetwork.subnet-enablers.name
    access_config {
    }
  }

  service_account {
    email  = google_service_account.gitlab-runner.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
  
}

# output files
output "GCP_WORKLOAD_IDENTITY_PROVIDER" {
  value = google_iam_workload_identity_pool_provider.gitlab-provider-jwt.name
}

output "GCP_SERVICE_ACCOUNT" {
  value = google_service_account.gitlab-runner.email
}


output "vpc_network_name" {
  value = google_compute_network.vpc-enablers.name
}

output "vpc_subnetwork_name" {
  value = google_compute_subnetwork.subnet-enablers.name
}

