#!/bin/bash

# Set Keycloak credentials
KEYCLOAK_URL="http://localhost:8080"
KEYCLOAK_ADMIN_USER="admin"
KEYCLOAK_ADMIN_PASSWORD="admin"
REALM_NAME="vault-realm"
CLIENT_ID="vault-client"
CLIENT_SECRET="vault-client-secret"
REDIRECT_URI="http://localhost:8200/ui/vault/auth/oidc/callback"

# Step 1: Get admin token
echo "Getting admin token..."
TOKEN=$(curl -s --data "grant_type=password&client_id=admin-cli&username=$KEYCLOAK_ADMIN_USER&password=$KEYCLOAK_ADMIN_PASSWORD" \
  "$KEYCLOAK_URL/realms/master/protocol/openid-connect/token" | jq -r '.access_token')

if [ -z "$TOKEN" ]; then
  echo "Failed to retrieve admin token"
  exit 1
fi

# Step 2: Create the Vault realm
echo "Creating realm: $REALM_NAME..."
curl -s -X POST "$KEYCLOAK_URL/admin/realms" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
  "realm": "'"$REALM_NAME"'",
  "enabled": true
}'

# Step 3: Create OIDC client for Vault
echo "Creating client: $CLIENT_ID in realm $REALM_NAME..."
curl -s -X POST "$KEYCLOAK_URL/admin/realms/$REALM_NAME/clients" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
  "clientId": "'"$CLIENT_ID"'",
  "secret": "'"$CLIENT_SECRET"'",
  "redirectUris": ["'"$REDIRECT_URI"'"],
  "enabled": true,
  "protocol": "openid-connect",
  "publicClient": false,
  "directAccessGrantsEnabled": true,
  "standardFlowEnabled": true
}'

echo "Vault realm and client setup complete!"