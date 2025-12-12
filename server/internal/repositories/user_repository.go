package repositories

import (
	"errors"

	"github.com/Dokito555/jobseeker/server/internal/entity"
	"github.com/sirupsen/logrus"
	"gorm.io/gorm"
)

type UserRepository struct {
	Repository[entity.User]
	Log *logrus.Logger
	DB  *gorm.DB
}

func NewUserRepository(log *logrus.Logger, db *gorm.DB) *UserRepository {
	return &UserRepository{
		Repository: Repository[entity.User]{DB: db},
		Log:        log,
		DB:         db,
	}
}

func (r *UserRepository) FindByID(id int) (*entity.User, error) {
	var user entity.User
	err := r.DB.Where("id = ?", id).First(user).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, errors.New("user not found")
		}
		return nil, err
	}
	return &user, nil
}

func (r *UserRepository) FindByEmail(email string) (*entity.User, error) {
	var user entity.User
	err := r.DB.Where("email = ?", email).First(user).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, errors.New("user not found")
		}
		return nil, err
	}
	return &user, nil
}

func (r *UserRepository) GetUserWithSkills(id int) (*entity.User, error) {
	var user entity.User
	err := r.DB.Preload("UserSkills.SkillTag").First(&user, id).Error
	if err != nil {
		return nil, err
	}
	return &user, nil
}
