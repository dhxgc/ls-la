#!/bin/bash

# Script to create and sign a certificate on the CA (no external requests)
# Uses openssl.cnf from current directory, adjust paths if needed

set -e

CN="$1"
OUT_DIR="$2"

if [ -z "$CN" ]; then
  echo "Usage: $0 <common_name>"
  exit 1
fi

# Paths (adjust to your setup)
OPENSSL_CNF="/var/lib/ssl/openssl.cnf"
CA_DIR="/ca"
CA_CERT="$CA_DIR/cacert.pem"
CA_KEY="$CA_DIR/private/cakey.pem"

mkdir -p "$OUT_DIR"

KEY_FILE="$OUT_DIR/${CN}.key"
CSR_FILE="$OUT_DIR/${CN}.csr"
CERT_FILE="$OUT_DIR/${CN}.crt"
P12_FILE="$OUT_DIR/${CN}.p12"


echo "1. Generating client private key: $KEY_FILE"
openssl genrsa -out "$KEY_FILE" 2048

echo "2. Creating CSR with CN=$CN: $CSR_FILE"
openssl req -new -key "$KEY_FILE" -out "$CSR_FILE" -subj "/CN=$CN"

echo "3. Signing CSR with root CA"
openssl ca -config "$OPENSSL_CNF" -in "$CSR_FILE" -out "$CERT_FILE" -batch -extensions usr_cert

echo "4. Creating PKCS#12 package: $P12_FILE"
openssl pkcs12 -export -inkey "$KEY_FILE" -in "$CERT_FILE" -certfile "$CA_CERT" -out "$P12_FILE" -password p>

echo "Done! Files saved in $OUT_DIR:"
echo " - Private key: $KEY_FILE"
echo " - CSR: $CSR_FILE"
echo " - Certificate: $CERT_FILE"
echo " - PKCS#12 bundle: $P12_FILE (password: 1234)"
