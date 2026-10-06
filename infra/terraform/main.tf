resource "google_storage_bucket" "raw" {
  project  = var.project_id
  name     = "${var.project_id}-raw"
  location = var.region

  uniform_bucket_level_access = true
  force_destroy               = true

  labels = {
    projet = "ontime"
    env    = "sprint"
  }
}

resource "google_bigquery_dataset" "ontime" {
  project    = var.project_id
  dataset_id = "ontime"
  location   = var.region

  delete_contents_on_destroy = true

  labels = {
    projet = "ontime"
    env    = "sprint"
  }
}

resource "google_service_account" "dbt_runner" {
  project      = var.project_id
  account_id   = "dbt-runner"
  display_name = "Compte de service dbt"
}

# Autorise la modification des données uniquement dans le dataset ontime.
resource "google_bigquery_dataset_iam_member" "dbt_data_editor" {
  project    = google_bigquery_dataset.ontime.project
  dataset_id = google_bigquery_dataset.ontime.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = "serviceAccount:${google_service_account.dbt_runner.email}"
}

# Autorise la création de jobs BigQuery dans le projet.
resource "google_project_iam_member" "dbt_job_user" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.dbt_runner.email}"
}

resource "google_service_account_iam_member" "dbt_impersonation" {
  service_account_id = google_service_account.dbt_runner.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "user:yohannzi.pro@gmail.com"
}
