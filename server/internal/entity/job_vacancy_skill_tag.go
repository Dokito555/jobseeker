package entity

type JobVacancySkillTag struct {
	ID           int         `gorm:"primaryKey;column:id;autoIncrement"`
	JobVacancyID int         `gorm:"column:job_vacancy_id"`
	SkillTagID   int         `gorm:"column:skill_tag_id"`
	JobVacancy   *JobVacancy `gorm:"foreignKey:JobVacancyID;constraint:OnDelete:CASCADE"`
	SkillTag     *SkillTag   `gorm:"foreignKey:SkillTagID;constraint:OnDelete:CASCADE"`
}

func (j *JobVacancySkillTag) TableName() string {
	return "job_vacancy_skill_tags"
}
