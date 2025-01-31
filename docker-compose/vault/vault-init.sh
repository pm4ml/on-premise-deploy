#!/usr/bin/env sh

set -ex

unseal() {
  vault operator unseal $(grep 'Key 1:' /vault/file/keys | awk '{print $NF}')
  vault operator unseal $(grep 'Key 2:' /vault/file/keys | awk '{print $NF}')
  vault operator unseal $(grep 'Key 3:' /vault/file/keys | awk '{print $NF}')
}

init() {
  vault operator init > /vault/file/keys
}

log_in() {
   export ROOT_TOKEN=$(grep 'Initial Root Token:' /vault/file/keys | awk '{print $NF}')
   vault login "$ROOT_TOKEN"
}

create_token() {
   vault token create -id "$MY_VAULT_TOKEN"
}

enable_app_role_auth() {
  vault auth enable approle
  vault write auth/approle/role/my-role secret_id_ttl=1000m token_ttl=1000m token_max_ttl=1000m
}

generate_secret_id() {
  vault read -field role_id auth/approle/role/my-role/role-id > /vault/tmp/role-id
  vault write -field secret_id -f auth/approle/role/my-role/secret-id > /vault/tmp/secret-id
}

populate_data() {
  vault secrets enable -path=pki pki
  vault secrets enable -path=secrets kv
  vault secrets tune -max-lease-ttl=97600h pki
  vault write -field=certificate pki/root/generate/internal \
          common_name="example.com" \
          ttl=97600h
  vault write pki/config/urls \
      issuing_certificates="http://127.0.0.1:8233/v1/pki/ca" \
      crl_distribution_points="http://127.0.0.1:8233/v1/pki/crl"
  vault write pki/roles/example.com allowed_domains=example.com allow_subdomains=true allow_any_name=true allow_localhost=true enforce_hostnames=false require_cn=false max_ttl=97600h
  vault write pki/roles/client-cert-role allowed_domains=example.com allow_subdomains=true allow_any_name=true allow_localhost=true enforce_hostnames=false require_cn=false max_ttl=97600h
  vault write pki/roles/server-cert-role allowed_domains=example.com allow_subdomains=true allow_any_name=true allow_localhost=true enforce_hostnames=false require_cn=false max_ttl=97600h

  tee policy.hcl <<EOF
# List, create, update, and delete key/value secrets
path "secrets/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "kv/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "pki/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "pki_int/*"
{
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOF

  vault policy write test-policy policy.hcl
  vault write auth/approle/role/my-role policies=test-policy ttl=1h

  vault secrets enable -path=pki_int pki
  vault secrets tune -max-lease-ttl=43800h pki_int
  vault write pki_int/roles/example.com allowed_domains=example.com allow_subdomains=true allow_any_name=true allow_localhost=true enforce_hostnames=false max_ttl=600h
}

if [ -s /vault/file/keys ]; then
   unseal
   log_in
   generate_secret_id
else
   init
   unseal
   log_in
   create_token
   enable_app_role_auth
   generate_secret_id
   populate_data
fi

vault status > /vault/file/status
