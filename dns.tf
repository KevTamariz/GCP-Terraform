# DNS Zone
resource "google_dns_managed_zone" "dns-migdocker" {
  name        = "dns-migdocker"
  dns_name    = "ktamariz.cf."
  description = "DNS Zone for m"
  }

resource "random_id" "rnd" {
  byte_length = 4
}

# DNS Record - VM Instance
resource "google_dns_record_set" "app1" {
  name = "app1.${google_dns_managed_zone.dns-migdocker.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.dns-migdocker.name

  rrdatas = ["34.136.176.10"]
}

# DNS Record - Managed instance group
resource "google_dns_record_set" "mig" {
  name = "mig.${google_dns_managed_zone.dns-migdocker.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.dns-migdocker.name

  rrdatas = [google_compute_global_address.ip-migdocker.address]
}

# DNS Record - K8 App
resource "google_dns_record_set" "k8" {
  name = "k8.${google_dns_managed_zone.dns-migdocker.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.dns-migdocker.name

  rrdatas = [google_compute_global_address.ip-k8.address]
}

# DNS Record - K8 Guestbook
resource "google_dns_record_set" "guestbook" {
  name = "guestbook.${google_dns_managed_zone.dns-migdocker.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.dns-migdocker.name

  rrdatas = [google_compute_global_address.ip-gb.address]
}