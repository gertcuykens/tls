package tls

import (
	"log"
	"os"
	"path/filepath"
)

var KEY = ""
var CRT = ""
var CA = ""

func init() {
	KEY = path("tls.key")
	CRT = path("tls.crt")
	CA = path("ca.crt")
}

func path(rel string) string {
	if filepath.IsAbs(rel) {
		return rel
	}
	v, err := goPackagePath("github.com/gertcuykens/tls")
	if err != nil {
		log.Fatalf("Error finding github.com/gertcuykens/tls directory: %s", err)
	}
	return filepath.Join(v, rel)
}

func goPackagePath(pkg string) (path string, err error) {
	gp := os.Getenv("GOPATH")
	if gp == "" {
		return path, os.ErrNotExist
	}
	for _, p := range filepath.SplitList(gp) {
		dir := filepath.Join(p, "src", filepath.FromSlash(pkg))
		fi, err := os.Stat(dir)
		if os.IsNotExist(err) {
			continue
		}
		if err != nil {
			return "", err
		}
		if !fi.IsDir() {
			continue
		}
		return dir, nil
	}
	return path, os.ErrNotExist
}
