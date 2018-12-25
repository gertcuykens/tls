certificate: CN=localhost
certificate: clean
	openssl genrsa -out ca.key 2048
	openssl req -new -key ca.key -out ca.crt -x509 -nodes -days 3650 -subj "/CN=$(CN)"
	openssl genrsa -out tls.key 2048
	openssl req -new -key tls.key -out tls.crt -subj "/CN=$(CN)" -config openssl.cnf
	openssl x509 -req -in tls.crt -out tls.crt -CA ca.crt -CAkey ca.key -CAcreateserial -days 3650 -extensions v3_req -extfile tls.cnf

dhparam:
	openssl dhparam -out dhparam.pem 4096

test:
	openssl x509 -in tls.pem -text -noout

clean:
	rm -f *.key
	rm -f *.crt
	rm -f *.srl
	rm -f *.pem	

# curl -s "https://golang.org/src/crypto/tls/generate_cert.go?m=text" -o /tmp/tls.go;  go run /tmp/tls.go --host $(CN)

# ssh-keygen -t rsa
# /O=x:x

# test: CN=localhost
# test:
# 	-echo "" | openssl s_client -connect localhost:8080 -CAfile ca.crt -servername $(CN)
# 	-curl --cacert ca.crt https://localhost:8080
