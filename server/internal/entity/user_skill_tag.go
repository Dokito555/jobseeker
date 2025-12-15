package entity

import "time"

type UserSkillTag struct {
	ID         int       `gorm:"primaryKey;column:id;autoIncrement"`
	UserID     int       `gorm:"column:user_id"`
	SkillTagID int       `gorm:"column:skill_tag_id"`
	CreatedAt  time.Time `gorm:"column:created_at"`

	User     *User     `gorm:"foreignKey:UserID;constraint:OnDelete:CASCADE"`
	SkillTag *SkillTag `gorm:"foreignKey:SkillTagID;constraint:OnDelete:CASCADE"`
}

func (u *UserSkillTag) TableName() string {
	return "user_skill_tags"
}
