variable "project_id" {
  type    = string
  default = "sandbox-db-enablers"
}

variable "vpc" {
  type    = string
  default = "vpc-gke-enablers"
}

variable "region" {
  type    = string
  default = "europe-west2"
}

variable "subnet_name" {
  type    = string
  default = "subnet-01"
}

variable "subnet_ip" {
  type    = string
  default = "10.0.0.0/20"
}

variable "pod_cidr" {
  type    = string
  default = "10.10.0.0/20"
}

variable "svc1_cidr" {
  type    = string
  default = "10.100.0.0/24"
}

variable "svc2_cidr" {
  type    = string
  default = "10.100.1.0/24"
}

variable "gke1" {
  type    = string
  default = "gke1-enablers"
}

variable "gke2" {
  type    = string
  default = "gke2-enablers"
}

variable "gke1_location" {
  type    = string
  default = "europe-west2-a"
}

variable "gke2_location" {
  type    = string
  default = "europe-west2-b"
}

variable "gke1_kubeconfig" {
  type    = string
  default = "../gke1_kubeconfig_enablers.secret"
}

variable "gke2_kubeconfig" {
  type    = string
  default = "../gke2_kubeconfig_enablers.secret"
}

variable "gke_channel" {
  type    = string
  default = "REGULAR"
}

variable "gke_enabled" {
  type    = bool
  default = true
}

variable "application" {
  type        = string
  description = "Application name used to avoid clashes between multiple deployments of this code"
  default     = "enablers"
}

variable "machine_type" {
  type        = string
  description = "Machine type of the GKE nodes"
  default     = "n1-standard-4"
}
