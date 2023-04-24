module "gce-container" {
  source  = "terraform-google-modules/container-vm/google"
  version = "~> 2.0"


  container = {
    image = var.container_image
  }
  restart_policy = "Always"
}

data "google_compute_default_service_account" "default" {
}


resource "google_compute_instance" "vm" {
  project      = var.project_id
  name         = var.instance_name
  machine_type = "n1-standard-1"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = module.gce-container.source_image
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata = {
    gce-container-declaration = module.gce-container.metadata_value
    google-logging-enabled    = "true"
    google-monitoring-enabled = "true"
  }
  tags = ["http-server", "https-server"]

  labels = {
    container-vm = module.gce-container.vm_container_label
  }

  service_account {
    email = data.google_compute_default_service_account.default.email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
  allow_stopping_for_update = true
}
