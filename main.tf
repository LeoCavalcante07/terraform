resource "google_storage_bucket" "my-bucket-1801_3" {
  project       = "moonlit-bliss-448020-r3"
  name          = "my-bucket-1801_3"
  location      = "US"
  force_destroy = true

  public_access_prevention = "enforced"
}

resource "google_storage_bucket" "my-bucket-1801_4" {
  project       = "moonlit-bliss-448020-r3"
  name          = "my-bucket-1801_4"
  location      = "US"
  force_destroy = true

  public_access_prevention = "enforced"
}