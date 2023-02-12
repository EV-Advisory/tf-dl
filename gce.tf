# Create VPC network
resource "google_compute_network" "vpc-network" {
  project = google_project.data-lake.project_id
  name = "vpc-network"
  depends_on = [google_project_service.data-lake-service]
}

# Create static external IP address
resource "google_compute_address" "orchestration-ip-static" {
  project = google_project.data-lake.project_id
  region = local.region
  name = "${local.unique_id}-external-ip"
  depends_on = [google_project_service.data-lake-service]
}

# Create orchestration instance
resource "google_compute_instance" "orchestration" {
  project      = google_project.data-lake.project_id
  zone         = "${local.region}-a"
  name         = "orchestration"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size = 100
    }
  }
  network_interface {
    network = google_compute_network.vpc-network.name
    access_config {
      nat_ip = google_compute_address.orchestration-ip-static.address
    }
    
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo su
    apt-get update
    apt-get install -y gnupg2 software-properties-common
    apt-get update
    apt-get install -y r-base
    apt-get install -y libssl-dev libcurl4-openssl-dev libxml2-dev tesseract-ocr imagemagick
    su - ubuntu -c "R -e 'install.packages(\"remotes\")'"
    su - ubuntu -c "R -e 'remotes::install_version(\"rvest\", \"1.0.3\")'"
  EOF

  depends_on = [
    google_project_service.data-lake-service,
    google_compute_address.orchestration-ip-static,
    google_compute_network.vpc-network
  ]
}

# Create firewall rule allowing TCP traffic on port 22
resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc-network.name
  project = google_project.data-lake.project_id
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]

  depends_on = [google_compute_network.vpc-network]
}
