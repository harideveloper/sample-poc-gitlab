output "test_cluster" {
  value     = google_container_cluster.primary
  sensitive = true
}

output "test_node" {
  value = 1
}

output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.primary.name
}

output "cluster_location" {
  description = "GKE cluster location"
  value       = google_container_cluster.primary.location
}

