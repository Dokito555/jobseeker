package route

import (
	"github.com/Dokito555/jobseeker/server/internal/delivery/http"
	"github.com/gin-gonic/gin"
)

type RouteConfig struct {
	App               *gin.Engine
	HealthController  *http.HealthController
	UserController    *http.UserController
	CompanyController *http.CompanyController
	JobVacancyController *http.JobVacancyController
	AuthMiddleware    gin.HandlerFunc
}

func (c *RouteConfig) Setup() {
	c.SetupPublicRoute()
	c.SetupAuthRoute()
	c.SetupCompanyRoute()
}

func (c *RouteConfig) SetupPublicRoute() {
	c.App.POST("/api/healthcheck", c.HealthController.Healthcheck)
	c.App.POST("/api/v1/user/register", c.UserController.RegisterUser)
	c.App.POST("/api/v1/user/login", c.UserController.LoginUser)
	c.App.POST("/api/v1/company/register", c.CompanyController.RegisterCompany)
	c.App.POST("/api/v1/company/login", c.CompanyController.LoginCompany)
	c.App.GET("/api/v1/jobs/:id", c.JobVacancyController.GetJobByID)
	c.App.GET("/api/v1/jobs", c.JobVacancyController.GetAllActiveJobs)
}

func (c *RouteConfig) SetupAuthRoute() {
	authGroup := c.App.Group("/api/v1/user")
	authGroup.Use(c.AuthMiddleware)
	authGroup.DELETE("/logout", c.UserController.LogoutUser)
	authGroup.GET("/jobs/recommended", c.JobVacancyController.GetRecommendedJobs)
}

func (c *RouteConfig) SetupCompanyRoute() {
	companyGroup := c.App.Group("/api/v1/company")
	companyGroup.Use(c.AuthMiddleware)
	companyGroup.DELETE("/logout", c.CompanyController.LogoutCompany)
	companyGroup.POST("/jobs", c.JobVacancyController.CreateJob)
	companyGroup.GET("/jobs", c.JobVacancyController.GetJobsByCompany)
	companyGroup.PUT("/jobs/:id", c.JobVacancyController.UpdateJob)
	companyGroup.PATCH("/jobs/:id/close", c.JobVacancyController.CloseJob)
	companyGroup.DELETE("/jobs/:id", c.JobVacancyController.DeleteJob)
}