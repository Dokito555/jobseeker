package entity

import "time"

type JobVacancy struct {
	ID       int    `gorm:"primaryKey"`
	Position string `gorm:"column:position"`
	Salary   int    `gorm:"column:salary"`
	Status   string `gorm:"column:status"`

	CreatedAt time.Time `gorm:"column:created_at"`
	UpdatedAt time.Time `gorm:"column:updated_at"`
}

func (u *JobVacancy) TableName() string {
	return "job_vacancies"
}
