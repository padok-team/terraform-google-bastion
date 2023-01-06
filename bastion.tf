locals {
  gcp_iap_source_ranges = ["35.235.240.0/20"]
  zone                  = random_shuffle.zone.result[0]
}

# Select a zone randomly
resource "random_shuffle" "zone" {
  input        = data.google_compute_zones.this.names
  result_count = 1
}

resource "random_id" "this" {
  byte_length = 4
}

# Firewall rule to SSH
resource "google_compute_firewall" "iap_access_firewall" {
  project = var.project_id

  name    = substr("${var.name}-${var.project_id}-iap-${random_id.this.hex}", 0, 63)
  network = var.network_self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = local.gcp_iap_source_ranges
}

# Bastion instance
resource "google_compute_instance" "bastion" {
  project = var.project_id

  # General information
  name         = var.name
  machine_type = "f1-micro"
  zone         = local.zone

  tags = var.tags

  # Disk image
  boot_disk {
    initialize_params {
      image = data.google_compute_image.my_image.self_link
    }
  }

  network_interface {
    subnetwork = var.subnet_self_link
  }

  metadata = var.two_factor ? {
    enable-oslogin     = "true"
    enable-oslogin-2fa = "true"
    } : {
    enable-oslogin = "true"
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  metadata_startup_script = "apt update && apt upgrade"

  # Others
  labels = var.labels
}

data "google_iam_policy" "members_access" {
  binding {
    role    = "roles/compute.osLogin"
    members = var.members
  }
}

resource "google_compute_instance_iam_policy" "members_policy" {
  project       = google_compute_instance.bastion.project
  zone          = google_compute_instance.bastion.zone
  instance_name = google_compute_instance.bastion.name
  policy_data   = data.google_iam_policy.members_access.policy_data
}

data "google_iam_policy" "iap" {
  binding {
    role    = "roles/iap.tunnelResourceAccessor"
    members = var.members
  }
}

resource "google_iap_tunnel_instance_iam_policy" "iap" {
  project     = google_compute_instance.bastion.project
  zone        = google_compute_instance.bastion.zone
  instance    = google_compute_instance.bastion.name
  policy_data = data.google_iam_policy.iap.policy_data
}
