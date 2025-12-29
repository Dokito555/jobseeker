package services

import (
	"context"
	"errors"
	"fmt"

	"github.com/Dokito555/jobseeker/server/internal/entity"
	"github.com/Dokito555/jobseeker/server/internal/models"
	"github.com/Dokito555/jobseeker/server/internal/models/converter"
	"github.com/Dokito555/jobseeker/server/internal/repositories"
	"github.com/Dokito555/jobseeker/server/utils/constants"
	"github.com/go-playground/validator/v10"
	"github.com/sirupsen/logrus"
	"github.com/spf13/viper"
	"gorm.io/gorm"
)

type JobVacancyService struct {
	Log                 *logrus.Logger
	Validate            *validator.Validate
	Config              *viper.Viper
	DB                  *gorm.DB
	JobVacancyRepo      *repositories.JobVacancyRepository
	JobVacancySkillRepo *repositories.JobVacancySkillTagRepository
	UserSkillRepo       *repositories.UserSkillTagRepository
}

func NewJobVacancyService(log *logrus.Logger, validate *validator.Validate, db *gorm.DB, config *viper.Viper, JobVRepo *repositories.JobVacancyRepository, JobVSkillRepo *repositories.JobVacancySkillTagRepository, UserSkillRepo *repositories.UserSkillTagRepository) *JobVacancyService {
	return &JobVacancyService{
		Log:                 log,
		Validate:            validate,
		Config:              config,
		DB:                  db,
		JobVacancyRepo:      JobVRepo,
		JobVacancySkillRepo: JobVSkillRepo,
		UserSkillRepo:       UserSkillRepo,
	}
}

func (s *JobVacancyService) CreateJob(ctx context.Context, companyID int, req *models.CreateJobVacancyRequest) (*models.JobVacancyResponse, error) {
	s.Log.Info("starting Create Job function")
	s.Log.Infof("request received: %+v", req)

	tx := s.DB.WithContext(ctx).Begin()
	defer tx.Rollback()

	err := s.Validate.Struct(req)
	if err != nil {
		s.Log.Warnf("invalid request")
		return nil, fmt.Errorf("invalid request")
	}

	if req.Position == "" {
		s.Log.Warnf("posisiotn is required")
		return nil, fmt.Errorf("position is required")
	}

	if req.MinSalary < 0 {
		s.Log.Warnf("minimum salary cannot be negative")
		return nil, fmt.Errorf("minimum salary cannot be negative")
	}

	if req.MaxSalary < req.MaxSalary {
		s.Log.Warnf("maximum salary must be greater thn minium salary")
		return nil, fmt.Errorf("maximum salary must be greater thn minium salary")
	}

	if len(req.RequiredSkills) == 0 {
		s.Log.Warnf("maximum salary must be greater thn minium salary")
		return nil, fmt.Errorf("at least one required skill is need")
	}

	job := &entity.JobVacancy{
		CompanyID:   companyID,
		Position:    req.Position,
		Description: req.Description,
		Location:    req.Location,
		WorkType:    req.WorkType,
		MinSalary:   req.MinSalary,
		MaxSalary:   req.MaxSalary,
		Status:      constants.JOB_STATUS_ACTIVE,
	}

	err = s.JobVacancyRepo.Create(s.DB, job)
	if err != nil {
		s.Log.Fatalf("failed to create job to db: %v", err)
		return nil, fmt.Errorf("failed to create job to database")
	}

	if len(req.RequiredSkills) > 0 {
		jobSkilss := make([]entity.JobVacancySkillTag, 0, len(req.RequiredSkills))
		for _, skillID := range req.RequiredSkills {
			jobSkilss = append(jobSkilss, entity.JobVacancySkillTag{
				JobVacancyID: job.ID,
				SkillTagID:   skillID,
			})
		}

		err = s.JobVacancySkillRepo.CreateBulk(jobSkilss)
		if err != nil {
			s.Log.Fatalf("failed to create jobskills to db: %v", err)
			return nil, fmt.Errorf("failed to create jobskills to database")
		}
	}

	
	if err := tx.Commit().Error; err != nil {
		s.Log.Fatalf("failed to commit transaction: %+v", err)
		return nil, fmt.Errorf("failed create job transaction")
	}

	jobWithRelations, err := s.JobVacancyRepo.FindByID(job.ID)
	if err != nil {
		s.Log.Fatalf("failed to get job with realtions: %+v", err)
		return nil, fmt.Errorf("failed get job with relations")
	}

	return converter.JobVacancyToResponse(jobWithRelations), nil
}

