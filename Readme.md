```go
import(
    "crypto/x509"
    "google.golang.org/grpc/credentials"
)
pool, err := x509.SystemCertPool()
creds := credentials.NewClientTLSFromCert(pool, "")
grpc.Dial(address, grpc.WithTransportCredentials(creds))
```
