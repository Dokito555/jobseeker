package models

import (
	"time"
)

type (
	RegisterCompanyRequest struct {
		Email       string `json:"email" validate:"required"`
		Password    string `json:"password" validate:"required"`
		Name        string `json:"name" validate:"required"`
		Description string `json:"description"`
		PhoneNumber string `json:"phone_number" validate:"required"`
	}

	LoginCompanyRequest struct {
		Email    string `json:"email" validate:"required"`
		Password string `json:"password" validate:"required"`
	}

	CompanyIDRequest struct {
		ID int `json:"id" validate:"required"`
	}

	UpdateCompanyRequest struct {
		Email       string `json:"email" validate:"required"`
		Password    string `json:"password" validate:"required"`
		Name        string `json:"name" validate:"required"`
		Description string `json:"description"`
		PhoneNumber string `json:"phone_number" validate:"required"`
	}
)

type (
	CompanyResponse struct {
		ID           int                         `json:"id"`
		Email        string                      `json:"email"`
		Name         string                      `json:"name"`
		Description  string                      `json:"description"`
		PhoneNumber  string                      `json:"phone_number"`
		Address      string                      `json:"column:address"`
		// JobVacancies []models.JobVacancyResponse `json:"job_vacancies"`

		Token        string    `json:"token"`
		RefreshToken string    `json:"refresh_token"`
		CreatedAt    time.Time `json:"created_at"`
		UpdatedAt    time.Time `json:"updated_at"`
	}
)
