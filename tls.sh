#!/bin/bash

# cat <<EOF | cfssl genkey - | cfssljson -bare tls
cat <<EOF | cfssl gencert -initca - | cfssljson -bare ca
{
  "CN": "localhost",
  "hosts": [
    "localhost",
    "127.0.0.1"
  ],
  "key": {
    "algo": "ecdsa",
    "size": 256
  }
}
EOF

echo '{"key":{"algo":"ecdsa","size":256}}' | cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=cfssl.json \
  -hostname="localhost,127.0.0.1,server.dc0.consul,client.dc0.consul" - | cfssljson -bare tls

mkdir -p /c/etc/ssl/private
mkdir -p /c/etc/ssl/certs

cp ca-key.pem /c/etc/ssl/private
cp ca.pem /c/etc/ssl/certs

cp tls-key.pem /c/etc/ssl/private
cp tls.pem /c/etc/ssl/certs

export MSYS2_ARG_CONV_EXCL="*"
scp tls-key.pem root@$SERVER:/etc/ssl/private
scp tls.pem root@$SERVER:/etc/ssl/certs

scp ca-key.pem root@$SERVER:/etc/ssl/private
scp ca.pem root@$SERVER:/etc/ssl/certs

ssh -qt root@$SERVER chown consul:consul /etc/ssl/private/tls-key.pem
ssh -qt root@$SERVER chown consul:consul /etc/ssl/private/ca-key.pem

ssh -qt root@$SERVER chmod 755 /etc/ssl/private
ssh -qt root@$SERVER chmod 640 /etc/ssl/private/tls-key.pem
ssh -qt root@$SERVER chmod 640 /etc/ssl/private/ca-key.pem

# go get -u github.com/cloudflare/cfssl/cmd/cfssljson
# go get -u github.com/cloudflare/cfssl/cmd/cfssl
# cfssl print-defaults csr
