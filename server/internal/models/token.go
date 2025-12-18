package models

import "github.com/golang-jwt/jwt/v4"

type ClaimToken struct {
	UserID int    `json:"user_id"`
	Email  string `json:"email"`
	Name   string `json:"user_name"`
	Role 	string `json:"role"`
	jwt.RegisteredClaims
}

type TokenRequest struct {
	Token string `json:"token" validate:"required"`
}

type VerifyRequest struct {
	Token string `json:"token" validate:"required"`
}