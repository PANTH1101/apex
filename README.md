# Apex - Event Management & Ticket Booking App

A full-stack event management platform for discovering events, booking tickets, and managing events with real-time analytics.

## 🚀 Tech Stack

### Backend
- **Spring Boot 3.2.0** (Java 21)
- **Maven** - Build tool
- **Spring Security** - JWT authentication
- **Spring Data JPA** - Database ORM
- **MySQL** - Relational database
- **Razorpay** - Payment integration
- **REST API** - JSON over HTTPS

### Frontend
- **Flutter 3.47.0** (Dart 3.13.0)
- **GetX** - State management, routing, DI
- **HTTP** - API client
- **Firebase Cloud Messaging** - Push notifications
- **QR Flutter** - QR code generation
- **Mobile Scanner** - QR code scanning
- **FL Chart** - Analytics visualization

### Architecture
```
Flutter (GetX) → REST API → Spring Boot → MySQL
```

## ✨ Features

### Phase 0 - Foundation ✅
- Spring Boot backend with Maven
- Flutter frontend with GetX
- MySQL database integration
- API connectivity verification

### Phase 1 - Authentication (Upcoming)
- User registration & login
- JWT token-based authentication
- Password encryption (BCrypt)
- Role-based access (Attendee/Organizer/Admin)
- User profile management

### Phase 2 - Event Management
- Create and manage events
- Event browsing and search
- Category-based filtering
- Image upload for events
- Event capacity tracking

### Phase 3 - Ticket Booking
- Standard ticket booking
- Quantity selection
- Live capacity updates
- Booking history
- Concurrent booking safety

### Phase 4 - Payments & QR Entry
- Razorpay payment integration
- Server-side payment verification
- QR code generation (signed tokens)
- QR code scanning for check-in
- Duplicate scan prevention

### Phase 5 - Dashboards
- Organizer dashboard
  - Bookings analytics
  - Revenue tracking
  - Check-in statistics
  - Real-time updates
- Admin panel
  - User management
  - Event moderation
  - Platform monitoring

### Phase 6 - Engagement
- Push notifications (FCM)
- Referral system
- Rewards wallet
- Points ledger
- Apply points at checkout

### Phase 7 - Analytics & AI
- Event reviews and ratings
- Sales analytics
- Attendance tracking
- AI-powered event recommendations

## 📁 Project Structure

```
apex/
├── backend/                # Spring Boot Backend
│   ├── src/main/java/com/eventmanagement/
│   │   ├── controller/    # REST controllers
│   │   ├── service/       # Business logic
│   │   ├── repository/    # Data access
│   │   ├── entity/        # JPA entities
│   │   ├── dto/           # Data transfer objects
│   │   ├── config/        # Configuration
│   │   └── exception/     # Exception handling
│   ├── src/main/resources/
│   │   └── application.properties
│   └── pom.xml
│
└── frontend/              # Flutter Frontend
    ├── lib/
    │   ├── bindings/     # GetX dependency injection
    │   ├── controllers/  # GetX controllers
    │   ├── views/        # UI screens
    │   ├── services/     # API client
    │   ├── models/       # Data models
    │   ├── routes/       # Navigation
    │   └── widgets/      # Reusable components
    └── pubspec.yaml
```

## 🛠️ Setup Instructions

### Prerequisites
- Java 21
- Maven 3.6+
- MySQL 8.0+
- Flutter 3.0+
- Android Studio (for Android development)

### Backend Setup

1. **Create MySQL database**
```sql
CREATE DATABASE event_management;
```

2. **Configure database** in `backend/src/main/resources/application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/event_management
spring.datasource.username=root
spring.datasource.password=your_password
```

3. **Build and run**
```bash
cd backend
mvn clean install
mvn spring-boot:run
```

Backend starts on `http://localhost:8080`

### Frontend Setup

1. **Install dependencies**
```bash
cd frontend
flutter pub get
```

2. **Run on Android emulator**
```bash
flutter run
```

3. **Run on Chrome (for testing)**
```bash
flutter run -d chrome
```

## 🔧 API Configuration

### Android Emulator
The app automatically uses `http://10.0.2.2:8080/api` (maps to host's localhost)

### Physical Device
Update `lib/services/api_client.dart`:
```dart
return 'http://YOUR_LOCAL_IP:8080/api';
```

### Web (Chrome)
Uses `http://localhost:8080/api`

## 📡 API Endpoints

### Phase 0
- `GET /api/ping` - Health check

### Phase 1 (Upcoming)
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `GET /api/auth/profile` - Get profile
- `PUT /api/auth/profile` - Update profile

### Phase 2+
- Event CRUD operations
- Booking management
- Payment processing
- QR code operations
- Analytics queries

## 🧪 Testing

### Backend
```bash
mvn test
```

### Frontend
```bash
flutter test
```

### API Testing
```bash
curl http://localhost:8080/api/ping
```

## 🚀 Deployment

### Backend
```bash
mvn package
java -jar target/event-management-backend-0.0.1-SNAPSHOT.jar
```

### Frontend
```bash
flutter build apk --release
```

## 📊 Database Schema

### Core Entities
- **User** - Account and role management
- **Event** - Event listings and details
- **Booking** - Ticket purchases
- **Payment** - Razorpay transactions
- **CheckIn** - QR scan records
- **Notification** - In-app notifications
- **Referral** - Referral tracking
- **WalletTransaction** - Points ledger
- **Review** - Event ratings

## 🔐 Security

- JWT-based stateless authentication
- BCrypt password hashing
- CORS configuration
- Spring Security integration
- Signed QR tokens (HMAC)
- Server-side payment verification
- Role-based access control

## 🎯 Development Workflow

1. **Code**: Kiro AI or any IDE
2. **Backend**: `mvn spring-boot:run`
3. **Frontend**: `flutter run` or Android Studio
4. **Database**: MySQL Workbench or CLI
5. **Version Control**: Git

## 🐛 Troubleshooting

### Backend won't start
- Verify MySQL is running
- Check port 8080 is free
- Verify database credentials

### Flutter build fails
```bash
flutter clean
flutter pub get
flutter run
```

### Android Gradle timeout
- Use mobile hotspot
- Wait for initial Gradle download (5-10 min)
- Use Android Studio's built-in Gradle

## 📝 License

This is an academic project for educational purposes.

## 👥 Team

SDP Lab Project - Event Management Application

## 📮 Contact

GitHub: [@PANTH1101](https://github.com/PANTH1101)

## 🗺️ Roadmap

- [x] Phase 0: Project Setup
- [ ] Phase 1: Authentication & Profiles
- [ ] Phase 2: Event Management
- [ ] Phase 3: Ticket Booking
- [ ] Phase 4: Payments & QR Entry
- [ ] Phase 5: Dashboards
- [ ] Phase 6: Notifications & Wallet
- [ ] Phase 7: Analytics & AI

---

**Current Status**: Phase 0 Complete ✅
