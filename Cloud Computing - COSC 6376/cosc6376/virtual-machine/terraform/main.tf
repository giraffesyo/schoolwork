resource "google_compute_instance_template" "nodejs_app_template" {
  name_prefix  = "nodejs-app-template-"
  machine_type = "f1-micro"

  disk {
    source_image = "nodejs-app"
    auto_delete  = true
    boot         = true

  }


  metadata = {}

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance_group_manager" "nodejs_app_group" {
  name               = "nodejs-app-group"
  base_instance_name = "nodejs-app"
  zone               = var.zone

  version {
    instance_template = google_compute_instance_template.nodejs_app_template.self_link
  }

  target_size = 1
}
