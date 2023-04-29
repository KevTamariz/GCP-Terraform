# Subnet
resource "google_compute_subnetwork" "default" {
  name          = "default"
  ip_cidr_range = "10.128.0.0/20"
  region        = "us-central1"
  network       = google_compute_network.default.id
}
 

# IP LoadBalancer
resource "google_compute_global_address" "ip-migdocker" {
  name = "ip-migdocker"
}

# IP K8 My app
resource "google_compute_global_address" "ip-k8" {
  name = "ip-k8"
}

# IP K8 Guestbook
resource "google_compute_global_address" "ip-gb" {
  name = "ip-gb"
}