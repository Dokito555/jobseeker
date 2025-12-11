package entity

type UserSkillTag struct {
	ID         int `gorm:"primaryKey"`
	UserID     int `gorm:"user_id"`
	SkillTagID int `gorm:"skill_tag_id"`
}

func (u *UserSkillTag) TableName() string {
	return "user_skill_tags"
}
