# Event Management App - Project Structure

## Complete Directory Tree

```
Event/
│
├── backend/                                    # Spring Boot Backend
│   ├── src/
│   │   └── main/
│   │       ├── java/com/eventmanagement/
│   │       │   ├── EventManagementApplication.java    # Main Spring Boot class
│   │       │   │
│   │       │   ├── config/                            # Configuration packages
│   │       │   │   ├── SecurityConfig.java            # Spring Security setup
│   │       │   │   └── CorsConfig.java                # CORS configuration
│   │       │   │
│   │       │   ├── controller/                        # REST Controllers
│   │       │   │   └── PingController.java            # Test endpoint
│   │       │   │
│   │       │   ├── service/                           # Business Logic Layer
│   │       │   │   └── (Empty - ready for Phase 1+)
│   │       │   │
│   │       │   ├── repository/                        # Data Access Layer
│   │       │   │   └── (Empty - ready for Phase 1+)
│   │       │   │
│   │       │   ├── entity/                            # JPA Entities
│   │       │   │   └── (Empty - ready for Phase 1+)
│   │       │   │
│   │       │   ├── dto/                               # Data Transfer Objects
│   │       │   │   └── (Empty - ready for Phase 1+)
│   │       │   │
│   │       │   └── exception/                         # Exception Handling
│   │       │       └── GlobalExceptionHandler.java    # Global error handler
│   │       │
│   │       └── resources/
│   │           └── application.properties             # App configuration
│   │
│   ├── target/                                        # Maven build output
│   ├── pom.xml                                        # Maven dependencies
│   ├── database_setup.sql                             # Database creation script
│   ├── run.bat                                        # Quick start script
│   └── .gitignore                                     # Git ignore rules
│
├── frontend/                                   # Flutter Frontend
│   ├── lib/
│   │   ├── main.dart                                  # Flutter app entry point
│   │   │
│   │   ├── routes/                                    # Navigation
│   │   │   ├── app_routes.dart                        # Route constants
│   │   │   └── app_pages.dart                         # GetX pages config
│   │   │
│   │   ├── bindings/                                  # Dependency Injection
│   │   │   └── home_binding.dart                      # Home screen bindings
│   │   │
│   │   ├── controllers/                               # Business Logic
│   │   │   └── home_controller.dart                   # Home screen controller
│   │   │
│   │   ├── views/                                     # UI Screens
│   │   │   └── home_view.dart                         # Home screen UI
│   │   │
│   │   ├── services/                                  # API & Services
│   │   │   └── api_client.dart                        # HTTP API client
│   │   │
│   │   ├── models/                                    # Data Models
│   │   │   └── (Empty - ready for Phase 1+)
│   │   │
│   │   └── widgets/                                   # Reusable Components
│   │       └── (Empty - ready for Phase 1+)
│   │
│   ├── android/                                       # Android platform files
│   ├── ios/                                           # iOS platform files
│   ├── web/                                           # Web platform files
│   ├── windows/                                       # Windows platform files
│   ├── linux/                                         # Linux platform files
│   ├── macos/                                         # macOS platform files
│   ├── test/
│   │   └── widget_test.dart                           # Widget tests
│   ├── pubspec.yaml                                   # Flutter dependencies
│   └── .gitignore                                     # Git ignore rules
│
├── .idea/                                      # IDE configuration
│
├── README.md                                   # Main documentation
├── PHASE_0_SETUP.md                           # Setup guide
├── PHASE_0_IMPLEMENTATION_SUMMARY.md          # Implementation details
├── PHASE_0_STATUS.md                          # Status report
└── PROJECT_STRUCTURE.md                       # This file
```

## Component Relationships

### Backend Component Flow

```
HTTP Request
    ↓
PingController (@RestController)
    ↓
[Service Layer - Phase 1+]
    ↓
[Repository Layer - Phase 1+]
    ↓
[Entity Layer - Phase 1+]
    ↓
MySQL Database
```

### Frontend Component Flow

```
User Interaction
    ↓
HomeView (UI)
    ↓
HomeController (GetX)
    ↓
ApiClient (HTTP)
    ↓
REST API
```

### Complete System Architecture

