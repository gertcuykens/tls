package acme

import (
	"crypto/tls"
	"fmt"
	"net/http"
	"testing"

	"golang.org/x/crypto/acme/autocert"
)

var mux *http.ServeMux

func init() {
	mux := http.NewServeMux()
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "TLS: %+v", r.TLS)
	})
}

func TestACME(t *testing.T) {
	m := &autocert.Manager{
		Cache:      autocert.DirCache("tls"),
		Prompt:     autocert.AcceptTOS,
		HostPolicy: autocert.HostWhitelist("example.com"),
	}
	go http.ListenAndServe(":http", m.HTTPHandler(nil))
	s := &http.Server{
		Addr:      ":https",
		TLSConfig: &tls.Config{GetCertificate: m.GetCertificate},
		Handler:   mux,
	}
	t.Fatal(s.ListenAndServeTLS("", ""))
	// t.Fatal(http.Serve(autocert.NewListener("example.com"), mux))
}
