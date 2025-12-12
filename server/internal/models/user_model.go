package models

import "time"

type (
	LoginUserRequest struct {
		Email    string `json:"email" validate:"required"`
		Password string `json:"password" validate:"required"`
	}

	RegisterUserRequest struct {
		Email       string `json:"email" validate:"required"`
		Password    string `json:"password" validate:"required"`
		Name        string `json:"name" validate:"required"`
		PhoneNumber string `json:"phone_number" validate:"required"`
		SkillIds    []int  `json:"skill_ids" validate:"required"`
	}

	UserIDRequest struct {
		ID int `json:"id" validate:"required"`
	}

	UpdateUserRequest struct {
		Password    string   `json:"password" validate:"required"`
		Username    string   `json:"username" validate:"required"`
		Skills      []string `json:"skills" validate:"required"`
		PhoneNumber string   `json:"phone_number" validate:"required"`
	}
)

type (
	UserResponse struct {
		ID          int    `json:"id"`
		Email       string `json:"email"`
		Name        string `json:"name"`
		PhoneNumber string `json:"phone_number"`

		Skills []string `json:"skills"`

		Token        string `json:"token"`
		RefreshToken string `json:"refresh_token"`

		CreatedAt time.Time `json:"created_at"`
		UpdatedAt time.Time `json:"updated_at"`
	}
)
