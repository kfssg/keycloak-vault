# Allow configuration and management of the OIDC authentication method
path "auth/oidc/config" {
  capabilities = ["create", "read", "update", "delete"]
}

# Allow creating and managing OIDC roles
path "auth/oidc/role/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Allow user interaction with OIDC-based login
path "auth/oidc/login" {
  capabilities = ["create", "read"]
}