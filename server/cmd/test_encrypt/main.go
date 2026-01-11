package main

import (
	"fmt"
	"log"

	"github.com/Dokito555/jobseeker/server/internal/services"
	"github.com/sirupsen/logrus"
)

func main() {
	logger := logrus.New()

	masterKey := "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"

	encService, err := services.NewEncryptionService(logger, masterKey)
	if err != nil {
		log.Fatal(err)
	}

	text := "Halo ini pesan rahasia"
	jobID := 10

	encrypted, iv, err := encService.EncryptMessage(text, jobID)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("Encrypted :", encrypted)
	fmt.Println("IV        :", iv)

	decrypted, err := encService.DecryptMessage(encrypted, iv, jobID)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("Decrypted :", decrypted)
}
