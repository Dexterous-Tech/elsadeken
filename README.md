# Elsadeken App

A comprehensive Flutter application with camera functionality, profile management, real-time chat, and advanced features supporting both Arabic and English languages.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- iOS Simulator or physical iOS device
- Android Studio / VS Code
- Xcode (for iOS development)

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd elsadeken
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## 📱 Platform-Specific Setup

### iOS Setup

#### Critical: Preventing Camera Crashes on iOS

To prevent crashes when testing camera functionality on iOS, follow these steps:

##### 1. Physical iOS Device Testing
- **Camera Permission**: When you first try to use the camera, iOS will prompt for permission
- **Photo Library Permission**: Grant access to photo library when prompted
- **Settings Verification**: If permissions are denied, go to:
  - `Settings` → `Privacy & Security` → `Camera` → Enable for Elsadeken
  - `Settings` → `Privacy & Security` → `Photos` → Enable for Elsadeken

##### 2. iOS Simulator Testing
- **Camera Limitations**: iOS Simulator has limited camera functionality
- **Photo Library**: You can test photo selection from library
- **Camera Testing**: For full camera testing, use a physical iOS device

##### 3. Permission Descriptions in Info.plist
The app includes these permission descriptions:
- **Camera**: "This app requires camera access to take photos for profile pictures and document scanning."
- **Photo Library**: "This app requires access to your photo library to select existing photos for profile pictures and document uploads."
- **Photo Library Add**: "This app requires permission to save photos to your photo library."
- **Microphone**: "This app requires microphone access for video recording functionality."
- **Documents Folder**: "This app requires access to documents folder for file uploads and downloads."

#### iOS Notification Setup

##### Manual Xcode Configuration Required
After code changes, you MUST manually configure these settings in Xcode:

1. **Open Project in Xcode**
```bash
cd ios
open Runner.xcworkspace
```

2. **Add Push Notifications Capability**
   - Select your **Runner** target
   - Go to **Signing & Capabilities** tab
   - Click **+ Capability**
   - Add **Push Notifications**

3. **Add Background Modes Capability**
   - Click **+ Capability** again
   - Add **Background Modes**
   - Check these options:
     - ✅ **Remote notifications**
     - ✅ **Background processing**

4. **Verify Bundle Identifier**
   - In **Signing & Capabilities**
   - Ensure **Bundle Identifier** matches your Firebase configuration
   - Current: `com.example.elsadeken`
   - **Important**: Update this to match your actual bundle ID

5. **Update Entitlements File**
   - In **Signing & Capabilities**
   - Under **Entitlements**, ensure `Runner.entitlements` is selected
   - Verify these keys are present:
     - `aps-environment` = `development` (change to `production` for App Store)
     - `com.apple.developer.usernotifications.time-sensitive` = `true`

### Android Setup

#### Android Foreground Notification Fix

**Problem**: Android app receives notifications when closed/background, but **NO notifications when app is in foreground (open)**.

**Solutions Applied**:

1. **Enhanced Notification Channel**
```dart
static const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
  playSound: true,        // ✅ Added
  enableVibration: true,  // ✅ Added
  showBadge: true,        // ✅ Added
);
```

2. **Improved Foreground Notification Display**
```dart
AndroidNotificationDetails(
  // ... other settings
  importance: Importance.high,    // ✅ Required
  priority: Priority.high,        // ✅ Required
  showWhen: true,                 // ✅ Recommended
  enableVibration: true,          // ✅ Recommended
  playSound: true,                // ✅ Recommended
)
```

## 🏗️ Project Structure

```
lib/
├── core/           # Core utilities, themes, and shared widgets
│   ├── di/        # Dependency injection
│   ├── errors/    # Error handling
│   ├── helper/    # Helper utilities
│   ├── networking/# API networking
│   ├── routes/    # App routing
│   ├── services/  # Core services
│   ├── shared/    # Shared preferences
│   ├── theme/     # App theming
│   └── widgets/   # Shared widgets
├── features/       # Feature-specific modules
│   ├── auth/      # Authentication
│   ├── chat/      # Chat functionality
│   ├── home/      # Home screen
│   ├── members/   # Member management
│   ├── on_boarding/# Onboarding
│   ├── profile/   # Profile management
│   ├── results/   # Results display
│   ├── search/    # Search functionality
│   └── splash/    # Splash screen
├── l10n/          # Localization files
└── main.dart      # App entry point
```

## 🎯 Key Features

- **User Authentication**: Login, registration, and profile management
- **Camera Integration**: Photo capture and gallery selection
- **Profile Management**: Image upload and privacy settings
- **Real-time Chat**: Pusher-based chat system
- **Member Search**: Advanced search and filtering
- **Responsive Design**: Cross-platform compatibility
- **Multi-language Support**: Arabic (RTL) and English (LTR)
- **Smart Caching**: Performance-optimized data loading
- **Progress Persistence**: Signup progress saving and resumption

## 🌐 Localization System

The app supports two languages with full RTL/LTR support:

### Supported Languages
- **Arabic (ar)** - Default language with RTL support
- **English (en)** - LTR support

