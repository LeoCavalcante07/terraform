resource "google_storage_bucket" "my-bucket-1801_2" {
  project       = "moonlit-bliss-448020-r3"
  name          = "my-bucket-1801_2"
  location      = "US"
  force_destroy = true

  public_access_prevention = "enforced"
}