provider "google" {
  project = "moonlit-bliss-448020-r3" # Substitua pelo ID do seu projeto
  region  = "US"                      # Substitua pela região desejada
}

resource "google_project_service" "cloud_functions" {
  service = "cloudfunctions.googleapis.com"
}