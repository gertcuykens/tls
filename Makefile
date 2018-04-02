certificate: CN=localhost
certificate: clean
	openssl genrsa -out ca-key.pem 2048
	openssl req -x509 -new -nodes -key ca-key.pem -days 10000 -out ca.pem -subj "/CN=kube-ca"
	openssl genrsa -out server-key.pem 2048
	openssl req -new -key server-key.pem -out server.csr -subj "/CN=$(CN)" -config tls.cnf
	openssl x509 -req -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server.pem -days 3650 -extensions v3_req -extfile tls.cnf

clean:
	rm -f *.pem
	rm -f *.csr
	rm -f *.srl
