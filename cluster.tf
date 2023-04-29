# GKE Cluster
resource "google_container_cluster" "cluster-w7" {
  name                     = "cluster-w7"
  location                 = "us-central1-b"
  network                  = google_compute_network.default.self_link 
  subnetwork               = google_compute_subnetwork.default.self_link
  remove_default_node_pool = true
  initial_node_count       = 1

  release_channel {
    channel = "REGULAR"
  }

}

resource "google_container_node_pool" "node-pool1" {
  name       = "node-pool1"
  location   = "us-central1-b"
  cluster    = google_container_cluster.cluster-w7.name
  node_count = 1


  node_config {
    machine_type = "e2-medium"
    service_account = google_service_account.terraform-account.email
    oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform"
        ]
  }
}

resource "google_container_node_pool" "node-pool2" {
  name       = "node-pool12"
  location   = "us-central1-b"
  cluster    = google_container_cluster.cluster-w7.name
  node_count = 1

  node_config {
    machine_type = "e2-medium"
    service_account = google_service_account.terraform-account.email
    oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform"
        ]
  }
}

# SSL Certificate for K8s
resource "google_compute_managed_ssl_certificate" "ssl-kube" {
  name = "ssl-kube"

  managed {
    domains = ["k8.ktamariz.cf.", "guestbook.ktamariz.cf."]
  }
}

