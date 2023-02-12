# Create VPC network
resource "google_compute_network" "vpc-network" {
  project     = google_project.data-lake.project_id  # GCP project ID
  name        = "vpc-network"  # Name of the VPC network
  depends_on  = [google_project_service.data-lake-service]  # Ensure project services are enabled before creating network
}

# Create static external IP address
resource "google_compute_address" "orchestration-ip-static" {
  project     = google_project.data-lake.project_id  # GCP project ID
  region      = local.region  # GCP region
  name        = "${local.unique_id}-external-ip"  # Name of the static external IP address
  depends_on  = [google_project_service.data-lake-service]  # Ensure project services are enabled before creating external IP
}

# Create orchestration instance
resource "google_compute_instance" "orchestration" {
  project      = google_project.data-lake.project_id  # GCP project ID
  zone         = "${local.region}-a"  # GCP zone
  name         = "orchestration"  # Name of the GCE instance
  machine_type = "e2-micro"  # Machine type to use for the instance

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"  # Boot disk image
      size  = 100  # Boot disk size in GB
    }
  }

  network_interface {
    network = google_compute_network.vpc-network.name  # Name of the VPC network
    access_config {
      nat_ip = google_compute_address.orchestration-ip-static.address  # Assign the static external IP address
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo su  # Switch to superuser
    apt-get update  # Update package lists
    apt-get install -y gnupg2 software-properties-common  # Install required packages
    apt-get update  # Update package lists again
    apt-get install -y r-base  # Install R programming language
    apt-get install -y libssl-dev libcurl4-openssl-dev libxml2-dev tesseract-ocr imagemagick  # Install dependencies for rvest
    su - ubuntu -c "R -e 'install.packages(\"remotes\")'"  # Install remotes package
    su - ubuntu -c "R -e 'remotes::install_version(\"rvest\", \"1.0.3\")'"  # Install rvest package
  EOF

  depends_on = [
    google_project_service.data-lake-service,
    google_compute_address.orchestration-ip-static,
    google_compute_network.vpc-network
  ]
}

# Create firewall rule allowing TCP traffic on port 22
resource "google_compute_firewall" "allow-ssh" {
  name          = "allow-ssh"  # Name of the firewall rule
  network       = google_compute_network.vpc-network.name  # Name of the VPC network
  project       = google_project.data-lake.project_id  # GCP project ID
  allow {
    protocol = "tcp"  # Allow TCP traffic
    ports    = ["22"]  # Allow traffic on port 22 (SSH)
  }
  source_ranges = ["0.0.0.0/0"]  # Allow traffic from any IP address
  depends_on    = [google_compute_network.vpc-network]  # Ensure network is created before creating firewall rule
}
