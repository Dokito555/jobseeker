package entity

import "time"

type User struct {
	ID           int            `gorm:"primaryKey;autoIncrement;column:id"`
	Name         string         `gorm:"column:name;type:varchar(255)"`
	Email        string         `gorm:"column:email;unique"`
	Password     string         `gorm:"column:password"`
	PhoneNumber  string         `gorm:"column:phone_number"`
	Address      string         `gorm:"column:address"`
	UserSkills   []UserSkillTag `gorm:"foreignKey:UserID;constraint:OnDelete:CASCADE"`
	Token        string         `gorm:"column:token"`
	RefreshToken string         `gorm:"column:refresh_token"`
	CreatedAt    time.Time      `gorm:"column:created_at"`
	UpdatedAt    time.Time      `gorm:"column:updated_at"`
}

func (u *User) TableName() string {
	return "users"
}
