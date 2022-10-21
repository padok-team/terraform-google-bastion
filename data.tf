data "google_compute_zones" "this" {
  project = var.project_id
  region  = data.google_compute_subnetwork.this.region
}

data "google_compute_subnetwork" "this" {
  self_link = "https://www.googleapis.com/compute/v1/${var.subnet_self_link}"
}

data "google_compute_image" "my_image" {
  family  = "debian-11"
  project = "debian-cloud"
}
