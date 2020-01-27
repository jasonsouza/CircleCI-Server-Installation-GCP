provider "google" {
  credentials = file("${var.credentials}")
  project     = var.project
  region      = var.region
  zone        = var.circleci_zone
}

resource "google_compute_firewall" "circleci-services-firewall" {
  name    = "circleci-services-firewall"
  network = var.circleci_network_name

  # End users & Github
  allow {
    protocol = "tcp"
    ports    = ["80", "443", "7171", "8081"]
  }

  # Administrators
  allow {
    protocol = "tcp"
    ports    = ["22", "8800"]
  }

  # Nomad Clients
  allow {
    protocol = "tcp"
    ports    = ["3001", "4647", "8585"]
  }
}

resource "google_compute_firewall" "circleci-nomad-client-firewall" {
  name    = "circleci-nomad-client-firewall"
  network = var.circleci_network_name

  # Administrators
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  # End Users
  allow {
    protocol = "tcp"
    ports    = ["64535-65535"]
  }

  # VM Services
  allow {
    protocol = "tcp"
    ports    = ["4647", "8585", "7171", "3001"]
  }

}


resource "google_compute_instance" "circleci-services" {
  name         = "circleci-services"
  machine_type = var.services_machine_type

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = var.default_image
      size  = 100
    }
  }
  metadata_startup_script = file("./scripts/provision-services-ubuntu.sh")

  network_interface {
    network    = var.circleci_network_name
    subnetwork = var.subnet_name

    access_config {
      // ephemeral IP
    }
  }
}

resource "google_compute_instance" "circleci-nomad-client" {
  name         = "circleci-nomad-client"
  machine_type = var.services_machine_type

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = var.default_image
      size  = 100
    }
  }
  metadata_startup_script = file("./scripts/provision-nomad-client-ubuntu.sh")

  network_interface {
    network    = var.circleci_network_name
    subnetwork = var.subnet_name

    access_config {
      // ephemeral IP
    }
  }
}
