package entity

import "time"

type JobVacancy struct {
	ID               int                  `gorm:"primaryKey;column:id;autoIncrement"`
	Position         string               `gorm:"column:position"`
	Description      string               `gorm:"column:description"`
	Salary           int                  `gorm:"column:salary"`
	Status           string               `gorm:"column:status"`
	Location         string               `gorm:"column:location"`
	WorkType         string               `gorm:"column:work_type"`
	MinSalary        int64                `gorm:"column:min_salary"`
	MaxSalary        int64                `gorm:"column:max_salary"`
	Active           string               `gorm:"column:active;default:ACTIVE"`
	CompanyID        int                  `gorm:"column:company_id"`
	Company          Company              `gorm:"foreignKey:CompanyID;constraint:OnDelete:CASCADE"`
	JobVacancySkills []JobVacancySkillTag `gorm:"foreignKey:JobVacancyID;constraint:OnDelete:CASCADE"`
	CreatedAt        time.Time            `gorm:"column:created_at"`
	UpdatedAt        time.Time            `gorm:"column:updated_at"`
}

func (u *JobVacancy) TableName() string {
	return "job_vacancies"
}
