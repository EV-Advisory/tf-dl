variable "billing_id" {
  type        = string
  description = "GCP billing account ID. Set in terraform.tfvars (gitignored) or via TF_VAR_billing_id."
  sensitive   = true
}

locals {
  region     = "us-west1"
  unique_id  = "eva-west"
  billing_id = var.billing_id
}
