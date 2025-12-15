package entity

type SkillTag struct {
	ID               int                  `gorm:"primaryKey;column:id;autoIncrement"`
	Name             string               `gorm:"column:name"`
	// Category         string               `gorm:"column:category"`
	UserSkills       []UserSkillTag       `gorm:"foreignKey:SkillTagID;constraint:OnDelete:CASCADE"`
	JobVacancySkills []JobVacancySkillTag `gorm:"foreignKey:SkillTagID;constraint:OnDelete:CASCADE"`
}

func (s *SkillTag) TableName() string {
	return "skills"
}
