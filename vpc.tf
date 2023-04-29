
# VPC
resource "google_compute_network" "default" {
  description = "Default network for the project"
  name = "default"

}