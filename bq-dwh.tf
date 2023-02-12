# Data warehouse
resource "google_bigquery_dataset" "dwh-bq-system1" {
  dataset_id                  = "SYSTEM1"
  description                 = ""
  project                     = google_project.data-warehouse.project_id
  location                    = local.region
  depends_on                  = [google_project_service.data-warehouse-service]
}
