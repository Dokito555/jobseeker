package entity

import "time"

type Chat struct {
	ID               int        `gorm:"primaryKey;column:id"`
	JobVacancyID     int        `gorm:"column:job_vacancy_id;not null;index"`
	SenderID         int        `gorm:"column:sender_id"`
	SenderType       string     `gorm:"column:sender_type"`
	EncryptedMessage string     `gorm:"column:encrypted_message;type:text;not null"`
	MessageIV        string     `gorm:"column:message_iv;type:text;not null"`
	IsRead           bool       `gorm:"column:is_read;default:false"`
	CreatedAt        time.Time  `gorm:"column:created_at"`
	JobVacancy       JobVacancy `gorm:"foreignKey:JobVacancyID;constraint:OnDelete:CASCADE"`
}

func (c *Chat) TableName() string {
	return "chats"
}
