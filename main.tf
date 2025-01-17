resource "google_storage_bucket" "my-bucket-1701" {
  name          = "my-bucket-1701"
  location      = "US"
  force_destroy = true

  public_access_prevention = "enforced"
}