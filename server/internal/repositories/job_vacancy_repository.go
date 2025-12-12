package repositories

import (
	"github.com/Dokito555/jobseeker/server/internal/entity"
	"github.com/sirupsen/logrus"
	"gorm.io/gorm"
)

type JobVacancyRepository struct {
	Repository[entity.JobVacancy]
	Log *logrus.Logger
	DB  *gorm.DB
}

func NewJobVacancyRepository(log *logrus.Logger, db *gorm.DB) *JobVacancyRepository {
	return &JobVacancyRepository{
		Repository: Repository[entity.JobVacancy]{DB: db},
		Log:        log,
		DB:         db,
	}
}

func (r *JobVacancyRepository) FindByID(id int) (*entity.JobVacancy, error) {
	var jv entity.JobVacancy
	err := r.DB.Preload("Company").Preload("JobVacancySkills.SkillTag").First(&jv, id).Error
	if err != nil {
		return nil, err
	}
	return &jv, nil
}

func (r *JobVacancyRepository) FindByCompanyID(companyID int) (*[]entity.JobVacancy, error) {
	var jvs []entity.JobVacancy
	err := r.DB.Preload("JobVacancySkills.SkillTag").Where("company_id = ?", companyID).Order("created_at DESC").Error	
	if err != nil {
		return nil, err
	}
	return &jvs, err
}

func (r *JobVacancyRepository) FindAllActive() (*[]entity.JobVacancy, error) {
	var jvs []entity.JobVacancy
	err := r.DB.Preload("Company").Preload("JobVacancySkills.SkillTag").Where("status = ?", "ACTIVE").Order("created_at DESC").Find(&jvs).Error
	if err != nil {
		return nil, err
	}
	return &jvs, nil
}

func (r *JobVacancyRepository) FindMatchingJobs(userSkillIDs []int, limit int) (*[]entity.JobVacancy, error) {
	var jvs []entity.JobVacancy

	err := r.DB.Preload("Company").Preload("JobVacancySkills.SkillTag").Joins("JOIN job_vacancy_skill_tags jvst ON jvst.job_vacancy_id = job_vacancies.id").Where("jvst.skill_tag_id IN ? AND job_vacancies.status = ?", userSkillIDs, "ACTIVE").Group("job_vacancies.id").Order("COUNT(jvst.skill_tag_id) DESC, job_vacancies.created_at DESC").Limit(limit).Find(&jvs).Error
	if err != nil {
		return nil, err
	}
	return &jvs, err
}