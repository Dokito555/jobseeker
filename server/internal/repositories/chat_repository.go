package repositories

import (
	"github.com/Dokito555/jobseeker/server/internal/entity"
	"github.com/sirupsen/logrus"
	"gorm.io/gorm"
)

type ChatRepository struct {
	Repository[entity.Chat]
	Log *logrus.Logger
	DB  *gorm.DB
}

func NewChatRepository(log *logrus.Logger, db *gorm.DB) *ChatRepository {
	return &ChatRepository{
		Repository: Repository[entity.Chat]{DB: db},
		Log:        log,
		DB:         db,
	}
}

func (r *ChatRepository) FindByJobVacancy(jobVacancyID int) ([]entity.Chat, error) {
	var chats []entity.Chat
	err := r.DB.Where("job_vacancy_id = ?", jobVacancyID).
		Order("created_at ASC").
		Find(&chats).Error
	return chats, err
}

func (r *ChatRepository) FindByJobVacancyAfter(jobVacancyID int, afterID int, limit int) ([]entity.Chat, error) {
	var chats []entity.Chat
	err := r.DB.Where("job_vacancy_id = ? AND id > ?", jobVacancyID, afterID).
		Order("created_at ASC").
		Limit(limit).
		Find(&chats).Error
	return chats, err
}

func (r *ChatRepository) MarkAsRead(jobVacancyID int, senderType string) error {
	return r.DB.Model(&entity.Chat{}).
		Where("job_vacancy_id = ? AND sender_type = ? AND is_read = ?", jobVacancyID, senderType, false).
		Update("is_read", true).Error
}

func (r *ChatRepository) CountUnread(jobVacancyID int, senderType string) (int64, error) {
	var count int64
	err := r.DB.Model(&entity.Chat{}).
		Where("job_vacancy_id = ? AND sender_type = ? AND is_read = ?", jobVacancyID, senderType, false).
		Count(&count).Error
	return count, err
}

func (r *ChatRepository) GetUserChatThreads(userID int) ([]entity.Chat, error) {
	var chats []entity.Chat
	
	err := r.DB.Raw(`
		SELECT DISTINCT ON (job_vacancy_id) *
		FROM chats
		WHERE job_vacancy_id IN (
			SELECT DISTINCT job_vacancy_id 
			FROM chats 
			WHERE sender_id = ? AND sender_type = 'user'
		)
		ORDER BY job_vacancy_id, created_at DESC
	`, userID).Scan(&chats).Error
	
	return chats, err
}

func (r *ChatRepository) GetCompanyChatThreads(companyID int) ([]entity.Chat, error) {
	var chats []entity.Chat
	
	err := r.DB.Raw(`
		SELECT DISTINCT ON (job_vacancy_id, sender_id) *
		FROM chats
		WHERE job_vacancy_id IN (
			SELECT id FROM job_vacancies WHERE company_id = ?
		)
		AND sender_type = 'user'
		ORDER BY job_vacancy_id, sender_id, created_at DESC
	`, companyID).Scan(&chats).Error
	
	return chats, err
}