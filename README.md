# Data Lake Infrastructure
This repository contains Terraform code to create a data lake infrastructure across multiple GCP projects. The infrastructure consists of the following components:  

- Four GCS buckets: `landing`, `work`, `sensitive`, and `backup`  
- A GCE instance to orchestrate data processing and ETL jobs  
- A BigQuery instance for the data warehouse  
- A BigQuery instance for the data mart  
- IAM bindings to grant access to the infrastructure  

The data lake is split across three GCP projects: data-lake, data-warehouse, and data-marts. The code is organized into separate Terraform modules for each component.  

### Requirements  
- Terraform 0.12 or higher  
- Google Cloud SDK  

### Usage  
  
1. Clone the repository and navigate to the root directory.  
2. Create a `variables.tf` file with the following contents:  
```{tf}
locals {
  region = "<region-id>"
  unique_id = "<prefix-id>"
  billing_id = "<billing-id>"
}
```  

3. Run the following command to initialize the Terraform modules:
```{tf}
terraform init  
```  
4. Run the following command to create the infrastructure:  
```{tf}  
terraform apply  
```  
5. Once the infrastructure has been created, you can run the following command to destroy it:  
```{tf}  
terraform destroy  
```  
### Module Descriptions  

- `variables.tf`: Defines the variables used in the project.  
- `main.tf`: Contains the provider information for Google Cloud.   
- `project.tf`: Defines the Google Cloud projects to use.  
- `gcs.tf`: Defines the Google Cloud Storage buckets for the data lake.  
- `gce.tf`: Defines the Google Compute Engine instance for orchestration.  
- `bq-dwh.tf`: Defines the BigQuery instance for the data warehouse.  
- `bq-dm.tf`: Defines the BigQuery instance for the data mart.  
- `iam.tf`: Defines the IAM bindings for the infrastructure.  

### Author  
[Esteban Valencia](mailto:info@evadvisory.ca)