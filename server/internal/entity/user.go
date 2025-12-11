package entity

import "time"

type User struct {
	ID          int    `gorm:"primaryKey"`
	Name        string `gorm:"column:name;type:varchar(255)"`
	Email       string `gorm:"column:email;unique"`
	Password    string `gorm:"column:password"`
	PhoneNumber string `gorm:"column:phone_number"`

	Skills string `gorm:"column:skills"`

	Token        string `gorm:"column:token"`
	RefreshToken string `gorm:"column:refresh_token"`

	CreatedAt time.Time `gorm:"column:created_at"`
	UpdatedAt time.Time `gorm:"column:updated_at"`
}

func (u *User) TableName() string {
	return "users"
}
