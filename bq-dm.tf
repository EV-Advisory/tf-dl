# Data warehouse
resource "google_bigquery_dataset" "dwh-bq-marketing" {
  dataset_id                  = "CURATED"
  description                 = ""
  project = google_project.data-marts.project_id
  location                    = local.region
  depends_on = [google_project_service.data-marts-service] 
  # Order of access matters
  # WRITER -> OWNER -> READER
#   access {
#     role          = "WRITER"
#     group_by_email = "${local.unique_id}-ds@gmail.com"
#   }
#   access {
#     role           = "OWNER"
#     group_by_email = "${local.unique_id}-de@gmail.com"
#   }
#   access {
#     role           = "READER"
#     group_by_email = "${local.unique_id}-da@gmail.com"
#   }
}
