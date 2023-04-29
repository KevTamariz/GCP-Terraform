resource "google_service_account" "terraform-account" {
  account_id   = "terraform-account"
  project = "w7-challenge"
}