package http

import (
	"net/http"
	"strconv"

	"github.com/Dokito555/jobseeker/server/internal/delivery/http/middleware"
	"github.com/Dokito555/jobseeker/server/internal/models"
	"github.com/Dokito555/jobseeker/server/internal/services"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"github.com/sirupsen/logrus"
)

type ChatController struct {
	Log *logrus.Logger
	Service *services.ChatService
	Validate *validator.Validate
}

func NewChatController(log *logrus.Logger, service *services.ChatService, validate *validator.Validate) *ChatController {
	return &ChatController{
		Log: log,
		Service: service,
		Validate: validate,
	}
}

func (c *ChatController) SendMessage(ctx *gin.Context) {
	auth := middleware.GetProfile(ctx)
	id, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		c.Log.Warnf("invalid id: %+v", err)
		ctx.JSON(http.StatusBadRequest, models.BaseResponse[interface{}]{
			Message: http.StatusBadRequest,
			Error:   err.Error(),
			Data:    nil,
		})
		return
	}
	
	req := new(models.SendMessageRequest)
	req.JobVacancyID = id
	err = ctx.ShouldBindJSON(&req)
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

	rsp, err := c.Service.SendMessage(ctx.Request.Context(), auth.UserID, auth.Role, req)
	if err != nil {
		c.Log.Warnf("failed to send message: %+v", err)
		ctx.JSON(http.StatusInternalServerError, models.BaseResponse[interface{}]{
			Message: http.StatusInternalServerError,
			Error:   err.Error(),
			Data:    nil,
		})
		return
	}

	ctx.JSON(http.StatusCreated, models.BaseResponse[*models.ChatResponse]{
		Message: http.StatusCreated,
		Data:    rsp,
	})
}	

func (c *ChatController) GetChatHistory(ctx *gin.Context) {
	auth := middleware.GetProfile(ctx)
	id, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		c.Log.Warnf("invalid id: %+v", err)
		ctx.JSON(http.StatusBadRequest, models.BaseResponse[interface{}]{
			Message: http.StatusBadRequest,
			Error:   err.Error(),
			Data:    nil,
		})
		return
	}
	
	rsps, err := c.Service.GetChatHistory(ctx.Request.Context(), id, auth.UserID, auth.Role)
	if err != nil {
		c.Log.Warnf("failed to get chat history: %+v", err)
		ctx.JSON(http.StatusInternalServerError, models.BaseResponse[interface{}]{
			Message: http.StatusInternalServerError,
			Error:   err.Error(),
			Data:    nil,
		})
		return
	}

	ctx.JSON(http.StatusCreated, models.BaseResponse[[]models.ChatResponse]{
		Message: http.StatusCreated,
		Data:    rsps,
	})
}

func (c *ChatController) PollNewMessages(ctx *gin.Context) {
	id, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		c.Log.Warnf("invalid id: %+v", err)
		ctx.JSON(http.StatusBadRequest, models.BaseResponse[interface{}]{
			Message: http.StatusBadRequest,
			Error:   err.Error(),
			Data:    nil,
		})
		return
	}

	afterID := 0
	if afterIDStr := ctx.Query("after_id"); afterIDStr != "" {
		afterID, _ = strconv.Atoi(afterIDStr)
	}

	rsps, err := c.Service.GetNewMessages(ctx.Request.Context(), id, afterID)
	if err != nil {
		c.Log.Warnf("failed to get new messages: %+v", err)
		ctx.JSON(http.StatusInternalServerError, models.BaseResponse[interface{}]{
			Message: http.StatusInternalServerError,
			Error:   err.Error(),
			Data:    nil,
		})
		return
	}

	ctx.JSON(http.StatusCreated, models.BaseResponse[[]models.ChatResponse]{
		Message: http.StatusCreated,
		Data:    rsps,
	})
}

func (c *ChatController) MarkAsRead(ctx *gin.Context) {
	auth := middleware.GetProfile(ctx)
	id, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		c.Log.Warnf("invalid id: %+v", err)
		ctx.JSON(http.StatusBadRequest, models.BaseResponse[interface{}]{
			Message: http.StatusBadRequest,
			Error:   err.Error(),
			Data:    nil,
		})
		return
	}

	err = c.Service.MarkMessagesAsRead(ctx.Request.Context(), id, auth.Role)
	if err != nil {
		c.Log.Warnf("failed to mark messages as read: %+v", err)
		ctx.JSON(http.StatusInternalServerError, models.BaseResponse[interface{}]{
			Message: http.StatusInternalServerError,
			Error:   err.Error(),
			Data:    nil,
		})
		return
	}

	ctx.JSON(http.StatusCreated, models.BaseResponse[string]{
		Message: http.StatusCreated,
		Data:    "mark as read",
	})
}