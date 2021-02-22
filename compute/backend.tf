terraform {
 backend "gcs" {
   bucket  = "justizin-terraform-admin"
   prefix  = "terraform_compute/state"
 }
}
