package repositories

import (
	"errors"

	"github.com/Dokito555/jobseeker/server/internal/entity"
	"github.com/sirupsen/logrus"
	"gorm.io/gorm"
)

type SkillTagRepository struct {
	Repository[entity.SkillTag]
	Log *logrus.Logger
	DB  *gorm.DB
}

func NewSkillTagRepository(log *logrus.Logger, db *gorm.DB) *SkillTagRepository {
	return &SkillTagRepository{
		Repository: Repository[entity.SkillTag]{DB: db},
		Log:        log,
		DB:         db,
	}
}

func (r *SkillTagRepository) FindByID(id int) (*entity.SkillTag, error) {
	var st entity.SkillTag
	err := r.DB.Where("id = ?", id).First(st).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, errors.New("skill tag not found")
		}
		return nil, err
	}
	return &st, nil
}

func (r *SkillTagRepository) FindAll() (*[]entity.SkillTag, error) {
	var sts []entity.SkillTag
	err := r.DB.Find(&sts).Error
	if err != nil {
		return nil, err
	}
	return &sts, nil
}

func (r *SkillTagRepository) FindByCategory(category string) (*[]entity.SkillTag, error) {
	var sts []entity.SkillTag
	err := r.DB.Where("category = ?", category).Find(&sts).Error
	if err != nil {
		return nil, err
	}
	return &sts, nil
}

func (r *SkillTagRepository) FindByIDs(ids []int) (*[]entity.SkillTag, error) {
	var sts []entity.SkillTag
	err := r.DB.Where("id IN ?", ids).Find(&sts).Error
	if err != nil {
		return nil, err
	}
	return &sts, nil
}

func (r *SkillTagRepository) CreateBulk(userSkills []entity.UserSkillTag) error {
	return r.DB.Create(&userSkills).Error
}