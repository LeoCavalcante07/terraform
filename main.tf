terraform {
  backend "gcs" {
    bucket = "terraform-config-1801test"     # Nome do bucket GCS
    prefix = "state"  # Caminho dentro do bucket (por exemplo, "terraform/state.tfstate")
  }
}

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

resource "google_cloudfunctions_function" "func_1_test" {
  name                  = "func_1_test"
  description           = "My function TF"
  runtime               = "python39"
  region                = "us-central1"
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.codes_bucket_1901.name
  source_archive_object = google_storage_bucket_object.source_code.name
  trigger_http          = true
  entry_point           = "hello_http"
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.func_1_test.project
  region         = google_cloudfunctions_function.func_1_test.region
  cloud_function = google_cloudfunctions_function.func_1_test.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}