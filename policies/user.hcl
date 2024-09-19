# Basic user policy allowing access to their own secrets
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

path "auth/token/renew-self" {
  capabilities = ["update"]
}

path "auth/token/revoke-self" {
  capabilities = ["update"]
}

# Grant read/write access to their application secrets
path "secret/data/my-app/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}