package converter

import (
	"strings"

	"github.com/Dokito555/jobseeker/server/internal/entity"
	"github.com/Dokito555/jobseeker/server/internal/models"
)

func UserToResponse(user *entity.User) *models.UserResponse {
	return &models.UserResponse{
		ID:           user.ID,
		Email:        user.Email,
		Name:         user.Name,
		PhoneNumber:  user.PhoneNumber,
		// TODO: return skill array
		Skills:       strings.Split(user.Skills, ","),
		Token:        user.Token,
		RefreshToken: user.RefreshToken,
		CreatedAt:    user.CreatedAt,
		UpdatedAt:    user.UpdatedAt,
	}
}