#!/bin/bash
case ${1-0} in
0)
  cat <<EOF | cfssl gencert -initca - | cfssljson -bare ca
{
  "CN": "root",
  "key": {
    "algo": "ecdsa",
    "size": 256
  }
}
EOF
  echo '{"CN": "localhost","key":{"algo":"ecdsa","size":256}}' | cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=cfssl.json \
    -hostname="localhost,127.0.0.1" - | cfssljson -bare tls
  exit
  ;;
i)
  mkdir -p /etc/ssl/private
  mkdir -p /etc/ssl/certs
  cp ca-key.pem /etc/ssl/private
  cp ca.pem /etc/ssl/certs
  cp tls-key.pem /etc/ssl/private
  cp tls.pem /etc/ssl/certs

  scp tls-key.pem root@$SERVER:/etc/ssl/private
  scp tls.pem root@$SERVER:/etc/ssl/certs
  scp ca-key.pem root@$SERVER:/etc/ssl/private
  scp ca.pem root@$SERVER:/etc/ssl/certs
  # ssh -qt root@$SERVER chown tls:tls /etc/ssl/private/tls-key.pem
  # ssh -qt root@$SERVER chown tls:tls /etc/ssl/private/ca-key.pem
  ssh -qt root@$SERVER chmod 755 /etc/ssl/private
  ssh -qt root@$SERVER chmod 640 /etc/ssl/private/tls-key.pem
  ssh -qt root@$SERVER chmod 640 /etc/ssl/private/ca-key.pem
  exit
  ;;
esac

# go get -u github.com/cloudflare/cfssl/cmd/cfssljson
# go get -u github.com/cloudflare/cfssl/cmd/cfssl
# cfssl print-defaults csr
# cat > ca-csr.json <<EOF
# cat <<EOF | cfssl genkey - | cfssljson -bare tls
# openssl x509 -in ca.pem -text -noout

# "hosts": [
#   "localhost",
#   "127.0.0.1"
# ],

# "names": [
#   {
#     "O": "etcd",
#     "OU": "etcd Security",
#     "L": "San Francisco",
#     "ST": "California",
#     "C": "USA"
#   }
# ],
