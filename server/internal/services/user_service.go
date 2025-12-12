package services

import (
	"context"
	"fmt"
	"time"

	"github.com/Dokito555/jobseeker/server/internal/entity"
	"github.com/Dokito555/jobseeker/server/internal/models"
	"github.com/Dokito555/jobseeker/server/internal/models/converter"
	"github.com/Dokito555/jobseeker/server/internal/repositories"
	"github.com/Dokito555/jobseeker/server/utils/constants"
	"github.com/go-playground/validator/v10"
	"github.com/sirupsen/logrus"
	"github.com/spf13/viper"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

type UserService struct {
	Log          *logrus.Logger
	Validate     *validator.Validate
	Config       *viper.Viper
	DB           *gorm.DB
	UserRepo     *repositories.UserRepository
	SkillTagRepo *repositories.SkillTagRepository
	TokenService *TokenService
}

func NewUserService(log *logrus.Logger, validate *validator.Validate, config *viper.Viper, db *gorm.DB, r *repositories.UserRepository, tokenService *TokenService) *UserService {
	return &UserService{
		Log:          log,
		Validate:     validate,
		Config:       config,
		DB:           db,
		UserRepo:     r,
		TokenService: tokenService,
	}
}

func (s *UserService) RegisterUser(ctx context.Context, req *models.RegisterUserRequest) (string, error) {
	s.Log.Info("starting Register function")
	s.Log.Infof("request received: %+v", req)

	tx := s.DB.WithContext(ctx).Begin()
	defer tx.Rollback()

	err := s.Validate.Struct(req)
	if err != nil {
		s.Log.Fatalf("invalid request: %+v", err)
		return "", fmt.Errorf("invalid request")
	}

	if req.Password == "" || req.Email == "" {
		s.Log.Warnf("password or email is empty")
		return "", fmt.Errorf("password or email is empty")
	}

	user, err := s.UserRepo.FindByEmail(req.Email)
	if err != nil {
		s.Log.Warnf("error fetching user from database: %v", err)
		return "", fmt.Errorf("failed to fetch user from database")
	}

	if user != nil {
		s.Log.Warnf("user already exist")
		return "", fmt.Errorf("email already exist")
	}

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		s.Log.Fatalf("failed to hash password")
		return "", fmt.Errorf("failed to hash password")
	}

	user = &entity.User{
		Email:       req.Email,
		Password:    string(hashedPassword),
		Name:        req.Name,
		PhoneNumber: req.PhoneNumber,
	}

	err = s.UserRepo.Create(s.DB, user)
	if err != nil {
		s.Log.Fatalf("failed to create user to db: %v", err)
		return "", fmt.Errorf("failed to create user to database")
	}

	if len(req.SkillIds) > 0 {
		userSkills := make([]entity.UserSkillTag, 0, len(req.SkillIds))
		for _, skillID := range req.SkillIds {
			userSkills = append(userSkills, entity.UserSkillTag{
				UserID:     user.ID,
				SkillTagID: skillID,
				CreatedAt:  time.Now(),
			})
		}

		err := s.SkillTagRepo.CreateBulk(userSkills)
		if err != nil {
			s.Log.Fatalf("failed to create bulk skill tag: %v", err)
			return "", fmt.Errorf("failed to create skill tag in bulk")
		}
	}

	if err := tx.Commit().Error; err != nil {
		s.Log.Fatalf("failed to commit transaction: %+v", err)
		return "", fmt.Errorf("failed register user transaction")
	}

	return "user successfully registered", nil
}

func (s *UserService) Login(ctx context.Context, req *models.LoginUserRequest) (*models.UserResponse, error) {
	s.Log.Info("starting Login function")
	s.Log.Infof("request received: %+v", req)

	tx := s.DB.WithContext(ctx).Begin()
	defer tx.Rollback()

	err := s.Validate.Struct(req)
	if err != nil {
		s.Log.Fatalf("invalid request: %+v", err)
		return nil, fmt.Errorf("invalid request")
	}

	if req.Password == "" || req.Email == "" {
		s.Log.Warnf("password or email is empty")
		return nil, fmt.Errorf("password or email is empty")
	}

	user, err := s.UserRepo.FindByEmail(req.Email)
	if err != nil {
		s.Log.Warnf("error fetching user from database: %v", err)
		return nil, fmt.Errorf("failed to fetch user from database")
	}

	err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(req.Password))
	if err != nil {
		s.Log.Fatalf("failed to compare password")
		return nil, fmt.Errorf("failed to compare password")
	}

	token, err := s.TokenService.GenerateToken(ctx, user.ID, constants.TOKEN_TYPE_TOKEN, user.Email, user.Name)
	if err != nil {
		s.Log.Fatalf("failed to generate token: %v", err)
		return nil, fmt.Errorf("failed to generate token")
	}

	refreshToken, err := s.TokenService.GenerateToken(ctx, user.ID, constants.TOKEN_TYPE_TOKEN, user.Email, user.Name)
	if err != nil {
		s.Log.Fatalf("failed to generate token: %v", err)
		return nil, fmt.Errorf("failed to generate token")
	}

	user.Token = token
	user.RefreshToken = refreshToken

	err = s.UserRepo.Update(s.DB, user)
	if err != nil {
		s.Log.Fatalf("failed to update user: %v", err)
		return nil, fmt.Errorf("failed to update user")
	}

	if err := tx.Commit().Error; err != nil {
		s.Log.Fatalf("failed to commit transaction: %+v", err)
		return nil, fmt.Errorf("failed to login user transaction")
	}

	return converter.UserToResponse(user, user.UserSkills), nil
}