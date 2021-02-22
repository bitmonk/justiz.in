variable "google_project_id" {}

data "google_compute_zones" "available" {
  project = var.google_project_id
}

resource "google_compute_instance" "default" {
  project      = var.google_project_id
  zone         = data.google_compute_zones.available.names[0]
  name         = "tf-compute-1"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-1604-xenial-v20170328"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
  # not sure how to refer to this resource in another tf project
  # split things out and this is now in ../project/main.tf
  # depends_on = [google_project_service.service]
}

output "instance_id" {
  value = google_compute_instance.default.self_link
}

output "ip_address" {
  value = google_compute_instance.default.network_interface.0.network_ip
}