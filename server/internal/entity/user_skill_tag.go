package entity

import "time"

type UserSkillTag struct {
	ID         int       `gorm:"primaryKey"`
	UserID     int       `gorm:"user_id"`
	SkillTagID int       `gorm:"skill_tag_id"`
	CreatedAt  time.Time `gorm:"column:created_at"`

	User     User     `gorm:"foreignKey:UserID;contraint:OnDelete:CASCADE"`
	SkillTag SkillTag `gorm:"foreignKey:SkillTagID:constraint:OnDelete:CASCADE"`
}

func (u *UserSkillTag) TableName() string {
	return "user_skill_tags"
}
