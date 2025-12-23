package converter

import (
	"github.com/Dokito555/jobseeker/server/internal/entity"
	"github.com/Dokito555/jobseeker/server/internal/models"
)

func JobVacancyToResponse(job *entity.JobVacancy) *models.JobVacancyResponse {
	requiredSkills := make([]string, 0)
	requiredSkillsIDs := make([]int, 0)
	for _, jvs := range job.JobVacancySkills {
		requiredSkills = append(requiredSkills, jvs.SkillTag.Name)
		requiredSkillsIDs = append(requiredSkillsIDs, jvs.SkillTag.ID)
	}

	return &models.JobVacancyResponse{
		ID: job.ID,
		CompanyID: job.CompanyID,
		CompanyName: job.Company.Name,
		Position: job.Position,
		Description: job.Description,
		Location: job.Location,
		WorkType: job.WorkType,
		MinSalary: job.MinSalary,
		MaxSalary: job.MaxSalary,
		RequiredSkills: requiredSkills,
		Status: job.Status,
		CreatedAt: job.CreatedAt,
		UpdatedAt: job.UpdatedAt,
	}
}