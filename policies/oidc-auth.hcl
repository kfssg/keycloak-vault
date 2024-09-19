# Allow enabling, disabling, and configuring OIDC auth
path "auth/oidc/config" {
  capabilities = ["create", "read", "update", "delete"]
}

# Allow managing OIDC roles
path "auth/oidc/role/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}