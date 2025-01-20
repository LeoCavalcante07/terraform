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


resource "google_storage_bucket" "codes_bucket_1901_v2" {
  project                  = "moonlit-bliss-448020-r3"
  name                     = "codes_bucket_1901_v2"
  location                 = "us-central1"
  force_destroy            = true
  public_access_prevention = "enforced"
}

resource "google_storage_bucket_object" "source_code_v2" {
  name   = "objects"
  bucket = google_storage_bucket.codes_bucket_1901_v2.name
  source = "function_code.zip"
}

#==================================CLOUD FUNCTIONS==================================

resource "google_cloudfunctions_function" "func_2_test" {
  name                  = "func_2_test"
  description           = "My function TF"
  runtime               = "python39"
  region                = "us-central1"
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.codes_bucket_1901_v2.name
  source_archive_object = google_storage_bucket_object.source_code_v2.name
  trigger_http          = true
  entry_point           = "hello_http"
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member_v2" "invoker" {
  project        = google_cloudfunctions_function.func_1_test.project
  region         = google_cloudfunctions_function.func_1_test.region
  cloud_function = google_cloudfunctions_function.func_1_test.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

#==================================COMPUTE ENGINE==================================
resource "google_compute_instance" "default" {
  name         = "my-instance_using_tf"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"

  }
}