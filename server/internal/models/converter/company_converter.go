package converter

import (
	"github.com/Dokito555/jobseeker/server/internal/entity"
	"github.com/Dokito555/jobseeker/server/internal/models"
)

func CompanyToResponse(c *entity.Company) *models.CompanyResponse {
	return &models.CompanyResponse{
		ID:           c.ID,
		Email:        c.Email,
		Name:         c.Name,
		Description:  c.Description,
		PhoneNumber:  c.PhoneNumber,
		Address:      c.Address,
		Token:        c.Token,
		RefreshToken: c.RefreshToken,
		CreatedAt:    c.CreatedAt,
		UpdatedAt:    c.UpdatedAt,
	}
}
