package entity

type JobVacancySkillTag struct {
	ID           int `gorm:"primaryKey"`
	JobVacancyID int `gorm:"job_vacancy_id"`
	SkillTagID   int `gorm:"skill_tag_id"`
}

func (j *JobVacancySkillTag) TableName() string {
	return "job_vacancies_skill_tags"
}
