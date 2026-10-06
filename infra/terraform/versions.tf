terraform {
  required_version = ">= 1.16"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 8.5" # dernière version au 06/10 : 8.5.0
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
