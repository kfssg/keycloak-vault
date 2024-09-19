http://keycloak:8080/realms/vault-realm



create intial token


vault write auth/oidc/role/default \
    bound_audiences="vault-client" \
    allowed_redirect_uris="http://localhost:8200/ui/vault/auth/oidc/callback" \
    user_claim="sub" \
    policies="oidc-read-policy" \
    ttl="1h"