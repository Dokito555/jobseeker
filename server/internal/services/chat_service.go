package services

import (
	"context"
	"errors"
	"fmt"

	"github.com/Dokito555/jobseeker/server/internal/entity"
	"github.com/Dokito555/jobseeker/server/internal/models"
	"github.com/Dokito555/jobseeker/server/internal/repositories"
	"github.com/Dokito555/jobseeker/server/utils/constants"
	"github.com/go-playground/validator/v10"
	"github.com/sirupsen/logrus"
	"gorm.io/gorm"
)

type ChatService struct {
	Log               *logrus.Logger
	Validate          *validator.Validate
	DB                *gorm.DB
	ChatRepo          *repositories.ChatRepository
	JobVRepo          *repositories.JobVacancyRepository
	UserRepo          *repositories.UserRepository
	CompanyRepo       *repositories.CompanyRepository
	EncryptionService *EncryptionService
}

func NewChatService(log *logrus.Logger, validator *validator.Validate, db *gorm.DB, chatRepo *repositories.ChatRepository, jobVRepo *repositories.JobVacancyRepository, userRepo *repositories.UserRepository, companyRepo *repositories.CompanyRepository, encryptionService *EncryptionService) *ChatService {
	return &ChatService{
		Log:               log,
		Validate:          validator,
		DB:                db,
		ChatRepo:          chatRepo,
		JobVRepo:          jobVRepo,
		UserRepo:          userRepo,
		CompanyRepo:       companyRepo,
		EncryptionService: encryptionService,
	}
}

func (s *ChatService) SendMessage(ctx context.Context, senderID int, senderType string, req *models.SendMessageRequest) (*models.ChatResponse, error) {
	s.Log.Info("starting Send Message function")
	s.Log.Infof("request received: senderID=%+v, senderType=%+v, req=%+v", senderID, senderType,req)

	tx := s.DB.WithContext(ctx).Begin()
	defer tx.Rollback()

	err := s.Validate.Struct(req)
	if err != nil {
		s.Log.Warnf("invalid request")
		return nil, fmt.Errorf("invalid request")
	}

	job, err := s.JobVRepo.FindByID(req.JobVacancyID)
	if err != nil {
		s.Log.Warnf("job vacancy not found")
		return nil, errors.New("job vacancy not found")
	}

	if senderType == "company" && job.CompanyID != senderID {
		s.Log.Warnf("unauthorized: you can only chat for your own job vacancies")
		return nil, errors.New("unauthorized: you can only chat for your own job vacancies")
	}

	encryptedMsg, iv, err := s.EncryptionService.EncryptMessage(req.Message, req.JobVacancyID)
	if err != nil {
		s.Log.Errorf("Failed to encrypt message: %v", err)
		return nil, errors.New("failed to encrypt message")
	}

	chat := &entity.Chat{
		JobVacancyID:     req.JobVacancyID,
		SenderID:         senderID,
		SenderType:       senderType,
		EncryptedMessage: encryptedMsg,
		MessageIV:        iv,
		IsRead:           false,
	}

	if err := s.ChatRepo.Create(s.DB, chat); err != nil {
		s.Log.Errorf("Failed to save chat: %v", err)
		return nil, errors.New("failed to save message")
	}

	senderName := ""

	if senderType == constants.USER_ROLE {
		user, _ := s.UserRepo.FindByID(senderID)
		if user != nil {
			senderName = user.Name
		}
	} else {
		company, _ := s.CompanyRepo.FindByID(senderID)
		if company != nil {
			senderName = company.Name
		}
	}

	if err := tx.Commit().Error; err != nil {
		s.Log.Fatalf("failed to commit transaction: %+v", err)
		return nil, fmt.Errorf("failed send message transaction")
	}

	return &models.ChatResponse{
		ID:           chat.ID,
		JobVacancyID: chat.JobVacancyID,
		SenderID:     chat.SenderID,
		SenderType:   chat.SenderType,
		SenderName:   senderName,
		Message:      req.Message,
		IsRead:       chat.IsRead,
		CreatedAt:    chat.CreatedAt,
	}, nil
}