func (s *JobVacancyService) GetJobByID(ctx context.Context, jobID int) (*models.JobVacancyResponse, error) {
	s.Log.Info("starting Get Job By ID function")
	s.Log.Infof("request received: %+v", jobID)

	tx := s.DB.WithContext(ctx).Begin()
	defer tx.Rollback()

	job, err := s.JobVacancyRepo.FindByID(jobID)
	if err != nil {
		s.Log.Fatalf("failed to get job from db: %+v", err)
		return nil, fmt.Errorf("failed to fetch job from db")
	}

	if err := tx.Commit().Error; err != nil {
		s.Log.Fatalf("failed to commit transaction: %+v", err)
		return nil, fmt.Errorf("failed Get Job By ID transaction")
	}

	return converter.JobVacancyToResponse(job), nil
}

// TODO: returns empty
func (s *JobVacancyService) GetJobsByCompany(ctx context.Context, companyID int) ([]models.JobVacancyResponse, error) {
	s.Log.Info("starting Get Job By Company function")
	s.Log.Infof("request received: %+v", companyID)

	tx := s.DB.WithContext(ctx).Begin()
	defer tx.Rollback()

	jobs, err := s.JobVacancyRepo.FindByCompanyID(companyID)
	if err != nil {
		s.Log.Fatalf("failed to get jobs from db: %+v", err)
		return nil, fmt.Errorf("failed to fetch jobs from db")
	}

	if err := tx.Commit().Error; err != nil {
		s.Log.Fatalf("failed to commit transaction: %+v", err)
		return nil, fmt.Errorf("failed Get Job By Company transaction")
	}

	responses := make([]models.JobVacancyResponse, 0, len(*jobs))
	for _, job := range *jobs {
		responses = append(responses, *converter.JobVacancyToResponse(&job))
	}

	s.Log.Infof("GET JOBS BY COMPANY: %+v", responses)

	return responses, nil
}

func (s *JobVacancyService) GetAllActiveJobs(ctx context.Context) ([]models.JobVacancyResponse, error) {
	s.Log.Info("starting Get All Active Jobs function")
	// s.Log.Infof("request received: %+v")

	tx := s.DB.WithContext(ctx).Begin()
	defer tx.Rollback()

	jobs, err := s.JobVacancyRepo.FindAllActive()
	if err != nil {
		s.Log.Fatalf("failed to get all active jobs from db: %+v", err)
		return nil, fmt.Errorf("failed to fetch active jobs from db")
	}

	if err := tx.Commit().Error; err != nil {
		s.Log.Fatalf("failed to commit transaction: %+v", err)
		return nil, fmt.Errorf("failed Get All Active Jobs transaction")
	}

	responses := make([]models.JobVacancyResponse, 0, len(*jobs))
	for _, job := range *jobs {
		responses = append(responses, *converter.JobVacancyToResponse(&job))
	}

	return responses, nil
}

func (s *JobVacancyService) GetRecommendedJobs(ctx context.Context, userID int, limit int) ([]models.JobVacancyResponse, error) {
	s.Log.Info("starting Get Recommended Jobs function")
	s.Log.Infof("request received: %+v", userID)

	tx := s.DB.WithContext(ctx).Begin()
	defer tx.Rollback()

	userSkills, err := s.UserSkillRepo.FindByUserID(userID)
	if err != nil {
		s.Log.Fatalf("failed to get user skills from db: %+v", err)
		return nil, fmt.Errorf("failed to user skills from db")
	}

	if len(*userSkills) == 0 {
		return []models.JobVacancyResponse{}, nil
	}

	skillIds := make([]int, 0, len(*userSkills))
	for _, us := range *userSkills {
		skillIds = append(skillIds, us.SkillTagID)
	}

	jobs, err := s.JobVacancyRepo.FindMatchingJobs(skillIds, limit)
	if err != nil {
		s.Log.Fatalf("failed to get matching jobs from db: %+v", err)
		return nil, fmt.Errorf("failed to get matching jobs from db")
	}

	if err := tx.Commit().Error; err != nil {
		s.Log.Fatalf("failed to commit transaction: %+v", err)
		return nil, fmt.Errorf("failed Get Recommended Jobs transaction")
	}

	responses := make([]models.JobVacancyResponse, 0, len(*jobs))
	for _, job := range *jobs {
		responses = append(responses, *converter.JobVacancyToResponse(&job))
	}

	return responses, nil
}

