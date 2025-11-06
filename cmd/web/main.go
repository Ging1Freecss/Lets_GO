package main

import (
	"flag"
	"log"
	"net/http"
)

func main() {

	addr := flag.String("addr", ":4000", "HTTP network address") // command line insert
	flag.Parse()

	mux := http.NewServeMux()

	fileServer := http.FileServer(http.Dir("./ui/static/"))
    // Use the mux.Handle() function to register the file server as the handler for
    // all URL paths that start with "/static/". For matching paths, we strip the
    // "/static" prefix before the request reaches the file server.
    mux.Handle("GET /static/", http.StripPrefix("/static", fileServer))

	mux.HandleFunc("GET /{$}", home)
	mux.HandleFunc("GET /snippet/view/{id}", snippetView)
	mux.HandleFunc("GET /snippet/create", snippetCreate)
	mux.HandleFunc("POST /snippet/create", snippetCreatePost)
	log.Printf("starting server on %s", *addr)
    // And we pass the dereferenced addr pointer to http.ListenAndServe() too.
    err := http.ListenAndServe(*addr, mux)
	log.Fatal(err)
}
