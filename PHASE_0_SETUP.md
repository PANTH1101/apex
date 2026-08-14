# Phase 0 - Quick Setup Guide

## Prerequisites Check

Before starting, ensure you have:
- [x] Java 21 installed
- [x] Maven installed
- [x] MySQL installed and running
- [x] Flutter SDK installed
- [x] Android Studio installed

## Step-by-Step Setup

### 1. Database Setup (5 minutes)

```bash
# Start MySQL (if not already running)
# Windows: MySQL should be running as a service

# Create database
mysql -u root -p
```

Then in MySQL prompt:
```sql
CREATE DATABASE IF NOT EXISTS event_management;
EXIT;
```

Or use the SQL file:
```bash
mysql -u root -p < backend/database_setup.sql
```

**Note**: If your MySQL root password is different from empty, update:
`backend/src/main/resources/application.properties`

```properties
spring.datasource.password=YOUR_PASSWORD
```

### 2. Backend Setup (5 minutes)

```bash
# Navigate to backend folder
cd backend

# Compile and verify
mvn clean compile

# Run the Spring Boot application
mvn spring-boot:run
```

**Expected output**:
```
Started EventManagementApplication in X.XXX seconds
```

**Test backend** (in a new terminal):
```bash
curl http://localhost:8080/api/ping
```

**Expected response**:
```json
{"status":"success","message":"Event Management Backend is running"}
```

### 3. Flutter Setup (5 minutes)

```bash
# Navigate to frontend folder
cd frontend

# Get dependencies
flutter pub get

# Verify no issues
flutter analyze

# Check Flutter devices
flutter devices
```

### 4. Run Flutter App in Android Studio

1. Open Android Studio
2. Click "Open" and select the `frontend` folder
3. Wait for Gradle sync to complete
4. Start Android Emulator:
   - Tools → Device Manager → Create/Start Virtual Device
5. Click the Run button (green play icon) or press `Shift + F10`
6. Wait for app to build and install

**Alternative - Command line**:
```bash
# Make sure emulator is running first
flutter run
```

### 5. Test End-to-End Communication

1. **Ensure backend is running** on `http://localhost:8080`
2. **Ensure Flutter app is running** on Android emulator
3. In the Flutter app, click **"Test Backend Connection"** button
4. You should see:
   - ✅ "Connected successfully"
   - "Event Management Backend is running"

## Verification Checklist

### Backend
- [ ] `mvn clean compile` - SUCCESS
- [ ] Spring Boot starts without errors
- [ ] MySQL connection established (check logs)
- [ ] `/api/ping` endpoint responds correctly

### Frontend
- [ ] `flutter pub get` - SUCCESS
- [ ] `flutter analyze` - No issues
- [ ] App builds successfully
- [ ] App runs on Android emulator

### Integration
- [ ] Flutter displays "Connected successfully"
- [ ] Backend message appears in the UI
- [ ] No connection errors

## Common Issues & Solutions

### Backend Issues

**Issue**: `Communications link failure` in MySQL
**Solution**: 
- Ensure MySQL is running
- Verify database `event_management` exists
- Check username/password in `application.properties`

**Issue**: `Port 8080 already in use`
**Solution**: 
- Stop other applications using port 8080
- Or change port in `application.properties`: `server.port=8081`
- Update Flutter API URL accordingly

### Flutter Issues

**Issue**: "Unable to connect to backend"
**Solution**:
- Ensure backend is running
- For Android emulator, URL must be `http://10.0.2.2:8080/api`
- For physical device, use computer's local IP
- Check Windows Firewall settings

**Issue**: Build fails in Flutter
**Solution**:
```bash
flutter clean
flutter pub get
flutter run
```

**Issue**: Android emulator not starting
**Solution**:
- Open Android Studio → Tools → Device Manager
- Create new Virtual Device if needed
- Ensure Intel HAXM or Hyper-V is enabled

## Quick Commands Reference

### Backend
```bash
# Build
mvn clean install

# Run
mvn spring-boot:run

# Test endpoint
curl http://localhost:8080/api/ping
```

### Frontend
```bash
# Install dependencies
flutter pub get

# Analyze code
flutter analyze

# Run app
flutter run

# Clean build
flutter clean
```

### Database
```bash
# Connect to MySQL
mysql -u root -p

# Show databases
SHOW DATABASES;

# Use database
USE event_management;

# Show tables (will be empty in Phase 0)
SHOW TABLES;
```

## API Configuration Notes

### Android Emulator
- Backend URL: `http://10.0.2.2:8080/api`
- `10.0.2.2` is Android emulator's special alias for host machine's `localhost`

### Physical Device (same network)
- Find computer IP: `ipconfig` (Windows)
- Update in `lib/services/api_client.dart`:
  ```dart
  static const String baseUrl = 'http://192.168.X.X:8080/api';
  ```

## Project Structure Verification

After setup, your structure should look like:

```
Event/
├── backend/
│   ├── src/main/java/com/eventmanagement/
│   │   ├── EventManagementApplication.java
│   │   ├── config/
│   │   ├── controller/
│   │   ├── entity/
│   │   ├── exception/
│   │   ├── repository/
│   │   └── service/
│   ├── src/main/resources/
│   │   └── application.properties
│   └── pom.xml
│
├── frontend/
│   ├── lib/
│   │   ├── bindings/
│   │   ├── controllers/
│   │   ├── models/
│   │   ├── routes/
│   │   ├── services/
│   │   ├── views/
│   │   ├── widgets/
│   │   └── main.dart
│   └── pubspec.yaml
│
└── README.md
```

## Phase 0 Complete! ✅

If all verification steps pass, Phase 0 is complete. You have:
- ✅ Working Spring Boot backend
- ✅ MySQL database connection
- ✅ Flutter frontend with GetX
- ✅ End-to-end API communication

**Ready for Phase 1**: Authentication & Profiles

## Getting Help

If you encounter issues:
1. Check the error messages carefully
2. Verify all prerequisites are installed
3. Ensure all services are running
4. Review the troubleshooting section in main README.md

## Next Steps

Phase 1 will implement:
- User registration and login
- JWT authentication
- Spring Security configuration
- User profile management
- Role-based access control (Attendee/Organizer/Admin)
