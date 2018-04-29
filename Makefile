certificate: CN=localhost
certificate: clean
	openssl genrsa -out ca.key 2048
	openssl req -x509 -new -nodes -key ca.key -days 10000 -out ca.crt -subj "/CN=$(CN)"
	openssl genrsa -out tls.key 2048
	openssl req -new -key tls.key -out tls.crt -subj "/CN=$(CN)" -config tls.cnf
	openssl x509 -req -in tls.crt -CA ca.crt -CAkey ca.key -CAcreateserial -out tls.crt -days 3650 -extensions v3_req -extfile tls.cnf
# curl -s "https://golang.org/src/crypto/tls/generate_cert.go?m=text" -o /tmp/tls.go;  go run /tmp/tls.go --host $(CN)

clean:
	rm -f *.key
	rm -f *.crt
	rm -f *.srl
