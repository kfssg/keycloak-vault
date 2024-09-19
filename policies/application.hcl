# Allow application to read its secrets
path "secret/data/app-secrets/*" {
  capabilities = ["read"]
}

# Allow application to renew its own token
path "auth/token/renew-self" {
  capabilities = ["update"]
}

# Allow application to lookup its own token
path "auth/token/lookup-self" {
  capabilities = ["read"]
}