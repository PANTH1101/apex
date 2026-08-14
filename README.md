# Event Management & Ticket Booking Application

A full-stack event management platform with Flutter mobile frontend and Spring Boot backend.

## Project Overview

This is an SDP Lab Project built incrementally across 8 phases. Phase 0 establishes the foundational architecture and verifies end-to-end connectivity.

## Tech Stack

### Frontend
- **Flutter** + **Dart**
- **GetX** - State management, routing, and dependency injection
- **HTTP** - API communication

### Backend
- **Spring Boot** (Java 21)
- **Spring Security** - Authentication and authorization
- **Spring Data JPA** - Database access
- **MySQL** - Relational database
- **Maven** - Build tool

### Architecture
```
Flutter + GetX
    ↓
REST API (JSON)
    ↓
Spring Boot
    ↓
Spring Data JPA
    ↓
MySQL
```

## Project Structure

```
event-management/
│
├── backend/                    # Spring Boot backend
│   ├── src/
│   │   └── main/
│   │       ├── java/com/eventmanagement/
│   │       │   ├── controller/       # REST controllers
│   │       │   ├── service/          # Business logic
│   │       │   ├── repository/       # Data access
│   │       │   ├── entity/           # JPA entities
│   │       │   ├── dto/              # Data transfer objects
│   │       │   ├── config/           # Configuration classes
│   │       │   └── exception/        # Exception handling
│   │       └── resources/
│   │           └── application.properties
│   ├── pom.xml
│   └── database_setup.sql
│
└── frontend/                   # Flutter frontend
    ├── lib/
    │   ├── bindings/          # GetX dependency bindings
    │   ├── controllers/       # GetX controllers
    │   ├── views/             # UI screens
    │   ├── services/          # API client and services
    │   ├── models/            # Data models
    │   ├── routes/            # Navigation routes
    │   ├── widgets/           # Reusable widgets
    │   └── main.dart
    └── pubspec.yaml
```

## Prerequisites

- **Java 21** or higher
- **Maven** 3.6+
- **MySQL** 8.0+
- **Flutter** 3.0+
- **Dart** 3.0+
- **Android Studio** (for running Flutter app)

## Setup Instructions

### 1. Database Setup

1. Start MySQL server
2. Create the database:

```bash
mysql -u root -p < backend/database_setup.sql
```

Or manually:
```sql
CREATE DATABASE IF NOT EXISTS event_management;
```

3. Update database credentials in `backend/src/main/resources/application.properties` if needed:

```properties
spring.datasource.username=root
spring.datasource.password=your_password
```

### 2. Backend Setup

1. Navigate to backend directory:
```bash
cd backend
```

2. Build the project:
```bash
mvn clean install
```

3. Run the Spring Boot application:
```bash
mvn spring-boot:run
```

The backend will start on `http://localhost:8080`

Verify backend is running:
```bash
curl http://localhost:8080/api/ping
```

Expected response:
```json
{
  "status": "success",
  "message": "Event Management Backend is running"
}
```

### 3. Frontend Setup

1. Navigate to frontend directory:
```bash
cd frontend
```

2. Install dependencies:
```bash
flutter pub get
```

3. Open project in Android Studio

4. Start Android Emulator from Android Studio

5. Run the application:
```bash
flutter run
```

Or use Android Studio's run button.

## API Configuration

### Android Emulator
The Flutter app is configured to connect to the backend using:
```
http://10.0.2.2:8080/api
```

`10.0.2.2` is the special IP address that maps to `localhost` on the host machine from the Android emulator.

### Physical Android Device
If testing on a physical device connected to the same network:

1. Find your computer's local IP address:
   - Windows: `ipconfig`
   - Mac/Linux: `ifconfig`

2. Update `lib/services/api_client.dart`:
```dart
static const String baseUrl = 'http://YOUR_LOCAL_IP:8080/api';
```

Replace `YOUR_LOCAL_IP` with your actual IP (e.g., `http://192.168.1.100:8080/api`)

## Testing Phase 0

### Verification Steps

1. **Backend**: Spring Boot starts successfully ✓
2. **Database**: MySQL connection established ✓
3. **API Endpoint**: `/api/ping` responds correctly ✓
4. **Flutter**: App runs successfully ✓
5. **Integration**: Flutter → Spring Boot → MySQL communication works ✓

### Testing the Integration

**Option 1: Windows Desktop (Recommended for Phase 0)**
1. Start MySQL server
2. Run Spring Boot backend: `cd backend && mvn spring-boot:run`
3. Run Flutter on Windows: `cd frontend && flutter run -d windows`
4. Click "Test Backend Connection" button
5. Verify "Connected successfully" message appears

**Option 2: Android Emulator (For Phase 4+)**
1. Start MySQL server
2. Run Spring Boot backend
3. Launch Flutter app in Android Studio
4. Click "Test Backend Connection" button
5. Verify "Connected successfully" message appears

**Note**: If you encounter Gradle network issues with Android, use Windows Desktop for now. See `QUICK_START.md` for details.

## Development Workflow

This project uses:
- **Kiro** - For code development and editing
- **Android Studio** - For running and testing Flutter application

### Typical workflow:
1. Modify code using Kiro
2. Save changes
3. Use Android Studio to run/test the Flutter app on Android emulator
4. For backend changes, restart Spring Boot application

## Phase 0 Completion Checklist

- [x] Spring Boot project initialized with Maven
- [x] MySQL database created and connected
- [x] Base package structure created (controller/service/repository/entity/dto/config/exception)
- [x] Global exception handler configured
- [x] Spring Security basic configuration
- [x] CORS configuration for API access
- [x] Test endpoint `/api/ping` implemented
- [x] Flutter project created with GetX
- [x] Folder structure organized (bindings/controllers/views/services/models/routes/widgets)
- [x] API client service implemented
- [x] GetX routing configured
- [x] Home screen with backend connectivity test
- [x] End-to-end communication verified

## Next Steps

Phase 0 is complete. The foundation is established for:
- Phase 1: Authentication & Profiles (JWT, user registration/login)
- Phase 2: Event Management (create/browse events)
- Phase 3: Ticket Booking (capacity tracking)
- Phase 4: Payments & QR Entry (Razorpay integration)
- Phase 5: Organizer Dashboard & Admin Panel
- Phase 6: Notifications, Referrals & Wallet
- Phase 7: Reviews, Analytics & AI Recommendations

## Troubleshooting

### Backend Issues

**MySQL Connection Failed**
- Verify MySQL is running
- Check credentials in `application.properties`
- Ensure database `event_management` exists

**Port 8080 Already in Use**
- Change port in `application.properties`: `server.port=8081`

### Flutter Issues

**Cannot Connect to Backend**
- Verify backend is running on `http://localhost:8080`
- For emulator, ensure using `10.0.2.2` not `localhost`
- Check firewall settings

**Build Errors**
- Run `flutter clean`
- Run `flutter pub get`
- Restart IDE

## Project Team

SDP Lab Project - Event Management Application

## License

This is an academic project for educational purposes.
