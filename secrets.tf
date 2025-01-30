resource "aws_secretsmanager_secret" "firebase_service_account" {
  name = "${var.project_name}-firebase-service-account-${terraform.workspace}"
  description = "Firebase service account credentials for authentication"
}

resource "aws_secretsmanager_secret_version" "firebase_service_account" {
  secret_id     = aws_secretsmanager_secret.firebase_service_account.id
  secret_string = jsonencode({
    type = "service_account",
    project_id = var.firebase_project_id,
    private_key_id = var.firebase_private_key_id,
    private_key = var.firebase_private_key,
    client_email = var.firebase_client_email,
    client_id = var.firebase_client_id,
    auth_uri = var.firebase_auth_uri,
    token_uri = var.firebase_token_uri,
    auth_provider_x509_cert_url = var.firebase_auth_provider_x509_cert_url,
    client_x509_cert_url = var.firebase_client_x509_cert_url,
    universe_domain = var.firebase_universe_domain
  })
} 