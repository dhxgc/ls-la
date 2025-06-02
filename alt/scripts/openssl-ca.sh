#!/bin/bash

# VARs
DIR="/ca"
CN="Root CA from KK"
DAYS=3650
CONF="/var/lib/ssl/openssl.cnf"

# Install OpenSSL and backup config
apt-get update && apt-get install openssl curl -y
cp ${CONF}{,.bak}

# ===== CHANGE BRANCH TO main IF IT IN main =========
curl https://raw.githubusercontent.com/dhxgc/ls-la/refs/heads/main/storage-configs/openssl.cnf > ${CONF}

# CA structure
mkdir -p ${DIR}/{certs,newcerts,crl,private}
touch ${DIR}/index.txt
echo '00' > ${DIR}/serial

# Generate private key and CSR
openssl req -new -nodes \
  -newkey rsa:4096 \
  -keyout ${DIR}/private/cakey.pem \
  -out ${DIR}/cacert.csr \
  -subj "/C=RU/CN=${CN}" \
  -config ${CONF} \
  -extensions v3_ca

# Self-sign the root certificate
openssl ca -selfsign \
  -config ${CONF} \
  -in ${DIR}/cacert.csr \
  -out ${DIR}/cacert.pem \
  -extensions v3_ca \
  -keyfile ${DIR}/private/cakey.pem \
  -cert ${DIR}/cacert.pem \
  -days ${DAYS} \
