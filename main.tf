terraform {
  required_version = ">= 0.12.0"
}

provider "google" {
  credentials = file("${var.credentials}")
  project     = var.project
  region      = var.region
  zone        = var.circleci_zone
}

resource "google_compute_firewall" "circleci-services-firewall-ingress" {
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

resource "google_compute_firewall" "circleci-services-firewall-egress" {
  name      = "circleci-services-firewall-egress"
  network   = var.circleci_network_name
  direction = "EGRESS"

  # End users & Github
  allow {
    protocol = "tcp"
    ports    = ["80", "443", "7171", "8081"]
  }

  # Nomad Clients
  allow {
    protocol = "tcp"
    ports    = ["3001", "4647", "8585"]
  }
}

resource "google_compute_firewall" "circleci-nomad-client-firewall-ingress" {
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

resource "google_compute_firewall" "circleci-nomad-client-firewall-egress" {
  name      = "circleci-nomad-client-firewall-egress"
  network   = var.circleci_network_name
  direction = "EGRESS"

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

#
# The templatefile function bellow in theory would allow to forward environment variables.
# This would be ideal to programmatically get and store the Services IP address needed
# for the nomad client setup. Hashicorp currently has issues with rendering template files
# on Terraform 0.12+ https://github.com/terraform-providers/terraform-provider-template/issues/63
#
# data "template_file" "nomad" {
#   template = templatefile("./scripts/provision-nomad-client-ubuntu.sh", { nomad-server = google_compute_instance.circleci-services.network_interface.0.network_ip })
# }

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
