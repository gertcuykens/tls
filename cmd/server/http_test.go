package server

import (
	"fmt"
	"net/http"
	"testing"

	"github.com/gertcuykens/tls"
)

var mux *http.ServeMux

func init() {
	mux = http.NewServeMux()
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "TLS: %+v", r.TLS)
	})
}

func TestCertificates(t *testing.T) {
	s := &http.Server{
		Addr:    ":8080",
		Handler: mux,
	}
	t.Fatal(s.ListenAndServeTLS(tls.CRT, tls.KEY))
}
