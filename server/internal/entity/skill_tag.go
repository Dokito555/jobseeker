package entity

type SkillTag struct {
	ID       int    `gorm:"primaryKey"`
	Category string `gorm:"category"`
}

func (s *SkillTag) TableName() string {
	return "skills"
}
