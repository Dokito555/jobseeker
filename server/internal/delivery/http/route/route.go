package route

import (
	"github.com/Dokito555/jobseeker/server/internal/delivery/http"
	"github.com/gin-gonic/gin"
)

type RouteConfig struct {
	App              *gin.Engine
	HealthController *http.HealthController
	UserController   *http.UserController
	AuthMiddleware   gin.HandlerFunc
}

func (c *RouteConfig) Setup() {
	c.SetupPublicRoute()
	c.SetupAuthRoute()
}

func (c *RouteConfig) SetupPublicRoute() {
	c.App.POST("/api/healthcheck", c.HealthController.Healthcheck)
	c.App.POST("/api/v1/user/register", c.UserController.RegisterUser)
	c.App.POST("/api/v1/user/login", c.UserController.LoginUser)
}

func (c *RouteConfig) SetupAuthRoute() {
	authGroup := c.App.Group("/api/v1/user")
	authGroup.Use(c.AuthMiddleware)
	authGroup.DELETE("/logout", c.UserController.LogoutUser)
}
