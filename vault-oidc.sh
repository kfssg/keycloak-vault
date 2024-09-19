#!/bin/bash

# Enable debug mode for better traceability
set -x  # Print commands and their arguments as they are executed

# Set Vault and Keycloak parameters
export VAULT_ADDR="http://localhost:8200"  # Exporting Vault address for global access in this script
VAULT_TOKEN="root"  # Vault token (use secure storage for production)
OIDC_CLIENT_ID="vault-client"
OIDC_CLIENT_SECRET="vault-client-secret"  # Replace with your actual client secret
KEYCLOAK_REALM="vault-realm"
KEYCLOAK_URL="http://172.20.0.3:8080"  # Use the IP address of Keycloak container

# Step 1: Validate Keycloak OIDC Discovery URL (Debug Step)
#echo "Validating OIDC discovery URL..."
curl -v "http://localhost:8080/auth/realms/$KEYCLOAK_REALM/.well-known/openid-configuration"  # Fetch OIDC discovery metadata
#curl -v "http://localhost:8080/auth/realms/vault-realm/.well-known/openid-configuration" 
# Step 2: Enable OIDC authentication in Vault
echo "Enabling OIDC authentication in Vault..."
vault login "$VAULT_TOKEN"  # Log in to Vault with the root token
vault auth enable oidc  # Enable OIDC authentication in Vault

# Step 3: Configure Vault to use Keycloak as OIDC provider
echo "Configuring OIDC provider in Vault..."
vault write auth/oidc/config \
    oidc_discovery_url="$KEYCLOAK_URL/auth/realms/$KEYCLOAK_REALM" \
    oidc_client_id="$OIDC_CLIENT_ID" \
    oidc_client_secret="$OIDC_CLIENT_SECRET" \
    default_role="default" || echo "Failed to configure OIDC. Check discovery URL and network connectivity."

# Step 4: Create a Vault role for OIDC authentication
echo "Creating Vault role for OIDC authentication..."
vault write auth/oidc/role/default \
    bound_audiences="$OIDC_CLIENT_ID" \
    allowed_redirect_uris="$VAULT_ADDR/ui/vault/auth/oidc/callback" \
    user_claim="sub" \
    policies="default" \
    ttl="1h"

echo "Vault OIDC configuration complete!"