### Key Components

1. **LocalizationService** - Manages current locale and language changes
2. **LocalizationHelper** - Provides RTL/LTR layout support
3. **Language Toggle Widget** - Pre-built language switching widget

### Usage Examples

```dart
// Get localized text
final text = LocalizationHelper.getLocalizedText('مرحبا', 'Hello');

// RTL/LTR layout support
Column(
  crossAxisAlignment: LocalizationHelper.startCrossAxisAlignment,
  children: [Text('Content')],
)

// Conditional layout based on language
Row(
  mainAxisAlignment: LocalizationHelper.isArabic 
    ? MainAxisAlignment.end 
    : MainAxisAlignment.start,
  children: [Icon(Icons.arrow_back), Text('Back')],
)
```

### Adding New Translations

1. **Update ARB Files**
   - Add keys to `lib/l10n/app_en.arb` and `lib/l10n/app_ar.arb`
2. **Use in Code**
   - `LocalizationHelper.getLocalizedText('النص العربي', 'English Text')`

## 🚀 Performance Optimizations

### Smart Caching System

The app implements a sophisticated caching system for static data:

#### Cache Features
- **Secure Storage**: Uses `FlutterSecureStorage` for encrypted data persistence
- **Cache Expiration**: 24-hour TTL with automatic invalidation
- **Parallel Loading**: Nationalities and countries fetched simultaneously
- **Cache-First Strategy**: Check cache before making API calls

#### Performance Improvements
- **First Load**: 1000-1041ms (API call + cache storage)
- **Subsequent Loads**: 5-50ms (cache retrieval)
- **Performance Improvement**: **50-95% faster** for cached data
- **Reduced API Calls**: 80-90% reduction in network requests

#### Cache Behavior
```
Cache Hit: User opens dialog → Check cache → Cache valid → Return data (5-50ms)
Cache Miss: User opens dialog → Check cache → Cache expired → API call → Update cache → Return data (1000-1041ms)
Force Refresh: User clicks refresh → Clear cache → API call → Update cache → Return data (1000-1041ms)
```

## 💾 Signup Progress Persistence

### Features
- **Automatic Data Saving**: All form data saved when moving between steps
- **Progress Persistence**: Current step and form data saved to secure storage
- **Resume Functionality**: Users can resume from last step
- **Data Expiration**: Saved data expires after 24 hours for security
- **Automatic Cleanup**: Data cleared after successful registration

### How It Works
1. **Data Model**: `SignupFormDataModel` stores all 13 signup steps
2. **Shared Preferences**: `SharedPreferencesHelper` manages data persistence
3. **SignupCubit**: Enhanced with save/load/clear methods
4. **UI Integration**: Automatic detection and loading of saved data

### Usage
```dart
final cubit = SignupCubit.get(context);

// Check if there's saved data
if (await cubit.hasRecentSignupData()) {
  await cubit.loadSavedFormData();
  final savedStep = await cubit.getCurrentStep();
  // Resume from saved step
}

// Save current form data
await cubit.saveFormData();

// Clear saved data
await cubit.clearSignupData();
```

## 🔐 Environment Setup

### Firebase Configuration
- Ensure `google-services.json` is in `android/app/`
- Verify Firebase configuration in `lib/firebase_options.dart`
- Configure push notifications in Firebase Console

### API Configuration
- Check API endpoints in `lib/core/networking/api_constants.dart`
- Verify authentication tokens and headers
- Language headers automatically updated based on locale

## 🧪 Testing Guidelines

### iOS Testing Checklist

#### Camera Functionality
- [ ] App launches without crashes
- [ ] Camera permission prompt appears
- [ ] Camera opens successfully
- [ ] Photo capture works
- [ ] Image displays in app
- [ ] No permission-related crashes

#### Photo Library
- [ ] Photo library permission prompt appears
- [ ] Gallery opens successfully
- [ ] Photo selection works
- [ ] Selected image displays in app
- [ ] No access-related crashes

#### Notification Functionality
- [ ] Notification permission prompt appears on first launch
- [ ] FCM token is generated successfully
- [ ] Foreground notifications display correctly
- [ ] Background notifications work when app is minimized
- [ ] Closed app notifications appear on lock screen
- [ ] Console logs show proper notification status

### Android Testing Checklist

#### Notification Testing
- [ ] Fix applied to notification service
- [ ] Notification channel enhanced
- [ ] Foreground notification method improved
- [ ] Platform detection added
- [ ] Test notification sent while app open
- [ ] Notification banner appears at top
- [ ] Sound plays (if enabled)
- [ ] Vibration works (if enabled)
- [ ] Console logs show success messages

### General Testing
- [ ] User registration and login
- [ ] Profile creation and editing
- [ ] Image upload and management
- [ ] Chat functionality
- [ ] Search and filtering
- [ ] Responsive design on different screen sizes
- [ ] Language switching (Arabic/English)
- [ ] RTL/LTR layout support
- [ ] Cache functionality
- [ ] Signup progress persistence

## 🚨 Troubleshooting

### iOS Issues

