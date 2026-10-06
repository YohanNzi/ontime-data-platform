output "raw_bucket_name" {
  description = "Nom du bucket contenant les fichiers bruts."
  value       = google_storage_bucket.raw.name
}

output "bigquery_dataset_id" {
  description = "Identifiant du dataset BigQuery."
  value       = google_bigquery_dataset.ontime.dataset_id
}

output "dbt_service_account_email" {
  description = "Adresse e-mail du compte de service utilisé par dbt."
  value       = google_service_account.dbt_runner.email
}
