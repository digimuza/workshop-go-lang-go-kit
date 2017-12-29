package main

import (
	"fmt"
	"os"
)

func main() {
	dbHost := os.Getenv("DB_HOST")
	dbPort := os.Getenv("DB_PORT")
	dbName := os.Getenv("DB_NAME")
	dbUser := os.Getenv("DB_USER")
	dbPassword := os.Getenv("DB_PASSWORD")
	fmt.Printf("%s, %s, %s, %s, %s", dbHost, dbPort, dbName, dbUser, dbPassword)
}
