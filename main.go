package main

import (
    "fmt"
    "net/http"
    "github.com/gorilla/mux" // External dependency for routing
)

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello, World! This is a Go web app using Gorilla Mux.")
}

func main() {
    r := mux.NewRouter()
    r.HandleFunc("/", handler)
    fmt.Println("Server is running on port 8000...")
    http.ListenAndServe(":8000", r) // Use Gorilla Mux router
}
