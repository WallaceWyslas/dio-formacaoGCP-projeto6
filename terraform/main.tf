terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }

   backend "gcs" {
    bucket  = "walwysterra"
    prefix  = "terraform/state"
  }
  
}

provider "google" {
  project = "walwys-devops-iac"
  credentials = "${file("walwys-devops-iac.json")}"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_project_service" "serviceusage" {
  project = "walwys-devops-iac"
  service = "serviceusage.googleapis.com"
  disable_dependent_services = true
}

resource "google_compute_instance" "vm_instance" {
  name         = "cloudbbuildterraform"
  machine_type = "e2-micro"
  zone    = "us-central1-a"
  tags = ["prod"]

  labels = {
    centro_custo = "${var.centro_custo_rh}"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}

resource "google_compute_network" "vpc_network" {
  name = "${var.network_name}"
}