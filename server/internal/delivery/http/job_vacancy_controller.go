package http

import (
	"net/http"
	"strconv"

	"github.com/Dokito555/jobseeker/server/internal/models"
	"github.com/Dokito555/jobseeker/server/internal/services"
	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator/v10"
	"github.com/sirupsen/logrus"
)

type JobVacancyController struct {
	Log      *logrus.Logger
	Service  *services.JobVacancyService
	Validate *validator.Validate
}

func NewJobVacancyService(log *logrus.Logger, service *services.JobVacancyService, val *validator.Validate) *JobVacancyController {
	return &JobVacancyController{
		Log: log,
		Service: service,
		Validate: val,
	}
}

func (c *JobVacancyController) CreateJob(ctx *gin.Context) {
	req := new(models.CreateJobVacancyRequest)
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

	auth, exists := ctx.Get("auth")
	if !exists {
		c.Log.Warnf("unauthorized: %+v", exists)
		ctx.JSON(http.StatusUnauthorized, models.BaseResponse[interface{}]{
			Message: http.StatusUnauthorized,
			Data:    "unauthorized",
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

	rsp, err := c.Service.CreateJob(ctx.Request.Context(), auth, req)
	if err != nil {
		c.Log.Warnf("failed to create job: %+v", err)
		ctx.JSON(http.StatusInternalServerError, models.BaseResponse[interface{}]{
			Message: http.StatusInternalServerError,
			Error:   err.Error(),
			Data:    nil,
		})
		return
	}

	ctx.JSON(http.StatusCreated, models.BaseResponse[*models.JobVacancyResponse]{
		Message: http.StatusCreated,
		Data:    rsp,
	})
}

func (c *JobVacancyController) GetJobByID(ctx *gin.Context) {
	id, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		c.Log.Fatalf("invalid id: %+v", err)
		ctx.JSON(http.StatusBadRequest, models.BaseResponse[interface{}]{
			Message: http.StatusBadRequest,
			Error:   err.Error(),
			Data:    nil,
		})
		return
	}

	rsp, err := c.Service.GetJobByID(ctx.Request.Context(), id)
	if err != nil {
		c.Log.Warnf("failed to get job by id: %+v", err)
		ctx.JSON(http.StatusInternalServerError, models.BaseResponse[interface{}]{
			Message: http.StatusInternalServerError,
			Error:   err.Error(),
			Data:    nil,
		})
		return
	}

	ctx.JSON(http.StatusCreated, models.BaseResponse[*models.JobVacancyResponse]{
		Message: http.StatusCreated,
		Data:    rsp,
	})
}

func (c *JobVacancyController) GetJobsByCompany(ctx *gin.Context) {
	auth, exists := ctx.Get("auth")
	if !exists {
		c.Log.Warnf("unauthorized: %+v", exists)
		ctx.JSON(http.StatusUnauthorized, models.BaseResponse[interface{}]{
			Message: http.StatusUnauthorized,
			Data:    "unauthorized",
		})
		return
	}

	rsps, err := c.Service.GetJobsByCompany(ctx.Request.Context(), auth)
	if err != nil {
		c.Log.Warnf("failed to get jobs by company: %+v", err)
		ctx.JSON(http.StatusInternalServerError, models.BaseResponse[interface{}]{
			Message: http.StatusInternalServerError,
			Error:   err.Error(),
			Data:    nil,
		})
		return
	}

	ctx.JSON(http.StatusCreated, models.BaseResponse[[]models.JobVacancyResponse]{
		Message: http.StatusCreated,
		Data:    rsps,
	})
}

func (c *JobVacancyController) GetAllActiveJobs(ctx *gin.Context) {
	rsps, err := c.Service.GetAllActiveJobs(ctx.Request.Context())
	if err != nil {
		c.Log.Warnf("failed to get all active jobs: %+v", err)
		ctx.JSON(http.StatusInternalServerError, models.BaseResponse[interface{}]{
			Message: http.StatusInternalServerError,
			Error:   err.Error(),
			Data:    nil,
		})
		return
	}

	ctx.JSON(http.StatusCreated, models.BaseResponse[[]models.JobVacancyResponse]{
		Message: http.StatusCreated,
		Data:    rsps,
	})
}

func (c *JobVacancyController) GetRecommendedJobs(ctx *gin.Context) {
	auth, exists := ctx.Get("auth")
	if !exists {
		c.Log.Warnf("unauthorized: %+v", exists)
		ctx.JSON(http.StatusUnauthorized, models.BaseResponse[interface{}]{
			Message: http.StatusUnauthorized,
			Data:    "unauthorized",
		})
		return
	}

	limit := 20 
	if limitParam := ctx.Query("limit"); limitParam != "" {
		if l, err := strconv.Atoi(limitParam); err == nil {
			limit = l
		}
	}

	rsps, err := c.Service.GetRecommendedJobs(ctx.Request.Context(), auth, limit)
	if err != nil {
		c.Log.Warnf("failed to get recommended jobs: %+v", err)
		ctx.JSON(http.StatusInternalServerError, models.BaseResponse[interface{}]{
			Message: http.StatusInternalServerError,
			Error:   err.Error(),
			Data:    nil,
		})
		return
	}

	ctx.JSON(http.StatusCreated, models.BaseResponse[[]models.JobVacancyResponse]{
		Message: http.StatusCreated,
		Data:    rsps,
	})
}

func (c *JobVacancyController) UpdateJob(ctx *gin.Context) {

}

func (c *JobVacancyController) CloseJob(ctx *gin.Context) {

}

func (c *JobVacancyController) DeleteJob(ctx *gin.Context) {

}