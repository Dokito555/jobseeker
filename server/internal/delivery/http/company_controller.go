package http

import (
	"net/http"

	"github.com/Dokito555/jobseeker/server/internal/models"
	"github.com/Dokito555/jobseeker/server/internal/services"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"github.com/sirupsen/logrus"
)

type CompanyController struct {
	Log      *logrus.Logger
	Service  *services.CompanyService
	Validate *validator.Validate
}

func NewCompanyController(log *logrus.Logger, service *services.CompanyService, validate *validator.Validate) *CompanyController {
	return &CompanyController{
		Log:      log,
		Service:  service,
		Validate: validate,
	}
}

func (c *CompanyController) RegisterCompany(ctx *gin.Context) {
	req := new(models.RegisterCompanyRequest)
	err := ctx.ShouldBindJSON(&req)
	if err != nil {
		c.Log.Fatalf("failed to bind request to JSON: %+v", err)
		ctx.JSON(http.StatusBadRequest, models.BaseResponse[interface{}]{
			Message: http.StatusBadRequest,
			Error:   err.Error(),
			Data:    nil,
		})
		return
	}

	err = c.Validate.Struct(req)
	if err != nil {
		c.Log.Warnf("invalid request: %+v", err)
		ctx.JSON(http.StatusBadRequest, models.BaseResponse[interface{}]{
			Message: http.StatusBadRequest,
			Error:   err.Error(),
			Data:    nil,
		})
		return
	}

	rsp, err := c.Service.RegisterCompany(ctx.Request.Context(), req)
	if err != nil {
		c.Log.Warnf("failed to register company: %+v", err)
		ctx.JSON(http.StatusInternalServerError, models.BaseResponse[interface{}]{
			Message: http.StatusBadRequest,
			Error:   err.Error(),
			Data:    nil,
		})
		return
	}

	ctx.JSON(http.StatusCreated, models.BaseResponse[string]{
		Message: http.StatusCreated,
		Data:    rsp,
	})
}

func (c *CompanyController) LoginCompany(ctx *gin.Context) {
	req := new(models.LoginCompanyRequest)
	err := ctx.ShouldBindJSON(&req)
	if err != nil {
		c.Log.Warnf("failed to bind request to JSON: %+v", err)
		ctx.JSON(http.StatusBadRequest, models.BaseResponse[interface{}]{
			Message: http.StatusBadRequest,
			Error:   err.Error(),
			Data:    nil,
		})
		return
	}

	err = c.Validate.Struct(req)
	if err != nil {
		c.Log.Warnf("invalid request: %+v", err)
		ctx.JSON(http.StatusBadRequest, models.BaseResponse[interface{}]{
			Message: http.StatusBadRequest,
			Error:   err.Error(),
			Data:    nil,
		})
		return
	}

	rsp, err := c.Service.LoginCompany(ctx.Request.Context(), req)
	if err != nil {
		c.Log.Warnf("failed to login company: %+v", err)
		ctx.JSON(http.StatusInternalServerError, models.BaseResponse[interface{}]{
			Message: http.StatusInternalServerError,
			Error:   err.Error(),
			Data:    nil,
		})
		return
	}

	ctx.JSON(http.StatusOK, models.BaseResponse[*models.CompanyResponse]{
		Message: http.StatusOK,
		Data:    rsp,
	})
}

func (c *CompanyController) LogoutCompany(ctx *gin.Context) {
	req := new(models.TokenRequest)
	token := ctx.GetHeader("Authorization")
	if token == "" {
		c.Log.Fatalf("token is empty")
		ctx.JSON(http.StatusUnauthorized, gin.H{})
		return
	}

	req.Token = token

	err := c.Validate.Struct(req)
	if err != nil {
		c.Log.Warnf("invalid request: %+v", err)
		ctx.JSON(http.StatusBadRequest, models.BaseResponse[interface{}]{
			Message: http.StatusBadRequest,
			Error:   err.Error(),
			Data:    nil,
		})
		return
	}

	err = c.Service.Logout(ctx.Request.Context(), req.Token)
	if err != nil {
		c.Log.Warnf("failed to logout company: %+v", err)
		ctx.JSON(http.StatusInternalServerError, models.BaseResponse[interface{}]{
			Message: http.StatusInternalServerError,
			Error:   err.Error(),
			Data:    nil,
		})
		return
	}

	ctx.JSON(http.StatusCreated, models.BaseResponse[string]{
		Message: http.StatusCreated,
		Data:    "successfully logged out",
	})
}