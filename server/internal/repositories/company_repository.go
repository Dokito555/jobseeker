package repositories

import (
	"errors"

	"github.com/Dokito555/jobseeker/server/internal/entity"
	"github.com/sirupsen/logrus"
	"gorm.io/gorm"
)

type CompanyRepository struct {
	Repository[entity.Company]
	Log *logrus.Logger
	DB  *gorm.DB
}

func NewCompanyRepository(log *logrus.Logger, db *gorm.DB) *CompanyRepository {
	return &CompanyRepository{
		Repository: Repository[entity.Company]{DB: db},
		Log:        log,
		DB:         db,
	}
}

func (r *CompanyRepository) FindByID(id int) (*entity.Company, error) {
	var company entity.Company
	err := r.DB.Where("id = ?", id).First(company).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, errors.New("company not found")
		}
		return nil, err
	}
	return &company, nil
}

func (r *CompanyRepository) FinByEmail(email string) (*entity.Company, error) {
	var company entity.Company
	err := r.DB.Where("email = ?", email).First(company).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, errors.New("company not found")
		}
		return nil, err
	}
	return &company, nil
}
