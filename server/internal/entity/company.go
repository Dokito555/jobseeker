package entity

import "time"

type Company struct {
	ID           int          `gorm:"primaryKey;column:id;autoIncrement"`
	Name         string       `gorm:"column:name"`
	Email        string       `gorm:"column:email"`
	Password     string       `gorm:"column:password"`
	Description  string       `gorm:"column:description"`
	PhoneNumber  string       `gorm:"column:phone_number"`
	Address      string       `gorm:"column:address"`
	JobVacancies []JobVacancy `gorm:"foreignKey:CompanyID;constraint:OnDelete:CASCADE"`
	Token        string       `gorm:"column:token"`
	RefreshToken string       `gorm:"column:refresh_token"`
	CreatedAt    time.Time    `gorm:"column:created_at"`
	UpdatedAt    time.Time    `gorm:"column:updated_at"`
}

func (c *Company) TableName() string {
	return "companies"
}
