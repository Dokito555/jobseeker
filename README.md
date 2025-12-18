# jobseeker
## how to run
1. setup PostgreSQL
2. configure `.env`
```env
APP_NAME=jobseeker
APP_PORT=9001
APP_SECRET=jobseeker

LOG_LEVEL=Trace

DB_HOST=127.0.0.1
DB_PORT=5432
DB_NAME=jobseeker
DB_USER=postgres
DB_PASSWORD=postgres123
```
3. run backend
```
cd server
air
```
4. run app
pick any device
```
flutter run
```