#### App Crashes on Camera Access
**Solution:**
1. Check iOS Settings → Privacy & Security → Camera
2. Ensure Elsadeken has camera permission
3. Restart the app completely
4. Try camera access again

#### Camera Permission Denied
**Solution:**
1. Go to iOS Settings → Privacy & Security → Camera
2. Toggle Elsadeken permission OFF and ON
3. Restart the app
4. Test camera functionality

#### No Notifications Received
**Solution:**
1. Check Settings → Notifications → Elsadeken → Allow Notifications = ON
2. Verify Alert Style is set to "Banners" or "Alerts"
3. Check Settings → Focus → Do Not Disturb = OFF
4. Ensure app has notification permissions

### Android Issues

#### No Foreground Notifications
**Solutions:**
1. **Check Android Settings**:
   - Settings → Apps → Elsadeken → Notifications
   - Ensure "Show notifications" is ON
   - Check "Importance" is set to "High"

2. **Check Do Not Disturb**:
   - Settings → Notifications → Do Not Disturb
   - Ensure it's OFF or Elsadeken is allowed

3. **Check Focus Mode** (Android 12+):
   - Settings → Focus Mode
   - Ensure Elsadeken notifications are allowed

### General Issues

#### Language Not Changing
- Ensure `ListenableBuilder` is used
- Check if `LocalizationService.instance` is properly initialized
- Verify the locale change method is called

#### Layout Issues
- Use `LocalizationHelper` alignment properties
- Test both RTL and LTR layouts
- Check if `Directionality` widget is properly set

#### Cache Issues
- Check if cache keys are properly configured
- Verify cache expiration settings
- Test force refresh functionality

## 🔍 Debug Information

### Check Permission Status
```bash
# Run with verbose logging
flutter run --verbose

# Check iOS logs in Xcode
# Window → Devices and Simulators → View Device Logs
```

### Check Notification Status
```bash
# Run with verbose logging to see notification debug info
flutter run --verbose

# Look for these specific log messages:
# 📱 Notification settings: authorized
# 🔑 FCM Token: [token-here]
# ⚙️ Local notifications enabled: true
```

### Check Cache Status
```bash
# Look for cache-related logs:
# 🗄️ Cache hit: [data-type]
# 🗄️ Cache miss: [data-type]
# 🗄️ Cache updated: [data-type]
```

## 🚀 Quick Commands

```bash
# Clean and rebuild
flutter clean && flutter pub get

# Run on iOS device
flutter run

# Run with verbose logging
flutter run --verbose

# Build release version
flutter build ios --release
flutter build apk --release

# Test notification permissions
await FirebaseNotificationService.instance.checkNotificationPermissions();

# Get FCM token
String? token = await FirebaseNotificationService.instance.getFCMToken();
print('FCM Token: $token');

# Test foreground notification
await FirebaseNotificationService.instance.testForegroundNotification();
```

## 📋 Development Checklist

### Code Quality
- [ ] Use `ListenableBuilder` for localization
- [ ] Implement proper error handling
- [ ] Add loading states for async operations
- [ ] Use cache-first strategy for static data
- [ ] Implement proper permission handling
- [ ] Test both RTL and LTR layouts

### Performance
- [ ] Implement caching for static data
- [ ] Use parallel loading where possible
- [ ] Prevent duplicate API calls
- [ ] Optimize image loading and caching
- [ ] Monitor API response times

### Security
- [ ] Use secure storage for sensitive data
- [ ] Implement proper data expiration
- [ ] Handle permission errors gracefully
- [ ] Validate user input
- [ ] Secure API communication

## 🆘 Support

For testing issues or questions:

1. **Check this README** for troubleshooting steps
2. **Verify all permissions** are properly configured
3. **Test on physical devices** for full functionality
4. **Check Flutter and platform logs** for error details
5. **Review platform-specific setup** guides above

### Platform-Specific Support

#### iOS Support
- Check Xcode capabilities and entitlements
- Verify Firebase configuration
- Test on physical iOS device
- Check iOS Settings for permissions

#### Android Support
- Verify notification channel configuration
- Check device-specific notification settings
- Test on different Android versions
- Verify Firebase configuration

## 🔄 Updates

- Keep Flutter SDK updated
- Regularly update iOS deployment target
- Monitor permission changes in platform updates
- Test functionality after major updates
- Update cache expiration settings as needed
- Monitor performance metrics

## 📞 Contact

For additional help:
- Check platform-specific documentation
- Review Firebase documentation
- Ensure testing on real devices
- Contact development team with error details

---

**Note**: This app requires camera, photo library, and notification access to function properly. Ensure all permissions are granted during testing to avoid crashes and ensure full functionality.

**Remember**: 
- **Camera testing** requires a physical iOS device. iOS Simulator has limited camera functionality.
- **Notification testing** requires a physical device. Simulators don't support push notifications.
- **Always test on real devices** for both camera and notification functionality.
- **Test both languages** (Arabic/English) to ensure proper RTL/LTR support.
- **Verify cache functionality** for optimal performance.
- **Test signup persistence** to ensure user progress is saved.
