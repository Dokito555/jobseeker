package converter

import (
	"github.com/Dokito555/jobseeker/server/internal/entity"
	"github.com/Dokito555/jobseeker/server/internal/models"
)

func UserToResponse(user *entity.User, userSkills []entity.UserSkillTag) *models.UserResponse {
	skillNames := make([]string, 0, len(userSkills))
	for _, us := range userSkills {
		skillNames = append(skillNames, us.SkillTag.Name)
	}
	return &models.UserResponse{
		ID:           user.ID,
		Email:        user.Email,
		Name:         user.Name,
		PhoneNumber:  user.PhoneNumber,
		Skills:       skillNames,
		Token:        user.Token,
		RefreshToken: user.RefreshToken,
		CreatedAt:    user.CreatedAt,
		UpdatedAt:    user.UpdatedAt,
	}
}
