provider "google" {
  project = "moonlit-bliss-448020-r3" # Substitua pelo ID do seu projeto
  region  = "US"                      # Substitua pela região desejada
}

resource "google_project_service" "required_apis" {
  for_each = toset([
    "cloudfunctions.googleapis.com",
    "cloudbuild.googleapis.com"
  ])
  service = each.key
}

terraform {
  backend "gcs" {
    bucket = "terraform-config-1801" # Nome do bucket GCS
    prefix = "state"                 # Caminho dentro do bucket (por exemplo, "terraform/state.tfstate")
  }
}


resource "google_storage_bucket" "codes_bucket_1901" {
  project                  = "moonlit-bliss-448020-r3"
  name                     = "codes_bucket_1901"
  location                 = "us-central1"
  force_destroy            = true
  public_access_prevention = "enforced"
}

resource "google_storage_bucket_object" "source_code" {
  name   = "objects"
  bucket = google_storage_bucket.codes_bucket_1901.name
  source = "function_code.zip"
}

