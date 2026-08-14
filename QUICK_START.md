# 🚀 Quick Start Guide - Event Management App

## Current Situation

You encountered Gradle network issues when trying to run on Android emulator. **This is normal and easily resolved!**

## ✅ Recommended Solution: Run on Windows Desktop

For Phase 0 (and even Phase 1-3), you can develop on Windows Desktop. This:
- Bypasses Gradle/Android issues completely
- Builds much faster
- Works perfectly for backend connectivity testing
- Can switch to Android later when needed (Phase 4+)

---

## 🎯 Steps to Complete Phase 0 (5 Minutes)

### Step 1: Start Backend
Open a terminal:
```bash
cd c:\Users\ASUS\Desktop\Event\backend
mvn spring-boot:run
```

**Wait for**: `Started EventManagementApplication in X.XXX seconds`

**Keep this terminal open!**

---

### Step 2: Start Frontend on Windows
Open a **NEW** terminal:
```bash
cd c:\Users\ASUS\Desktop\Event\frontend
flutter run -d windows
```

The Windows desktop app will launch in 20-30 seconds.

---

### Step 3: Test Connection
1. Windows app opens with "Event Management App" title
2. Click **"Test Backend Connection"** button
3. You should see:
   - ✅ Green checkmark
   - "Connected successfully"
   - "Event Management Backend is running"

---

## ✅ Phase 0 Complete!

If the test succeeds, **Phase 0 is complete**! You have:
- ✅ Working Spring Boot backend
- ✅ MySQL database connected
- ✅ Flutter app running
- ✅ GetX state management working
- ✅ End-to-end API communication verified

---

## 🔧 Alternative: Run on Chrome (Web)

If Windows desktop doesn't work, try Chrome:

```bash
flutter run -d chrome
```

The app will open in your browser. Same functionality!

---

## 📱 For Android Later (Optional)

When you need Android emulator (Phase 4+), you have options:

### Option A: Use Android Studio (Recommended)
1. Open Android Studio
2. Open the `frontend` folder
3. Tools → Device Manager → Create Virtual Device
4. Click Run button
5. Gradle will download automatically (may take time on first run)

### Option B: Fix Gradle Network Issues
See `FLUTTER_BUILD_TROUBLESHOOTING.md` for detailed solutions:
- Configure proxy
- Pre-download Gradle
- Use offline mode
- Increase timeouts

### Option C: Use Physical Device
1. Enable Developer Options on Android phone
2. Enable USB Debugging
3. Connect via USB
4. Run `flutter devices`
5. Run `flutter run`

---

## 🎓 Why Windows Desktop is Perfect for Now

| Feature | Windows Desktop | Android Emulator |
|---------|----------------|------------------|
| Build Speed | ⚡ Fast (30 sec) | 🐌 Slow (2-5 min) |
| Gradle Issues | ✅ None | ❌ Network timeouts |
| Backend Testing | ✅ Works perfectly | ✅ Works |
| Hot Reload | ✅ Yes | ✅ Yes |
| Phase 0-3 Features | ✅ All supported | ✅ All supported |
| QR Scanning | ❌ No camera | ✅ Can simulate |
| Notifications | ❌ Not needed yet | ✅ For Phase 6 |

**Conclusion**: Use Windows Desktop until Phase 4!

---

## 📋 Complete Commands Reference

### Backend Commands
```bash
# Start backend
cd backend
mvn spring-boot:run

# Test backend
curl http://localhost:8080/api/ping

# Or in browser
# http://localhost:8080/api/ping
```

### Frontend Commands
```bash
# Run on Windows Desktop (Recommended)
cd frontend
flutter run -d windows

# Run on Chrome (Alternative)
flutter run -d chrome

# Run on Android (When ready)
flutter run -d android

# List all devices
flutter devices

# Clean build
flutter clean
flutter pub get
```

### Database Commands
```bash
# Connect to MySQL
mysql -u root -p

# Show databases
SHOW DATABASES;

# Use database
USE event_management;
```

---

## 🐛 Troubleshooting

### Backend won't start
```bash
# Check if port 8080 is free
netstat -ano | findstr :8080

# Or change port in application.properties
# server.port=8081
```

### Flutter build fails
```bash
flutter clean
flutter pub get
flutter run -d windows
```

### "Unable to connect to backend"
1. Ensure backend is running: `http://localhost:8080/api/ping`
2. Check firewall isn't blocking
3. Verify port 8080 is correct

### MySQL connection failed
1. Start MySQL service
2. Create database: `CREATE DATABASE event_management;`
3. Update password in `application.properties` if needed

---

## 📁 Project Status Files

After successful test, review these files:
- ✅ `README.md` - Main documentation
- ✅ `PHASE_0_STATUS.md` - Verification checklist
- ✅ `PROJECT_STRUCTURE.md` - Architecture overview
- ✅ `RUN_ON_WINDOWS.md` - Windows-specific guide (this recommended approach)
- ✅ `FLUTTER_BUILD_TROUBLESHOOTING.md` - Android/Gradle fixes

---

## 🎯 What's Next?

### Immediate (Now)
1. ✅ Start backend: `cd backend && mvn spring-boot:run`
2. ✅ Start frontend: `cd frontend && flutter run -d windows`
3. ✅ Test connection in app
4. ✅ Verify Phase 0 complete

### Short Term (Phase 1)
- User registration and login
- JWT authentication
- Password encryption
- User profiles
- Role-based access

### Medium Term (Phase 2-3)
- Event creation and management
- Event browsing and search
- Ticket booking
- Capacity tracking

### Long Term (Phase 4+)
- Switch to Android emulator
- Payment integration (Razorpay)
- QR code scanning
- Push notifications

---

## 💡 Pro Tips

1. **Keep backend terminal open** - Don't close it while developing
2. **Use hot reload** - Press `r` in Flutter terminal to reload without restart
3. **Check logs** - Both backend and frontend terminals show useful errors
4. **Use browser for API testing** - `http://localhost:8080/api/ping`
5. **Windows is great for development** - Faster iterations, easier debugging

---

## ✨ You're Almost There!

Just run these two commands in separate terminals:

**Terminal 1** (Backend):
```bash
cd c:\Users\ASUS\Desktop\Event\backend
mvn spring-boot:run
```

**Terminal 2** (Frontend):
```bash
cd c:\Users\ASUS\Desktop\Event\frontend
flutter run -d windows
```

Click "Test Backend Connection" → See success message → **Phase 0 Complete!** 🎉

---

**Need Help?**
- Check `FLUTTER_BUILD_TROUBLESHOOTING.md` for Android issues
- Check `RUN_ON_WINDOWS.md` for Windows details
- Check `PHASE_0_SETUP.md` for detailed setup
- Check `README.md` for complete documentation
