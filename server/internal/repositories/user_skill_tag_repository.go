package repositories

import (
	"github.com/Dokito555/jobseeker/server/internal/entity"
	"github.com/sirupsen/logrus"
	"gorm.io/gorm"
)

type UserSkillTagRepository struct {
	Repository[entity.UserSkillTag]
	Log *logrus.Logger
	DB  *gorm.DB
}

func NewUserSkillTagRepository(log *logrus.Logger, db *gorm.DB) *UserSkillTagRepository {
	return &UserSkillTagRepository{
		Repository: Repository[entity.UserSkillTag]{DB: db},
		Log:        log,
		DB:         db,
	}
}

func (r *UserSkillTagRepository) FindByUserID(userID int) (*[]entity.UserSkillTag, error) {
	var userSkills []entity.UserSkillTag
	err := r.DB.Preload("SkillTag").Where("user_id = ?", userID).Find(&userSkills).Error
	if err != nil {
		return nil, err
	}
	return &userSkills, err
}

func (r *UserSkillTagRepository) DeleteByUserID(userID int) error {
	err := r.DB.Where("user_id = ?", userID).Delete(&entity.UserSkillTag{}).Error
	if err != nil {
		return err
	}
	return nil
}
