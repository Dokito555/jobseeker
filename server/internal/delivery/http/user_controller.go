package http

import (
	"net/http"

	"github.com/Dokito555/jobseeker/server/internal/models"
	"github.com/Dokito555/jobseeker/server/internal/services"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"github.com/sirupsen/logrus"
)

type UserController struct {
	Log     *logrus.Logger
	Service *services.UserService
	Validate *validator.Validate
}

func NewUserController(log *logrus.Logger, service *services.UserService, validator *validator.Validate) *UserController {
	return &UserController{
		Log:     log,
		Service: service,
		Validate: validator,
	}
}

func (c *UserController) RegisterUser(ctx *gin.Context) {
	req := new(models.RegisterUserRequest)
	err := ctx.ShouldBindJSON(&req)
	if err != nil {
		c.Log.Fatalf("failed to bind request to JSON: %+v", err)
		ctx.JSON(http.StatusBadRequest, models.BaseResponse[interface{}]{
			Message: http.StatusBadRequest,
			Error: err.Error(),
			Data: nil,
		})
		return
	}

	err = c.Validate.Struct(req)
	if err != nil {
		c.Log.Warnf("invalid request: %+v", err)
		ctx.JSON(http.StatusBadRequest, models.BaseResponse[interface{}]{
			Message: http.StatusBadRequest,
			Error: err.Error(),
			Data: nil,
		})
		return
	}

	rsp, err := c.Service.RegisterUser(ctx.Request.Context(), req)
	if err != nil {
		c.Log.Warnf("failed to register user: %+v", err)
		ctx.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}

	ctx.JSON(http.StatusCreated, models.BaseResponse[string]{
		Message: http.StatusCreated,
		Data: rsp,
	})
}

func (c *UserController) LoginUser(ctx *gin.Context) {
	req := new(models.LoginUserRequest)
	err := ctx.ShouldBindJSON(&req)
	if err != nil {
		c.Log.Warnf("failed to bind request to JSON: %+v", err)
		ctx.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}

	err = c.Validate.Struct(req)
	if err != nil {
		c.Log.Warnf("invalid request: %+v", err)
		ctx.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}

	rsp, err := c.Service.Login(ctx.Request.Context(), req)
	if err != nil {
		c.Log.Warnf("failed to register user: %+v", err)
		ctx.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}

	ctx.JSON(http.StatusOK, models.BaseResponse[*models.UserResponse]{
		Message: http.StatusOK,
		Data: rsp,
	})
}

func (c *UserController) LogoutUser(ctx *gin.Context) {
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
		ctx.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}

	err = c.Service.Logout(ctx.Request.Context(), req.Token)
	if err != nil {
		c.Log.Warnf("failed to logout user: %+v", err)
		ctx.JSON(http.StatusInternalServerError, gin.H{
			"error": err.Error(),
		})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{
		"message": "successfully logout",
	})
}