package models

import "time"

type SendMessageRequest struct {
	JobVacancyID int    `json:"job_vacancy_id" validate:"required"`
	Message      string `json:"message" validate:"required,min=1,max=5000"`
}

type ChatResponse struct {
	ID           int       `json:"id"`
	JobVacancyID int       `json:"job_vacancy_id"`
	SenderID     int       `json:"sender_id"`
	SenderType   string    `json:"sender_type"`
	SenderName   string    `json:"sender_name"`
	Message      string    `json:"message"` 
	IsRead       bool      `json:"is_read"`
	CreatedAt    time.Time `json:"created_at"`
}


type ChatThreadResponse struct {
	JobVacancyID  int       `json:"job_vacancy_id"`
	JobPosition   string    `json:"job_position"`
	CompanyName   string    `json:"company_name"`
	CompanyID     int       `json:"company_id"`
	UserName      string    `json:"user_name"`
	UserID        int       `json:"user_id"`
	LastMessage   string    `json:"last_message"`
	LastMessageAt time.Time `json:"last_message_at"`
	UnreadCount   int       `json:"unread_count"`
}
