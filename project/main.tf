variable "project_name" {}
variable "billing_account" {}
variable "org_id" {}
variable "region" {}
variable "iam_admin" {}

provider "google" {
  region = var.region
}

resource "random_id" "id" {
  byte_length = 4
  prefix      = var.project_name
}

resource "google_project" "project" {
  name            = var.project_name
  project_id      = random_id.id.hex
  billing_account = var.billing_account
  org_id          = var.org_id
}

resource "google_project_service" "service" {
  for_each = toset([
    "compute.googleapis.com"
  ])

  service = each.key

  project            = google_project.project.project_id
  disable_on_destroy = false
}

resource "google_project_iam_binding" "admin" {
  project            = google_project.project.project_id
  role               = "roles/compute.admin"

  members = [
    var.iam_admin
  ]
}

output "project_id" {
  value = google_project.project.project_id
}