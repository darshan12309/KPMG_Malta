 provider "google" {
  project = "protean-brook-382610"
  region  = "us-central1"
   credentials = "key.json"
}

resource "google_compute_network" "vpc_network" {
  name                    = "my-vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "web_subnet" {
  name          = "web-subnet"
  network       = google_compute_network.vpc_network.self_link
  ip_cidr_range = "10.0.1.0/24"
}

resource "google_compute_subnetwork" "app_subnet" {
  name          = "app-subnet"
  network       = google_compute_network.vpc_network.self_link
  ip_cidr_range = "10.0.2.0/24"
}

resource "google_compute_subnetwork" "db_subnet" {
  name          = "db-subnet"
  network       = google_compute_network.vpc_network.self_link
  ip_cidr_range = "10.0.3.0/24"
}

resource "google_compute_firewall" "web_fw" {
  name    = "web-fw"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "app_fw" {
  name    = "app-fw"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  source_ranges = ["${google_compute_subnetwork.web_subnet.ip_cidr_range}"]
}

resource "google_compute_firewall" "db_fw" {
  name    = "db-fw"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["3306"]
  }
  source_ranges = ["${google_compute_subnetwork.app_subnet.ip_cidr_range}"]
}

resource "google_compute_instance" "web" {
  name         = "web-1"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.web_subnet.self_link
    access_config {
    }
  }
}

resource "google_compute_instance" "app" {
  name         = "app-1"
  machine_type = "n1-standard-2"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.app_subnet.self_link
    access_config {
    }
  }
}

resource "google_compute_instance" "db" {
  name         = "db-1"
  machine_type = "db-n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "cloudsql/mysql-8"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.db_subnet.self_link
    access_config {
    }
  }
}