func (s *JobVacancyService) UpdateJob(ctx context.Context, companyID, jobID int, req *models.UpdateJobVacancyRequest) (*models.JobVacancyResponse, error) {
	s.Log.Info("starting Get Updated Job function")
	s.Log.Infof("request received: %+v", companyID, jobID, req)

	tx := s.DB.WithContext(ctx).Begin()
	defer tx.Rollback()

	if req.Position == "" {
		s.Log.Fatalf("position is required")
		return nil, fmt.Errorf("position is required")
	}

	if req.MinSalary < 0 {
		s.Log.Fatalf("minimum salary cannot be negative")
		return nil, fmt.Errorf("minimum salary cannot be negative")
	}

	if req.MaxSalary < req.MaxSalary {
		s.Log.Fatalf("maximum salary must be greater thn minium salary")
		return nil, fmt.Errorf("maximum salary must be greater thn minium salary")
	}

	job, err := s.JobVacancyRepo.FindByID(jobID)
	if err != nil {
		s.Log.Fatalf("maximum salary must be greater thn minium salary")
		return nil, fmt.Errorf("maximum salary must be greater thn minium salary")
	}

	if job.CompanyID != companyID {
		s.Log.Fatalf("unauthorized: you can only update your own jobs")
		return nil, fmt.Errorf("unauthorized: you can only update your own jobs")
	}

	job.Position = req.Position
	job.Description = req.Description
	job.Location = req.Location
	job.WorkType = req.WorkType
	job.MinSalary = req.MinSalary
	job.MaxSalary = req.MaxSalary

	err = s.JobVacancyRepo.Update(s.DB, job) 
	if err != nil {
		s.Log.Fatalf("failed to update job: %w", err)
		return nil, fmt.Errorf("failed to update job: %w", err)
	}

	// TODO: function not found
	// err = s.JobVacancySkillRepo.DeleteByJobVacancyID(jobID)
	// if err != nil {
	// 	s.Log.Fatalf("failed to delete old skills: %w", err)
	// 	return nil, fmt.Errorf("failed to delete old skills: %w", err)
	// }

	if len(req.RequiredSkills) > 0 {
		jobSkills := make([]entity.JobVacancySkillTag, 0, len(req.RequiredSkills))
		for _, skillID := range req.RequiredSkills {
			jobSkills = append(jobSkills, entity.JobVacancySkillTag{
				JobVacancyID: jobID,
				SkillTagID:   skillID,
			})
		}
		
		if err := s.JobVacancySkillRepo.CreateBulk(jobSkills); err != nil {
			s.Log.Fatalf("failed to add required skills: %w", err)
			return nil, fmt.Errorf("failed to add required skills: %w", err)
		}
	}

	jobWithRelations, err := s.JobVacancyRepo.FindByID(jobID)
	if err != nil {
		s.Log.Fatalf("failed to get job with relations: %w", err)
		return nil, fmt.Errorf("failed to get job with relations: %w", err)
	}

	if err := tx.Commit().Error; err != nil {
		s.Log.Fatalf("failed to commit transaction: %+v", err)
		return nil, fmt.Errorf("failed Get Update Job transaction")
	}

	return converter.JobVacancyToResponse(jobWithRelations), nil
}

func (s *JobVacancyService) CloseJob(ctx context.Context, companyID, jobID int) error {
	s.Log.Info("starting Close Job function")
	s.Log.Infof("request received: %+v", companyID, jobID)

	tx := s.DB.WithContext(ctx).Begin()
	defer tx.Rollback()

	job, err := s.JobVacancyRepo.FindByID(jobID)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			s.Log.Warnf("job not found: %+v", err)
			return fmt.Errorf("job not found")
		}
		return err
	}

	if job.CompanyID != companyID {
		s.Log.Warnf("unauthorized: you can only close your own jobs")
		return fmt.Errorf("unauthorized: you can only close your own jobs")
	}

	// TODO: huh
	job.Status = constants.JOB_STATUS_CLOSED
	job.Active = constants.JOB_STATUS_CLOSED

	err = s.JobVacancyRepo.Update(s.DB, job)
	if err != nil {
		s.Log.Warnf("failed to update job to db: %+v", err)
		return fmt.Errorf("failed to update job to db: %+v", err)
	}

	if err := tx.Commit().Error; err != nil {
		s.Log.Warnf("failed to commit transaction: %+v", err)
		return fmt.Errorf("failed Close Job transaction")
	}

	return nil
}

func (s *JobVacancyService) DeleteJob(ctx context.Context, companyID, jobID int) error {
	s.Log.Info("starting Delete Job function")
	s.Log.Infof("request received: %+v", companyID, jobID)

	tx := s.DB.WithContext(ctx).Begin()
	defer tx.Rollback()

	job, err := s.JobVacancyRepo.FindByID(jobID)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			s.Log.Fatalf("job not found: %+v", err)
			return fmt.Errorf("job not found")
		}
		return err
	}

	if job.CompanyID != companyID {
		s.Log.Fatalf("unauthorized: you can only delete your own jobs")
		return fmt.Errorf("unauthorized: you can only delete your own jobs")
	}

	err = s.JobVacancyRepo.Delete(s.DB, job)
	if err != nil {
		return err
	}

	if err := tx.Commit().Error; err != nil {
		s.Log.Fatalf("failed to commit transaction: %+v", err)
		return fmt.Errorf("failed Delete Job transaction")
	}

	return nil
}
