variable "region" {
  description = "Region to setup infrastructure"
  default     = "europe-central2"
  
}

variable "credentials_file" {
  description = "Path to the JSON file used to describe your account credentials"
  default     = "gcp_creds.json"
}

provider "google" {
  project     = "cedar-bot-406923"
  region      = var.region
  credentials = file(var.credentials_file)
}

resource "google_compute_network" "k8s_cluster_network" {
  name                    = "k8s-cluster-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "k8s_subnet" {
  name          = "k8s-subnet"
  ip_cidr_range = "10.240.0.0/24"
  network       = google_compute_network.k8s_cluster_network.self_link
  region = var.region
}

resource "google_compute_firewall" "k8s_subnet_allow_internal" {
  name    = "k8s-subnet-allow-internal"
  network = google_compute_network.k8s_cluster_network.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }

  source_ranges = ["10.240.0.0/24"]
}

resource "google_compute_firewall" "k8s_subnet_allow_external" {
  name    = "k8s-subnet-allow-external"
  network = google_compute_network.k8s_cluster_network.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "6443", "443", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "k8s_master_0_public_ip" {
  name = "k8s-master-0-public-ip"
}

resource "google_compute_instance" "master" {
  name         = "master-0"
  machine_type = "e2-standard-2"
  zone = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-lts"
      size = 200
    }
  }

  network_interface {
    network = google_compute_network.k8s_cluster_network.self_link
    subnetwork = google_compute_subnetwork.k8s_subnet.self_link
    access_config {
      nat_ip = google_compute_address.k8s_master_0_public_ip.address
    }
  }

  metadata = {
    ssh-keys = "es:${file("${path.module}/id_rsa.pub")}"
  }

  can_ip_forward = true

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/service.management",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  tags = ["k8s-instance", "worker"]
}

resource "google_compute_address" "worker_public_ip" {
  count = 2
  name  = "worker-${count.index}-public-ip"
}

resource "google_compute_instance" "worker" {
  count        = 2
  name         = "worker-${count.index}"
  machine_type = "e2-standard-2"
  zone = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-lts"
      size = 200
    }
  }

  network_interface {
    network = google_compute_network.k8s_cluster_network.self_link
    subnetwork = google_compute_subnetwork.k8s_subnet.self_link
    access_config {
      nat_ip = google_compute_address.worker_public_ip[count.index].address
    }
  }

  can_ip_forward = true

  metadata = {
    ssh-keys = "es:${file("${path.module}/id_rsa.pub")}"
  }

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/service.management",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform",
    ] 
  }

  tags = ["k8s-instance", "worker"]
}