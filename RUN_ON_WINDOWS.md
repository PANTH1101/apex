# Quick Start: Run on Windows Desktop

## Why Windows Desktop?

Running on Windows Desktop for Phase 0 testing:
- ✅ **No Gradle issues** - Bypasses Android build completely
- ✅ **Faster builds** - Windows compilation is much faster
- ✅ **Same functionality** - Tests Flutter → Spring Boot communication
- ✅ **Easy debugging** - Better development experience
- ✅ **Works immediately** - No network/firewall issues

You can switch to Android emulator later once needed.

## Steps to Run

### 1. Ensure Backend is Running

```bash
cd backend
mvn spring-boot:run
```

Wait for: `Started EventManagementApplication`

### 2. Run Flutter on Windows

```bash
cd frontend
flutter run -d windows
```

**That's it!** The app will open as a Windows desktop application.

## Verify It Works

1. Windows desktop app opens
2. Click **"Test Backend Connection"** button
3. You should see:
   - ✅ "Connected successfully"
   - "Event Management Backend is running"

## API Configuration

The app now automatically detects the platform:

- **Windows/iOS**: Uses `http://localhost:8080/api`
- **Android**: Uses `http://10.0.2.2:8080/api`

No manual configuration needed!

## Advantages for Development

### Phase 0 Testing
- ✅ Backend connectivity verified
- ✅ GetX state management working
- ✅ API communication confirmed
- ✅ All Phase 0 goals met

### Future Development
- Fast iteration during development
- Easy debugging with DevTools
- Hot reload works great
- Can switch to Android when needed

## When to Use Android Emulator

You'll need Android emulator for:
- **Phase 4**: QR code scanning (camera required)
- **Phase 6**: Firebase notifications testing
- Final testing before deployment

For now, Windows is perfect for Phase 0-3 development.

## Common Commands

### Run on Windows
```bash
flutter run -d windows
```

### Hot Reload (while running)
Press `r` in terminal

### Hot Restart (while running)
Press `R` in terminal

### Build Windows Release
```bash
flutter build windows --release
```

### Run on Chrome (Alternative)
```bash
flutter run -d chrome
```

## Switching to Android Later

When you're ready for Android:

### Option 1: Use Android Studio
1. Open `frontend` in Android Studio
2. Start emulator from Device Manager
3. Click Run button

### Option 2: Pre-download Gradle
1. Download Gradle from https://gradle.org/releases/
2. Place in `.gradle` folder
3. Run with `--offline` flag

### Option 3: Fix Network Issues
See `FLUTTER_BUILD_TROUBLESHOOTING.md` for detailed solutions

## Phase 0 Verification

Phase 0 can be completed entirely on Windows:

- [x] Spring Boot backend running
- [x] MySQL database connected
- [x] Flutter app builds
- [x] GetX configured
- [x] API communication works
- [x] **End-to-end verified on Windows** ✅

## Screenshots & Demo

Running on Windows provides:
- Full-screen desktop app
- Native window controls
- Keyboard/mouse support
- Better performance than emulator

## Development Workflow

**Current (Phase 0-3)**:
```
Kiro (edit code)
    ↓
Backend: mvn spring-boot:run
    ↓
Frontend: flutter run -d windows
    ↓
Test on Windows Desktop ✅
```

**Future (Phase 4+)**:
```
Kiro (edit code)
    ↓
Backend: mvn spring-boot:run
    ↓
Android Studio: Run on Emulator
    ↓
Test on Android Emulator
```

## Troubleshooting

### "Backend not reachable"
- Ensure backend is running on port 8080
- Check `http://localhost:8080/api/ping` in browser

### "Port 8080 in use"
- Stop other applications
- Or change port in `application.properties`

### Windows app doesn't start
```bash
flutter clean
flutter pub get
flutter run -d windows
```

## Next Steps

1. ✅ Run backend: `mvn spring-boot:run`
2. ✅ Run frontend: `flutter run -d windows`
3. ✅ Test connection in app
4. ✅ Phase 0 complete!
5. → Move to Phase 1: Authentication & Profiles

---

**Phase 0 Status**: Can be completed on Windows Desktop ✅  
**Android Requirement**: Not needed until Phase 4 (QR scanning)
