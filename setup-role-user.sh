#!/bin/bash
export VAULT_ADDR="http://localhost:8200" 
# Variables (replace these with your actual values)
KEYCLOAK_ADMIN_USER="admin"
KEYCLOAK_ADMIN_PASSWORD="admin"
KEYCLOAK_URL="http://localhost:8080"  # Use localhost for accessing Keycloak from local network
KEYCLOAK_REALM="vault-realm"
OIDC_CLIENT_ID="vault-client"

VAULT_ADDR="http://localhost:8200"  # Local network access to Vault
VAULT_TOKEN="root"
USER_NAME="test-user"
USER_PASSWORD="password123"

# Step 1: Authenticate to Keycloak and get access token
echo "Authenticating to Keycloak..."
KC_ACCESS_TOKEN=$(curl -s --data "grant_type=password&client_id=admin-cli&username=$KEYCLOAK_ADMIN_USER&password=$KEYCLOAK_ADMIN_PASSWORD" \
    "$KEYCLOAK_URL/realms/master/protocol/openid-connect/token" | jq -r '.access_token')

if [ -z "$KC_ACCESS_TOKEN" ]; then
  echo "Failed to authenticate to Keycloak."
  exit 1
fi

# Step 2: Create a test user in Keycloak
echo "Creating test user: $USER_NAME..."
curl -s -X POST "$KEYCLOAK_URL/admin/realms/$KEYCLOAK_REALM/users" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $KC_ACCESS_TOKEN" \
  -d '{
  "username": "'"$USER_NAME"'",
  "enabled": true,
  "credentials": [{
    "type": "password",
    "value": "'"$USER_PASSWORD"'",
    "temporary": false
  }]
}'

# Step 3: Login to Vault
vault login "$VAULT_TOKEN"

# Step 4: Create a policy to allow reading secrets
echo "Creating 'oidc-read-policy' policy..."
vault policy write oidc-read-policy - <<EOF
path "secret/*" {
  capabilities = ["read"]
}
EOF

# Step 5: Create the OIDC role with the policy
echo "Creating OIDC role 'default'..."
vault write auth/oidc/role/default \
    bound_audiences="$OIDC_CLIENT_ID" \
    allowed_redirect_uris="$VAULT_ADDR/ui/vault/auth/oidc/callback" \
    user_claim="sub" \
    policies="oidc-read-policy" \
    ttl="1h"

# Step 6: Write a test secret
echo "Writing a test secret..."
vault kv put secret/my-secret value="This is a test secret."

# Step 7: Output details for test user login
echo "Test user created:"
echo "Username: $USER_NAME"
echo "Password: $USER_PASSWORD"
echo "Login at: $VAULT_ADDR/ui"
echo "Use OIDC method to log in."

echo "Setup complete!"