package entity

type SkillTag struct {
	ID               int                  `gorm:"primaryKey"`
	Name             string               `gorm:"column:name"`
	Category         string               `gorm:"category"`
	UserSkills       []UserSkillTag       `gorm:"foreignKey:SkillTagID;constraint:OnDelete:CASCADE"`
	JobVacancySkills []JobVacancySkillTag `gorm:"foreignKey:SkillTagID;constraint:OnDelete:CASCADE"`
}

func (s *SkillTag) TableName() string {
	return "skills"
}
