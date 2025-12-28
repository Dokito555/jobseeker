package services

import (
	"crypto/aes"
	"crypto/cipher"
	"crypto/rand"
	"crypto/sha256"
	"encoding/base64"
	"encoding/hex"
	"errors"
	"fmt"
	"io"

	"github.com/sirupsen/logrus"
)

type EncryptionService struct {
	Log       *logrus.Logger
	MasterKey []byte
}

func NewEncryptionService(log *logrus.Logger, masterKeyHex string) (*EncryptionService, error) {
	masterKey, err := hex.DecodeString(masterKeyHex)
	if err != nil {
		log.Warnf("invalid master key: %v", err)
		return nil, fmt.Errorf("invalid master key: %w", err)
	}

	if len(masterKey) != 32 {
		log.Warn("master key must be 32 bytes (64 hex characters)")
		return nil, errors.New("master key must be 32 bytes (64 hex characters)")
	}

	return &EncryptionService{
		Log:       log,
		MasterKey: masterKey,
	}, nil
}

func (s *EncryptionService) GenerateJobKey(jobVacancyID int) []byte {
	data := fmt.Sprintf("%s:%d", s.MasterKey, jobVacancyID)
	hash := sha256.Sum256([]byte(data))
	return hash[:]
}

func (s *EncryptionService) EncryptMessage(plainText string, jobVacancyID int) (encryptedMsg, iv string, err error) {
	key := s.GenerateJobKey(jobVacancyID)
	// Create AES cipher
	block, err := aes.NewCipher(key)
	if err != nil {
		s.Log.Warnf("failed to create cipher: %v", err)
		return "", "", fmt.Errorf("failed to create cipher: %w", err)
	}

	// Use GCM mode (Galois/Counter Mode) for authenticated encryption
	gcm, err := cipher.NewGCM(block)
	if err != nil {
		s.Log.Warnf("failed to create GCM: %v", err)
		return "", "", fmt.Errorf("failed to create GCM: %w", err)
	}

	// Generate random nonce/IV
	nonce := make([]byte, gcm.NonceSize())
	if _, err := io.ReadFull(rand.Reader, nonce); err != nil {
		s.Log.Warnf("failed to genereate nonce: %v", err)
		return "", "", fmt.Errorf("failed to generate nonce: %w", err)
	}

	// Encrypt the message
	ciphertext := gcm.Seal(nil, nonce, []byte(plainText), nil)

	// Encode to base64 for storage
	encryptedMsg = base64.StdEncoding.EncodeToString(ciphertext)
	iv = base64.StdEncoding.EncodeToString(nonce)

	return encryptedMsg, iv, nil
}

func (s *EncryptionService) DecryptMessage(encryptedMsg, iv string, jobVacancyID int) (string, error) {
	key := s.GenerateJobKey(jobVacancyID)

	// Decode from base64
	ciphertext, err := base64.StdEncoding.DecodeString(encryptedMsg)
	if err != nil {
		s.Log.Warnf("failed to decode ciphertext: %v", err)
		return "", fmt.Errorf("failed to decode ciphertext: %w", err)
	}

	nonce, err := base64.StdEncoding.DecodeString(iv)
	if err != nil {
		s.Log.Warnf("failed to decode IV: %v", err)
		return "", fmt.Errorf("failed to decode IV: %w", err)
	}

	// Create AES cipher
	block, err := aes.NewCipher(key)
	if err != nil {
		s.Log.Warnf("failed to crete cipher: %v", err)
		return "", fmt.Errorf("failed to create cipher: %w", err)
	}

	// Use GCM mode
	gcm, err := cipher.NewGCM(block)
	if err != nil {
		s.Log.Warnf("failed to create GCM: %v", err)
		return "", fmt.Errorf("failed to create GCM: %w", err)
	}

	// Decrypt the message
	plaintext, err := gcm.Open(nil, nonce, ciphertext, nil)
	if err != nil {
		s.Log.Warnf("failed to decrypt: %v", err)
		return "", fmt.Errorf("failed to decrypt: %w", err)
	}

	return string(plaintext), nil
}
