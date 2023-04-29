# Template (Import)
resource "google_compute_instance_template" "template-migdocker" {
  name = "template-migdocker"
  machine_type = "e2-small"
  region               = "us-central1"

  tags         = ["ssh", "http-server", "https-server", "web-server-ports", "allow-health-check"]

  disk {
    source_image = "w7-challenge/image-migdocker"
  }

  network_interface {
   network = "default"
 }
}


# Manage Instance Group
resource "google_compute_instance_group_manager" "vm-group" {
  name = "vm-group"
  base_instance_name = "vm-group"
  zone               = "us-central1-b"

  version {
    instance_template  = google_compute_instance_template.template-migdocker.id
  }

  named_port {
    name = "http"
    port = 80
  }
}


# Autoscaler
resource "google_compute_autoscaler" "autoscaler-migdocker" {
  name   = "autoscaler-migdocker"
  zone   = "us-central1-b"
  target = google_compute_instance_group_manager.vm-group.id

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.6
    }
  }
}


# LoadBalancer
# SSL Certificate
resource "google_compute_managed_ssl_certificate" "ssl-migdocker" {
  name = "ssl-migdocker"

  managed {
    domains = ["mig.ktamariz.cf."]
  }
}

# Target proxy https
resource "google_compute_target_https_proxy" "proxyhttps-migdocker" {
  name             = "proxyhttps-migdocker"
  url_map          = google_compute_url_map.urlmap-migdocker.id
  ssl_certificates = [google_compute_managed_ssl_certificate.ssl-migdocker.id]
}

# URL Map
resource "google_compute_url_map" "urlmap-migdocker" {
  name        = "urlmap-migdocker"
  description = "url map load balancing mig"

  default_service = google_compute_backend_service.backed-migdocker.id

  host_rule {
    hosts        = ["mig.ktamariz.cf"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.backed-migdocker.id

    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_service.backed-migdocker.id
    }
  }
}

# Backend Service
resource "google_compute_backend_service" "backed-migdocker" {
  name        = "backed-migdocker"
  port_name   = "http"
  protocol    = "HTTP"
  load_balancing_scheme   = "EXTERNAL"
  timeout_sec = 10

  health_checks = [google_compute_http_health_check.health-migdocker.id]
  backend {
    group           = google_compute_instance_group_manager.vm-group.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

# Health check
resource "google_compute_http_health_check" "health-migdocker" {
  name               = "health-migdocker"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
  port = 80
}

#Forwarding Rule
resource "google_compute_global_forwarding_rule" "forwarding-migdocker" {
  name       = "forwarding-migdocker"
  target     = google_compute_target_https_proxy.proxyhttps-migdocker.id
  load_balancing_scheme = "EXTERNAL"
  port_range = 443
  ip_address = google_compute_global_address.ip-migdocker.address
}

# allow access from health check ranges
resource "google_compute_firewall" "allow-health-check" {
  name          = "allow-health-check"
  direction     = "INGRESS"
  network       = google_compute_network.default.id
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  allow {
    protocol = "tcp"
  }
  target_tags = ["allow-health-check"]
}
