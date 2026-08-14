# Flutter Build Troubleshooting - Gradle Network Issues

## Problem
`Gradle threw an error while downloading artifacts from the network`

This happens when Gradle cannot download dependencies due to network issues.

## Solutions (Try in Order)

### Solution 1: Configure Gradle to Use HTTP Instead of HTTPS (Quickest)

Update the Gradle wrapper to use a direct download:

1. Open `frontend/android/gradle/wrapper/gradle-wrapper.properties`
2. Change the distribution URL from HTTPS to HTTP (if connection issues persist)

Or use an already downloaded Gradle distribution.

### Solution 2: Use Gradle Offline Mode (If Gradle is Already Downloaded)

```bash
cd frontend
flutter build apk --debug --offline
```

Or run with offline:
```bash
flutter run --offline
```

### Solution 3: Configure Proxy (If Behind Corporate Firewall)

Create/Edit `frontend/android/gradle.properties` and add:

```properties
systemProp.http.proxyHost=YOUR_PROXY_HOST
systemProp.http.proxyPort=YOUR_PROXY_PORT
systemProp.https.proxyHost=YOUR_PROXY_HOST
systemProp.https.proxyPort=YOUR_PROXY_PORT
```

### Solution 4: Pre-download Gradle Distribution

1. Download Gradle manually from https://services.gradle.org/distributions/
2. Place in `C:\Users\ASUS\.gradle\wrapper\dists\`
3. Run `flutter clean` and try again

### Solution 5: Use Windows Desktop Instead of Android Emulator

Since you have Windows available, you can run on Windows desktop for development:

```bash
flutter run -d windows
```

This bypasses the Gradle/Android build entirely for Phase 0 testing!

### Solution 6: Increase Gradle Timeout

Add to `frontend/android/gradle.properties`:

```properties
org.gradle.daemon=true
org.gradle.jvmargs=-Xmx4096m
org.gradle.parallel=true
systemProp.http.socketTimeout=120000
systemProp.http.connectionTimeout=120000
```

### Solution 7: Check Windows Firewall

1. Open Windows Defender Firewall
2. Allow Java through firewall
3. Retry `flutter run`

## Quick Fix: Run on Windows Desktop (Recommended for Now)

Since Flutter detected Windows as a connected device, you can test the app on Windows desktop:

```bash
# Run on Windows
flutter run -d windows

# Or list devices and choose
flutter devices
flutter run -d windows
```

This will:
- Build faster (no Gradle downloads needed)
- Work immediately
- Still test Flutter → Spring Boot connectivity
- Use `http://localhost:8080/api` (update api_client.dart)

## For Android Development Later

Once you need Android specifically, you can:
1. Pre-download Gradle
2. Configure proxy if needed
3. Use offline mode
4. Or use Android Studio's built-in Gradle

## Testing Backend Connection

You can test the backend connection on Windows desktop for now, then switch to Android later once Gradle issues are resolved.

**Update `lib/services/api_client.dart` for Windows**:
```dart
// For Windows Desktop
static const String baseUrl = 'http://localhost:8080/api';

// For Android Emulator (use later)
// static const String baseUrl = 'http://10.0.2.2:8080/api';
```
