#!/bin/bash

# Read the certificate and key files
TLS_CERT=$(cat certs/tls.crt | base64 -w 0)
TLS_KEY=$(cat certs/tls.key | base64 -w 0)

# Replace the placeholders in the config
sed "s|\${TLS_CERT}|$TLS_CERT|g; s|\${TLS_KEY}|$TLS_KEY|g" envoy-gateway/config.yaml.template > envoy-gateway/config.yaml 