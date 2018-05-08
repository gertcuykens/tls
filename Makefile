certificate: CN=localhost
certificate: clean
	openssl genrsa -out ca.key 2048
	openssl req -new -key ca.key -out ca.crt -x509 -nodes -days 3650 -subj "/CN=$(CN)"
	openssl genrsa -out tls.key 2048
	openssl req -new -key tls.key -out tls.crt -subj "/CN=$(CN)" -config tls.cnf
	openssl x509 -req -in tls.crt -out tls.crt -CA ca.crt -CAkey ca.key -CAcreateserial -days 3650 -extensions v3_req -extfile tls.cnf

dhparam:
	openssl dhparam -out dhparam.pem 4096

test:
	openssl x509 -in tls.crt -text

apply:
	-kubectl delete secret tls
	kubectl create secret tls tls-certificate --key tls.key --cert tls.crt
	-kubectl delete secret dhparam
	kubectl create secret dhparam tls-dhparam --from-file=dhparam.pem

clean:
	rm -f *.key
	rm -f *.crt
	rm -f *.srl
	rm -f *.pem	

# curl -s "https://golang.org/src/crypto/tls/generate_cert.go?m=text" -o /tmp/tls.go;  go run /tmp/tls.go --host $(CN)

# ssh-keygen -t rsa
# /O=x:x
