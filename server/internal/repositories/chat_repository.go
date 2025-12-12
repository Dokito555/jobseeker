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

// func (r *ChatRepository) CountUnread(snederType string) (int, error) {
// 	var count int
// 	err := r.DB.Model(&entity.Chat{}).Where("senderType = ?")
// }