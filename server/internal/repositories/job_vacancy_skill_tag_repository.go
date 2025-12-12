package repositories

import (
	"github.com/Dokito555/jobseeker/server/internal/entity"
	"github.com/sirupsen/logrus"
	"gorm.io/gorm"
)

type JobVacancySkillTagRepository struct {
	Repository[entity.JobVacancySkillTag]
	Log *logrus.Logger
	DB  *gorm.DB
}

func NewJobVacancySkillTagRepository(log *logrus.Logger, db *gorm.DB) *JobVacancySkillTagRepository {
	return &JobVacancySkillTagRepository{
		Repository: Repository[entity.JobVacancySkillTag]{DB: db},
		Log:        log,
		DB:         db,
	}
}

func (r *JobVacancyRepository) FindJobVacancyID(id int) (*[]entity.JobVacancySkillTag, error) {
	var jvst []entity.JobVacancySkillTag
	err := r.DB.Preload("SkillTag").
		Where("job_vacancy_id = ?", id).
		Find(&jvst).Error
	if err != nil {
		return nil, err
	}
	return &jvst, nil
}
