test:
	echo "" | openssl s_client -connect localhost:8080 -CAfile ../../ca.crt
	curl --cacert ../../ca.crt https://localhost:8080
