# Sample IAM permission
module "project_iam_binding" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam/"
  projects = [google_project.data-lake.project_id]
  mode     = "additive"
  bindings = {
    # Bigquery 
    "roles/bigquery.admin" = ["user:info@evadvisory.ca"]
    # GCS
    "roles/storage.admin" = ["user:info@evadvisory.ca"]
    # Compute
    "roles/compute.admin" = ["user:info@evadvisory.ca"]
  }
}