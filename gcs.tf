# GCS resources
resource "google_storage_bucket" "gcs-data-lake-landing" {
  name          = "${google_project.data-lake.project_id}-landing"
  project	    = google_project.data-lake.project_id
  location      = local.region
  force_destroy = true
  storage_class = "STANDARD"
}

resource "google_storage_bucket" "gcs-data-lake-sensitive" {
  name          = "${google_project.data-lake.project_id}-sensitive"
  project	    = google_project.data-lake.project_id
  location      = local.region
  force_destroy = true
  storage_class = "STANDARD"
}

resource "google_storage_bucket" "gcs-data-lake-work" {
  name          = "${google_project.data-lake.project_id}-work"
  project	    = google_project.data-lake.project_id
  location      = local.region
  force_destroy = true
  storage_class = "STANDARD"
}

resource "google_storage_bucket" "gcs-data-lake-backup" {
  name          = "${google_project.data-lake.project_id}-backup"
  project	    = google_project.data-lake.project_id
  location      = local.region
  force_destroy = true
  storage_class = "STANDARD"
}