```
┌─────────────────────────────────────────┐
│         Flutter Mobile App               │
│  (Android Emulator / Physical Device)   │
│                                          │
│  ┌────────────────────────────────────┐ │
│  │  Views (UI Layer)                  │ │
│  │  - home_view.dart                  │ │
│  └────────────┬───────────────────────┘ │
│               ↓                          │
│  ┌────────────────────────────────────┐ │
│  │  Controllers (Business Logic)      │ │
│  │  - home_controller.dart (GetX)     │ │
│  └────────────┬───────────────────────┘ │
│               ↓                          │
│  ┌────────────────────────────────────┐ │
│  │  Services (API Communication)      │ │
│  │  - api_client.dart (HTTP)          │ │
│  └────────────┬───────────────────────┘ │
└───────────────┼──────────────────────────┘
                ↓
         REST API (JSON)
         http://10.0.2.2:8080/api
                ↓
┌─────────────────────────────────────────┐
│      Spring Boot Backend (Java 21)      │
│           Port: 8080                     │
│                                          │
│  ┌────────────────────────────────────┐ │
│  │  Controllers (REST Endpoints)      │ │
│  │  - PingController                  │ │
│  │  @GetMapping("/api/ping")          │ │
│  └────────────┬───────────────────────┘ │
│               ↓                          │
│  ┌────────────────────────────────────┐ │
│  │  Security Layer                    │ │
│  │  - SecurityConfig (Spring Security)│ │
│  │  - CorsConfig (CORS)               │ │
│  └────────────┬───────────────────────┘ │
│               ↓                          │
│  ┌────────────────────────────────────┐ │
│  │  Service Layer (Business Logic)   │ │
│  │  [Ready for Phase 1+]              │ │
│  └────────────┬───────────────────────┘ │
│               ↓                          │
│  ┌────────────────────────────────────┐ │
│  │  Repository Layer (Data Access)    │ │
│  │  Spring Data JPA                   │ │
│  │  [Ready for Phase 1+]              │ │
│  └────────────┬───────────────────────┘ │
│               ↓                          │
│  ┌────────────────────────────────────┐ │
│  │  Entity Layer (Domain Models)      │ │
│  │  JPA Entities                      │ │
│  │  [Ready for Phase 1+]              │ │
│  └────────────┬───────────────────────┘ │
└───────────────┼──────────────────────────┘
                ↓
┌─────────────────────────────────────────┐
│         MySQL Database                   │
│      Database: event_management          │
│           Port: 3306                     │
│                                          │
│  [Tables will be created by JPA]        │
│  [Starting from Phase 1]                │
└─────────────────────────────────────────┘
```

## File Purposes

### Backend Files

| File | Purpose | Phase |
|------|---------|-------|
| `EventManagementApplication.java` | Spring Boot entry point with @SpringBootApplication | 0 |
| `PingController.java` | Test REST endpoint for connectivity verification | 0 |
| `SecurityConfig.java` | Spring Security configuration, JWT setup | 0, 1 |
| `CorsConfig.java` | Cross-Origin Resource Sharing configuration | 0 |
| `GlobalExceptionHandler.java` | Centralized exception handling with @ControllerAdvice | 0 |
| `application.properties` | Database connection, JPA settings, server port | 0 |
| `pom.xml` | Maven dependencies and build configuration | 0 |
| `database_setup.sql` | MySQL database creation script | 0 |

### Frontend Files

| File | Purpose | Phase |
|------|---------|-------|
| `main.dart` | Flutter app entry point, GetMaterialApp setup | 0 |
| `app_routes.dart` | Route name constants for navigation | 0 |
| `app_pages.dart` | GetX page and binding configuration | 0 |
| `home_binding.dart` | Dependency injection for HomeController | 0 |
| `home_controller.dart` | Home screen business logic with GetX | 0 |
| `home_view.dart` | Home screen UI with backend test button | 0 |
| `api_client.dart` | HTTP client for REST API communication | 0 |
| `pubspec.yaml` | Flutter dependencies (GetX, HTTP) | 0 |

## Key Dependencies

### Backend (pom.xml)
```xml
- spring-boot-starter-web        # REST API support
- spring-boot-starter-security   # Authentication/Authorization
- spring-boot-starter-data-jpa   # Database access
- mysql-connector-j              # MySQL driver
- spring-boot-starter-validation # Input validation
- spring-boot-devtools           # Development tools
```

### Frontend (pubspec.yaml)
```yaml
- flutter              # Flutter framework
- get: ^4.7.3         # State management, routing, DI
- http: ^1.6.0        # HTTP client for API calls
- cupertino_icons     # iOS-style icons
```

