package main

import "github.com/Dokito555/jobseeker/server/internal/configs"

func main() {
	// init configs
	viperConfig := configs.NewViper()
	log := configs.NewLogger(viperConfig)
	db := configs.NewDatabase(viperConfig, log)
	validate := configs.NewValidator(viperConfig)
	app := configs.NewGin(viperConfig)

	// inject configs to app
	configs.Bootstrap(&configs.BootstrapConfig{
		DB:          db,
		App:         app,
		Log:         log,
		Validate:    validate,
		Config:      viperConfig,
	})

	// run app
	port := viperConfig.GetString("APP_PORT")
	err := app.Run(":" + port)
	log.Info("Listening to port: " + port)
	if err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
