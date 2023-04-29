# Set Backend
terraform {
  backend "gcs" {
    bucket = "w7_terra-state"
    prefix = "state"
    credentials = "w7-challenge-a6ec0bbeefa1.json"
  }
}

# Provider
provider "google" {
  project = "w7-challenge"
  credentials = "${file("w7-challenge-a6ec0bbeefa1.json")}"
  region  = "us-central1"
  zone    = "us-central1-b"
}