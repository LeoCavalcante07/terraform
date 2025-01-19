resource "google_storage_bucket" "codes_bucket" {
  project                  = "moonlit-bliss-448020-r3"
  name                     = "codes_bucket"
  location                 = "US"
  force_destroy            = true
  public_access_prevention = "enforced"
}

resource "google_storage_bucket_object" "source_code" {
  name   = "index.zip"
  bucket = google_storage_bucket.bucket.name
  source = "index.zip"
}

resource "google_cloudfunctions_function" "func_1_test" {
  name        = "func_1_test"
  description = "My function TF"
  runtime     = "python39"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  entry_point           = "hello_http"
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}