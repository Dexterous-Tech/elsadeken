# Elsadeken App

A Flutter application with camera functionality and profile management features.

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

## 📱 Platform Setup

### iOS Setup

#### Camera Permissions
The app requires these permissions in `Info.plist`:
- **Camera**: `NSCameraUsageDescription` - "This app requires camera access to take photos for profile pictures and document scanning."
- **Photo Library**: `NSPhotoLibraryUsageDescription` - "This app requires access to your photo library to select existing photos for profile pictures and document uploads."
- **Photo Library Add**: `NSPhotoLibraryAddUsageDescription` - "This app requires permission to save photos to your photo library."
- **Microphone**: `NSMicrophoneUsageDescription` - "This app requires microphone access for video recording functionality."

#### Notification Permissions
- **Push Notifications**: Add capability in Xcode
- **Background Modes**: Enable "Remote notifications" and "Background processing"

### Android Setup

#### Camera Permissions
- Camera access is handled automatically by Flutter
- Photo library access is managed by the system
- No additional configuration required

#### Notification Permissions
- Ensure notification channel is configured with high importance
- Check device notification settings

## 🔧 Debug Steps

### iOS Debug
```bash
# Clean build
flutter clean
flutter pub get

# Rebuild iOS
cd ios && pod install && cd ..

# Run with verbose logging
flutter run --verbose
```

### Android Debug
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

## 🏗️ Project Structure

```
lib/
├── core/           # Core utilities, themes, and shared widgets
├── features/       # Feature-specific modules
│   ├── auth/      # Authentication
│   ├── chat/      # Chat functionality
│   ├── home/      # Home screen
│   ├── members/   # Member management
│   ├── profile/   # Profile management
│   └── search/    # Search functionality
└── main.dart      # App entry point
```

## 🎯 Key Features

- **User Authentication**: Login, registration, and profile management
- **Camera Integration**: Photo capture and gallery selection
- **Profile Management**: Image upload and privacy settings
- **Real-time Chat**: Pusher-based chat system
- **Member Search**: Advanced search and filtering
- **Responsive Design**: Cross-platform compatibility

## 🔐 Environment Setup

### Firebase Configuration
- Ensure `google-services.json` is in `android/app/`
- Verify Firebase configuration in `lib/firebase_options.dart`

### API Configuration
- Check API endpoints in `lib/core/networking/api_constants.dart`
- Verify authentication tokens and headers

## 🧪 Testing

### iOS Testing
- Test on physical iOS device for full camera functionality
- Grant camera and photo library permissions
- Verify notification permissions

### Android Testing
- Camera permissions are handled automatically
- Test notification functionality
- Verify profile image upload

## 🚨 Common Issues

### iOS Issues
- **Camera crashes**: Ensure permissions are granted in iOS Settings
- **Notifications not working**: Check Xcode capabilities and entitlements
- **Build errors**: Run `cd ios && pod install && cd ..`

### Android Issues
- **Foreground notifications**: Check notification channel importance
- **Permission issues**: Verify device notification settings

## 📞 Support

For issues:
1. Check this README for troubleshooting steps
2. Verify all permissions are properly configured
3. Test on physical devices for full functionality
4. Check Flutter and platform logs for error details

---

**Note**: This app requires camera, photo library, and notification access to function properly. Ensure all permissions are granted during testing to avoid crashes.
