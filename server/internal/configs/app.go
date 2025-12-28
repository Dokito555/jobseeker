package configs

import (

	"github.com/Dokito555/jobseeker/server/internal/delivery/http"
	"github.com/Dokito555/jobseeker/server/internal/delivery/http/middleware"
	"github.com/Dokito555/jobseeker/server/internal/delivery/http/route"
	"github.com/Dokito555/jobseeker/server/internal/repositories"
	"github.com/Dokito555/jobseeker/server/internal/services"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"github.com/sirupsen/logrus"
	"github.com/spf13/viper"
	"gorm.io/gorm"
)

type BootstrapConfig struct {
	DB       *gorm.DB
	App      *gin.Engine
	Log      *logrus.Logger
	Validate *validator.Validate
	Config   *viper.Viper
}

func Bootstrap(config *BootstrapConfig) {
	// setup repo
	userRepo := repositories.NewUserRepository(config.Log, config.DB)
	skillTagRepo := repositories.NewSkillTagRepository(config.Log, config.DB)
	userSkillTagRepo := repositories.NewUserSkillTagRepository(config.Log, config.DB)
	companyRepo := repositories.NewCompanyRepository(config.Log, config.DB)
	jobVRepo := repositories.NewJobVacancyRepository(config.Log, config.DB)
	jobVSkillRepo := repositories.NewJobVacancySkillTagRepository(config.Log, config.DB)
	chatRepo := repositories.NewChatRepository(config.Log, config.DB)

	// setup services
	tokenService := services.NewTokenService(config.Log, config.Config)
	userService := services.NewUserService(config.Log, config.Validate, config.Config, config.DB, userRepo, skillTagRepo, tokenService)
	companyService := services.NewCompanyService(config.Log, config.Validate, config.Config, config.DB, companyRepo, tokenService)
	jobVService := services.NewJobVacancyService(config.Log, config.Validate, config.DB, config.Config, jobVRepo, jobVSkillRepo, userSkillTagRepo)
	encryptionKey := config.Config.GetString("ENCRYPTION_MASTER_KEY")
	if encryptionKey == "" {
		config.Log.Fatal("ENCRYPTION_MASTER_KEY is required")
	}
	encryptionService, err := services.NewEncryptionService(config.Log, encryptionKey)
	if err != nil {
		config.Log.Fatalf("Failed to initialize encryption service: %v", err)
	}
	chatService := services.NewChatService(config.Log, config.Validate, config.DB, chatRepo, jobVRepo, userRepo, companyRepo, encryptionService)

	// setup controllers
	healthController := http.NewHealthController(config.Log)
	userController := http.NewUserController(config.Log, userService, config.Validate)
	companyController := http.NewCompanyController(config.Log, companyService, config.Validate)
	jobVController := http.NewJobVacancyController(config.Log, jobVService, config.Validate)
	chatController := http.NewChatController(config.Log, chatService, config.Validate)

	// setup middleware
	authMiddleware := middleware.NewAuth(userService, tokenService)

	// route config
	routeConfig := route.RouteConfig{
		App:                  config.App,
		HealthController:     healthController,
		UserController:       userController,
		CompanyController:    companyController,
		JobVacancyController: jobVController,
		ChatController:       chatController,
		AuthMiddleware:       authMiddleware,
	}

	routeConfig.Setup()
}
