resource "google_storage_bucket" "my-bucket-1701" {
  project       = "moonlit-bliss-448020-r3"
  name          = "my-bucket-1701"
  location      = "US"
  force_destroy = true

  public_access_prevention = "enforced"
}