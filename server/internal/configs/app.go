package configs

import (
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"github.com/sirupsen/logrus"
	"github.com/spf13/viper"
	"gorm.io/gorm"
)

type BootstrapConfig struct {
	DB          *gorm.DB
	App         *gin.Engine
	Log         *logrus.Logger
	Validate    *validator.Validate
	Config      *viper.Viper
}

func Bootstrap(config *BootstrapConfig) {
	// setup repo
	

	// setup services
	// tokenService := services.NewTokenService(config.Log, config.Config)

	// setup controllers
	// healthController := http.NewHealthController(config.Log)


	// setup middleware
	// middleeware := middleware.NewAuth(, tokenService)

	// route config
	// routeConfig := route.RouteConfig{
	// 	App:              config.App,
	// 	HealthController: healthController,
	// 	AuthMiddleware: middleeware,
	// }


	// routeConfig.Setup()
}
