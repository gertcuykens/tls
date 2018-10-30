#!/bin/bash
cat <<EOF | cfssl genkey - | cfssljson -bare tls
{
  "hosts": [
    "cockroach.default.svc.cluster.local",
    "cockroach",
    "cockroach-lb.default.svc.cluster.local",
    "cockroach-lb",
    "cockroach-0.default.pod.cluster.local",
    "cockroach-0",
    "localhost",
    "127.0.0.1"
  ],
  "CN": "cockroach-0.default.pod.cluster.local",
  "key": {
    "algo": "ecdsa",
    "size": 256
  }
}
EOF

cat <<EOF | kubectl create -f -
kind: CertificateSigningRequest
apiVersion: certificates.k8s.io/v1beta1
metadata:
  name: cockroach
spec:
  groups:
  - system:authenticated
  request: $(cat tls.csr | base64 | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - server auth
EOF

# kubectl get csr
# kubectl certificate approve cockroach
# kubectl get csr cockroach -o jsonpath='{.status.certificate}' | base64 --decode > tls.pem
# kubectl create secret generic tls \
#   --from-file=crt=tls.pem \
#   --from-file=key=tls-key.pem

# openssl x509 -in tls.pem     -noout -text
# openssl rsa  -in tls-key.pem              -check
# openssl req  -in tls.csr     -noout -text -verify

# openssl x509 -in tls.pem     -noout       -modulus | openssl md5
# openssl rsa  -in tls-key.pem -noout       -modulus | openssl md5

# https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/

# /var/run/secrets/kubernetes.io/serviceaccount/ca.crt

# echo localhost, 127.0.0.1, $(hostname -f),                                  $(hostname -f | cut -f 1-2 -d '.'), cockroach-lb, cockroachdb-lb.$(hostname -f | cut -f 3- -d '.')
#      localhost, 127.0.0.1, cockroach-0.cockroach.default.svc.cluster.local, cockroach-0.cockroach,              cockroach-lb, cockroachdb-lb.default.svc.cluster.local

# go get -u github.com/cloudflare/cfssl/cmd/cfssljson
# go get -u github.com/cloudflare/cfssl/cmd/cfssl

# go get -u github.com/kubernetes/kubernetes/cmd/kubectl
# go get -u github.com/kubernetes/kubernetes/cmd/kubeadm
# go get -u github.com/kubernetes/kubernetes/cmd/kubelet
