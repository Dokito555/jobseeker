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

	// setup services
	tokenService := services.NewTokenService(config.Log, config.Config)
	userService := services.NewUserService(config.Log, config.Validate, config.Config, config.DB, userRepo, skillTagRepo, tokenService)

	// setup controllers
	healthController := http.NewHealthController(config.Log)
	userController := http.NewUserController(config.Log, userService, config.Validate)

	// setup middleware
	middleeware := middleware.NewAuth(userService, tokenService)

	// route config
	routeConfig := route.RouteConfig{
		App:              config.App,
		HealthController: healthController,
		UserController:   userController,
		AuthMiddleware:   middleeware,
	}

	routeConfig.Setup()
}
