package models

import "time"

type (
	JobVacancyResponse struct {
		ID             int       `json:"id"`
		CompanyName    string    `json:"company_name"`
		Position       string    `json:"position"`
		Description    string    `json:"description"`
		Location       string    `json:"location"`
		WorkType       string    `json:"work_type"`
		MinSalary      int64     `json:"min_salary"`
		MaxSalary      int64     `json:"max_salary"`
		SkillTags      []string  `json:"skill_tags,omitempty"`
		Status         string    `json:"status"`
		CreatedAt      time.Time `json:"created_at"`
	}
)