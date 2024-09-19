# Allow read-only access to their own secrets
path "secret/data/my-app/*" {
  capabilities = ["read", "list"]
}

# Allow token lookup and renewal for the user
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

path "auth/token/renew-self" {
  capabilities = ["update"]
}