## Configuration Files

### Backend Configuration (application.properties)
```properties
# Server
server.port=8080

# Database
spring.datasource.url=jdbc:mysql://localhost:3306/event_management
spring.datasource.username=root
spring.datasource.password=

# JPA
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```

### Frontend Configuration (api_client.dart)
```dart
// Android Emulator: 10.0.2.2 maps to host's localhost
static const String baseUrl = 'http://10.0.2.2:8080/api';
```

## Empty Folders (Ready for Future Phases)

### Backend - Ready for Development
- `service/` - Business logic services (Phase 1+)
- `repository/` - JPA repositories (Phase 1+)
- `entity/` - Domain entities (Phase 1+)
- `dto/` - Data transfer objects (Phase 1+)

### Frontend - Ready for Development
- `models/` - Data models matching backend entities (Phase 1+)
- `widgets/` - Reusable UI components (Phase 1+)

## API Endpoints

### Phase 0 Endpoints

| Method | Endpoint | Purpose | Auth |
|--------|----------|---------|------|
| GET | `/api/ping` | Health check, connectivity test | None |

### Future Endpoints (Phase 1+)

**Authentication (Phase 1)**
- POST `/api/auth/register` - User registration
- POST `/api/auth/login` - User login (returns JWT)
- GET `/api/auth/profile` - Get user profile
- PUT `/api/auth/profile` - Update user profile

**Events (Phase 2)**
- POST `/api/events` - Create event (Organizer)
- GET `/api/events` - List/search events
- GET `/api/events/{id}` - Get event details
- PUT `/api/events/{id}` - Update event (Organizer)
- DELETE `/api/events/{id}` - Delete event (Organizer)

**Bookings (Phase 3)**
- POST `/api/bookings` - Create booking
- GET `/api/bookings` - User's bookings
- GET `/api/bookings/{id}` - Booking details

**Payments (Phase 4)**
- POST `/api/payments/create-order` - Razorpay order
- POST `/api/payments/webhook` - Payment confirmation
- POST `/api/checkin/scan` - QR code check-in

*(And more in subsequent phases...)*

## Testing Structure

### Backend Testing (Future)
```
src/test/java/com/eventmanagement/
├── controller/    # Controller tests
├── service/       # Service tests
├── repository/    # Repository tests
└── integration/   # Integration tests
```

### Frontend Testing
```
test/
├── widget_test.dart           # Widget tests
├── unit/                      # Unit tests (Future)
└── integration/               # Integration tests (Future)
```

## Build Outputs

### Backend
```
target/
├── classes/                   # Compiled Java classes
├── generated-sources/         # Generated code
└── event-management-backend-0.0.1-SNAPSHOT.jar
```

### Frontend
```
build/
├── app/
│   └── outputs/
│       └── flutter-apk/
│           └── app-release.apk
```

## Development Tools

### Recommended IDEs

**Backend Development**
- IntelliJ IDEA (recommended for Spring Boot)
- Eclipse with Spring Tools
- VS Code with Java extensions

**Frontend Development**
- Android Studio (recommended for Flutter)
- VS Code with Flutter/Dart extensions
- IntelliJ IDEA Ultimate

**Code Editing**
- Kiro (used in this project)

### Database Tools
- MySQL Workbench
- MySQL Command Line
- DBeaver
- phpMyAdmin

## Version Control Preparation

### Recommended .gitignore Coverage

**Backend**
- `target/` - Maven build output
- `*.class` - Compiled classes
- `.idea/` - IDE files
- `*.iml` - IntelliJ modules

**Frontend**
- `build/` - Flutter build output
- `.dart_tool/` - Dart tools
- `.flutter-plugins` - Flutter plugins
- `.flutter-plugins-dependencies`

### Git Initialization (When Ready)
```bash
cd Event
git init
git add .
git commit -m "Phase 0: Project initialization complete"
```

## Scale Considerations

### Backend Scalability
- Stateless REST API (JWT-based)
- Connection pooling configured
- JPA caching available
- Horizontal scaling ready

### Frontend Scalability
- GetX state management efficient
- Lazy loading of controllers
- Modular architecture
- Easy to add new features

### Database Scalability
- Proper indexing (Phase 1+)
- Foreign key constraints
- Transaction management
- Query optimization ready

---

**Project**: Event Management & Ticket Booking  
**Phase**: 0 - Complete  
**Last Updated**: August 14, 2026
