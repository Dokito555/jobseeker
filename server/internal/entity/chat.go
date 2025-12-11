package entity

import "time"

type Chat struct {
	ID       int    `gorm:"primaryKey"`
	SenderID int    `gorm:"column:sender_id"`
	Message  string `gorm:"column:message"`

	CreatedAt time.Time `gorm:"column:created_at"`
}

func (c *Chat) TableName() string {
	return "chats"
}