func (s *ChatService) GetChatHistory(ctx context.Context, jobVacancyID, userID int, userType string) ([]models.ChatResponse, error) {
	s.Log.Info("starting Get Chat History function")
	s.Log.Infof("request received: jobVacancyID=%+v, userID=%+v, userType=%+v", jobVacancyID, userID, userType)

	tx := s.DB.WithContext(ctx).Begin()
	defer tx.Rollback()

	job, err := s.JobVRepo.FindByID(jobVacancyID)
	if err != nil {
		s.Log.Warnf("job vacancy not found")
		return nil, errors.New("job vacancy not found")
	}

	if userType == "company" && job.CompanyID != userID {
		s.Log.Warnf("unauthorized")
		return nil, errors.New("unauthorized")
	}

	chats, err := s.ChatRepo.FindByJobVacancy(jobVacancyID)
	if err != nil {
		s.Log.Warnf("failed to find job vacancy: %+v", err)
		return nil, err
	}

	responses := make([]models.ChatResponse, 0, len(chats))
	for _, chat := range chats {
		plaintext, err := s.EncryptionService.DecryptMessage(chat.EncryptedMessage, chat.MessageIV, chat.JobVacancyID)
		if err != nil {
			s.Log.Errorf("Failed to decrypt message %d: %v", chat.ID, err)
			// skip corrupted msg
			continue
		}

		senderName := ""
		if chat.SenderType == constants.USER_ROLE {
			user, _ := s.UserRepo.FindByID(chat.SenderID)
			if user != nil {
				senderName = user.Name
			}
		} else {
			company, _ := s.CompanyRepo.FindByID(chat.SenderID)
			if company != nil {
				senderName = company.Name
			}
		}

		responses = append(responses, models.ChatResponse{
			ID:           chat.ID,
			JobVacancyID: chat.JobVacancyID,
			SenderID:     chat.SenderID,
			SenderType:   chat.SenderType,
			SenderName:   senderName,
			Message:      plaintext,
			IsRead:       chat.IsRead,
			CreatedAt:    chat.CreatedAt,
		})
	}

	oppositeType := constants.COMPANY_ROLE
	if userType == constants.COMPANY_ROLE {
		oppositeType = constants.USER_ROLE
	}

	err = s.ChatRepo.MarkAsRead(jobVacancyID, oppositeType)
	if err != nil {
		s.Log.Warnf("failed mark as read: %+v", err)
		return nil, err
	}

	if err := tx.Commit().Error; err != nil {
		s.Log.Fatalf("failed to commit transaction: %+v", err)
		return nil, fmt.Errorf("failed send message transaction")
	}

	return responses, nil
}

func (s *ChatService) GetNewMessages(ctx context.Context, jobVacancyID, afterID int) ([]models.ChatResponse, error) {
	s.Log.Info("starting Get New Messages function")
	s.Log.Infof("request received: jobVacancyID=%+v, afterID=%+v", jobVacancyID, afterID)

	tx := s.DB.WithContext(ctx).Begin()
	defer tx.Rollback()

	chats, err := s.ChatRepo.FindByJobVacancyAfter(jobVacancyID, afterID, 50)
	if err != nil {
		s.Log.Warnf("job vacancy after not found")
		return nil, err
	}

	responses := make([]models.ChatResponse, 0, len(chats))
	for _, chat := range chats {
		plaintext, err := s.EncryptionService.DecryptMessage(chat.EncryptedMessage, chat.MessageIV, chat.JobVacancyID)
		if err != nil {
			s.Log.Errorf("Failed to decrypt message %d: %v", chat.ID, err)
			continue
		}

		senderName := ""
		if chat.SenderType == constants.USER_ROLE {
			user, _ := s.UserRepo.FindByID(chat.SenderID)
			if user != nil {
				s.Log.Infof("sender name user: %v", user.Name)
				senderName = user.Name
			}
		} else {
			company, _ := s.CompanyRepo.FindByID(chat.SenderID)
			if company != nil {
				s.Log.Infof("sender name company: %v", company.Name)
				senderName = company.Name
			}
		}

		responses = append(responses, models.ChatResponse{
			ID:           chat.ID,
			JobVacancyID: chat.JobVacancyID,
			SenderID:     chat.SenderID,
			SenderType:   chat.SenderType,
			SenderName:   senderName,
			Message:      plaintext,
			IsRead:       chat.IsRead,
			CreatedAt:    chat.CreatedAt,
		})
	}

	return responses, nil
}

func (s *ChatService) MarkMessagesAsRead(ctx context.Context, jobVacancyID int, userType string) error {
	s.Log.Info("starting Mark Messages as Read function")
	s.Log.Infof("request received: jobVacancyID=%+v, userType=%+v", jobVacancyID, userType)

	oppositeType := constants.COMPANY_ROLE
	if userType == constants.COMPANY_ROLE {
		oppositeType = constants.USER_ROLE
	}

	return s.ChatRepo.MarkAsRead(jobVacancyID, oppositeType)
}

// func (s *ChatService) GetUserChatThreads(ctx context.Context, userID int) ([]models.ChatThreadResponse, error)

// func (s *ChatService) GetCompanyChatThreads(ctx context.Context, companyID int) ([]models.ChatThreadResponse, error)
