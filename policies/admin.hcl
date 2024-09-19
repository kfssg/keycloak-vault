# Allow full access to all secrets
path "secret/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Allow managing authentication methods
path "auth/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Allow managing policies
path "sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Allow managing tokens
path "auth/token/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}