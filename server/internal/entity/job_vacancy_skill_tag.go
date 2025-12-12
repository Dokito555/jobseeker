package entity

type JobVacancySkillTag struct {
	ID           int        `gorm:"primaryKey"`
	JobVacancyID int        `gorm:"job_vacancy_id"`
	SkillTagID   int        `gorm:"skill_tag_id"`
	JobVacancy   JobVacancy `gorm:"foreignKey:JobVacancyID;constraint:OnDelete:CASCADE"`
	SkillTag     SkillTag   `gorm:"foreignKey:SkillTagID;constraint:OnDelete:CASCADE"`
}

func (j *JobVacancySkillTag) TableName() string {
	return "job_vacancies_skill_tags"
}
