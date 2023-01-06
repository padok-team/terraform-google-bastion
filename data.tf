data "google_compute_zones" "this" {
  project = var.project_id
  region  = var.region
}

data "google_compute_image" "my_image" {
  family  = "debian-11"
  project = "debian-cloud"
}
