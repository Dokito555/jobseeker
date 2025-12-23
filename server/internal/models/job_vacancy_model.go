package models

import "time"

type (
	CreateJobVacancyRequest struct {
		Position       string `json:"position" validate:"required"`
		Description    string `json:"description" validate:"required"`
		Location       string `json:"location" validate:"required"`
		WorkType       string `json:"work_type" validate:"required"`
		MinSalary      int64  `json:"min_salary" validate:"required,min=0"`
		MaxSalary      int64  `json:"max_salary" validate:"required,gtfield=MinSalary"`
		RequiredSkills []int  `json:"required_skills" validate:"required,min=1"`
	}

	UpdateJobVacancyRequest struct {
		Position       string `json:"position" validate:"required"`
		Description    string `json:"description" validate:"required"`
		Location       string `json:"location" validate:"required"`
		WorkType       string `json:"work_type" validate:"required,oneof=full_time part_time freelance remote"`
		MinSalary      int64  `json:"min_salary" validate:"required,min=0"`
		MaxSalary      int64  `json:"max_salary" validate:"required,gtfield=MinSalary"`
		RequiredSkills []int  `json:"required_skills" validate:"required,min=1"`
	}
)

type (
	JobVacancyResponse struct {
		ID             int       `json:"id"`
		CompanyID      int       `json:"company_id"`
		CompanyName    string    `json:"company_name"`
		Position       string    `json:"position"`
		Description    string    `json:"description"`
		Location       string    `json:"location"`
		WorkType       string    `json:"work_type"`
		MinSalary      int64     `json:"min_salary"`
		MaxSalary      int64     `json:"max_salary"`
		RequiredSkills []string  `json:"required_skill"`
		SkillTags      []string  `json:"skill_tags,omitempty"`
		Status         string    `json:"status"`
		CreatedAt      time.Time `json:"created_at"`
		UpdatedAt      time.Time `json:"updated_at"`
	}
)
