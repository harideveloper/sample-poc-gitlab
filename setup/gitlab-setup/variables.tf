// Generic setup variables

variable "gcp_project_name" {
  type        = string
  description = "GCP Prpject Name for Enablers Team"
  default = "sandbox-db-enablers"
}

variable "primary_region" {
  type = string
  description = "The primary region provision resources within."
  default = "europe-west1"
}

variable "primary_zone" {
  type = string
  description = "The primary zone to provision resources within."
  default = "europe-west1-c"
}

# GCP Workload Identity Variables

# gitlab service account

variable "gitlab_service_account" {
  type    = string
  default = "gitlab-runner-service-account"
}

variable "gitlab_service_account_display_name" {
  type    = string
  default = "Service Account for GitLab Runner"
}

variable "gitlab_url" {
  type    = string
  default = "https://pscode.lioncloud.net"
}

variable "gitlab_project_id" {
  type        = string
  description = "Project ID to restrict authentication from."
  default = "21024"
}

variable "gitlab_namespace_path" {
  type        = string
  description = "harsunda1/enablers_poc"
  default = "harsunda1/enablers_poc"
}


variable "enabler-gitlab-sa-roles" {
  type =list(string)
  default = ["roles/iam.workloadIdentityUser"]
}

# VPC, Subnet & firewall

variable "vpc_name" {
  description = "Enablers VPC Name"
  default     = "vpc-enablers"
}

variable "subnet_name" {
  description = "Enablers Subnet Name"
  default     = "subnet-enablers-europe-west-1"
}

variable "subnet_ip_range" {
  description = "Enablers Subnet IP CIDR Range"
  default     = "10.130.0.0/20"
}

# firewall

variable "firewall_rule_name" {
  description = "Firewall rules name"
  default     = "enablers-europe-west1-allow-icmp-ssh-rdp"
}

variable "firewall_rule_desc" {
  description = "Firewall rules description"
  default     = "Firewall rules to enable GCP Compute VM Access through SSH, RDP"
}


# VM
variable "name" {
  description = "VM Name"
  default     = "gitlab-runner"
}

variable "machine_type" {
  description = "VM machine_type"
  default     = "f1-micro"
}

variable "image" {
  description = "VM image"
  default     = "ubuntu-os-pro-cloud/ubuntu-pro-1804-lts"
}