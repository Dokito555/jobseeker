package services

import (
	"context"
	"fmt"

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

type CompanyService struct {
	Log          *logrus.Logger
	Validate     *validator.Validate
	Config       *viper.Viper
	DB           *gorm.DB
	CompanyRepo  *repositories.CompanyRepository
	TokenService *TokenService
}

func NewCompanyService(log *logrus.Logger, validate *validator.Validate, config *viper.Viper, db *gorm.DB, r *repositories.CompanyRepository, tokenService *TokenService) *CompanyService {
	return &CompanyService{
		Log:          log,
		Validate:     validate,
		Config:       config,
		DB:           db,
		CompanyRepo:  r,
		TokenService: tokenService,
	}
}

func (s *CompanyService) RegisterCompany(ctx context.Context, req *models.RegisterCompanyRequest) (string, error) {
	s.Log.Info("starting Register Company function")
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

	company, err := s.CompanyRepo.FindByEmail(req.Email)
	if err != nil {
		s.Log.Warnf("error fetching company from database: %v", err)
		return "", fmt.Errorf("failed to fetch user from database")
	}

	if company != nil {
		s.Log.Warnf("company already exist")
		return "", fmt.Errorf("company already exist")
	}

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		s.Log.Fatalf("failed to hash password")
		return "", fmt.Errorf("failed to hash password")
	}

	company = &entity.Company{
		Email:       req.Email,
		Password:    string(hashedPassword),
		Name:        req.Name,
		Address:     req.Address,
		PhoneNumber: req.PhoneNumber,
		Description: req.Description,
	}

	err = s.CompanyRepo.Create(s.DB, company)
	if err != nil {
		s.Log.Fatalf("failed to create company to db: %v", err)
		return "", fmt.Errorf("failed to create company to database")
	}

	if err := tx.Commit().Error; err != nil {
		s.Log.Fatalf("failed to commit transaction: %+v", err)
		return "", fmt.Errorf("failed register company transaction")
	}

	return "company successfully registered", nil
}

func (s *CompanyService) LoginCompany(ctx context.Context, req *models.LoginCompanyRequest) (*models.CompanyResponse, error) {
	s.Log.Info("starting Login Company function")
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

	company, err := s.CompanyRepo.FindByEmail(req.Email)
	if err != nil {
		s.Log.Warnf("error fetching company from database: %v", err)
		return nil, fmt.Errorf("failed to fetch company from database")
	}

	err = bcrypt.CompareHashAndPassword([]byte(company.Password), []byte(req.Password))
	if err != nil {
		s.Log.Warnf("failed to compare password")
		return nil, fmt.Errorf("failed to compare password")
	}

	token, err := s.TokenService.GenerateToken(ctx, company.ID, constants.TOKEN_TYPE_TOKEN, company.Email, company.Name, constants.COMPANY_ROLE)
	if err != nil {
		s.Log.Fatalf("failed to generate token: %v", err)
		return nil, fmt.Errorf("failed to generate token")
	}

	
	refreshToken, err := s.TokenService.GenerateToken(ctx, company.ID, constants.TOKEN_TYPE_REFRESH, company.Email, company.Name, constants.COMPANY_ROLE)
	if err != nil {
		s.Log.Fatalf("failed to generate token: %v", err)
		return nil, fmt.Errorf("failed to generate token")
	}

	company.Token = token
	company.RefreshToken = refreshToken

	err = s.CompanyRepo.Update(s.DB, company)
	if err != nil {
		s.Log.Fatalf("failed to update company: %v", err)
		return nil, fmt.Errorf("failed to update company")
	}

	if err := tx.Commit().Error; err != nil {
		s.Log.Fatalf("failed to commit transaction: %+v", err)
		return nil, fmt.Errorf("failed to login company transaction")
	}

	return converter.CompanyToResponse(company), nil
}

func (s *CompanyService) Logout(ctx context.Context, token string) error {
	s.Log.Info("starting Logout function")
	s.Log.Infof("request received: %+v", token)

	tx := s.DB.WithContext(ctx).Begin()
	defer tx.Rollback()

	if token == "" {
		s.Log.Fatal("token is empty")
		return fmt.Errorf("token is empty")
	}

	user, err := s.CompanyRepo.FindByToken(token)
	if err != nil {
		s.Log.Fatalf("couldn't find company by token %v", err)
		return err
	}

	user.Token = ""

	err = s.CompanyRepo.Update(s.DB, user)
	if err != nil {
		s.Log.Fatalf("couldn't update company token %v", err)
		return fmt.Errorf("failed to update company token")
	}

	if err := tx.Commit().Error; err != nil {
		s.Log.Fatalf("failed to commit transaction: %+v", err)
		return fmt.Errorf("failed to logout company transaction")
	}

	return nil
}
