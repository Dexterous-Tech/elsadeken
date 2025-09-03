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

## 📱 iOS Testing Instructions

### ⚠️ IMPORTANT: Camera Permissions Setup

To prevent crashes when testing camera functionality on iOS, follow these steps:

#### 1. Physical iOS Device Testing
- **Camera Permission**: When you first try to use the camera, iOS will prompt for permission
- **Photo Library Permission**: Grant access to photo library when prompted
- **Settings Verification**: If permissions are denied, go to:
  - `Settings` → `Privacy & Security` → `Camera` → Enable for Elsadeken
  - `Settings` → `Privacy & Security` → `Photos` → Enable for Elsadeken

#### 2. iOS Simulator Testing
- **Camera Limitations**: iOS Simulator has limited camera functionality
- **Photo Library**: You can test photo selection from library
- **Camera Testing**: For full camera testing, use a physical iOS device

#### 3. Permission Descriptions in Info.plist
The app includes these permission descriptions:
- **Camera**: "This app requires camera access to take photos for profile pictures and document scanning."
- **Photo Library**: "This app requires access to your photo library to select existing photos for profile pictures and document uploads."
- **Photo Library Add**: "This app requires permission to save photos to your photo library."
- **Microphone**: "This app requires microphone access for video recording functionality."
- **Documents Folder**: "This app requires access to documents folder for file uploads and downloads."

### 📸 Photo Upload Permissions
For complete photo upload functionality, the app requires:
1. **Camera Access** - To capture new photos
2. **Photo Library Access** - To select existing photos from device
3. **Photo Library Add** - To save photos to device gallery
4. **Documents Folder Access** - To access files for uploads

### 🔧 Troubleshooting iOS Camera Issues

#### Common Issues and Solutions:

1. **App Crashes on Camera Access**
   - Ensure all permissions are granted in iOS Settings
   - Check that Info.plist contains all required permission keys
   - Verify the app is properly signed and provisioned

2. **Camera Not Opening**
   - Check if camera permission is granted
   - Restart the app after granting permissions
   - Ensure device has a working camera

3. **Photo Library Access Issues**
   - Grant photo library access when prompted
   - Check iOS Settings for photo permissions
   - Restart app after permission changes

#### Debug Steps:
1. Clean build: `flutter clean && flutter pub get`
2. Rebuild iOS: `cd ios && pod install && cd ..`
3. Run with verbose logging: `flutter run --verbose`

### 📱 Android Testing

Android testing follows standard Flutter procedures:
- Camera permissions are handled automatically
- Photo library access is managed by the system
- No additional configuration required

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

## 🧪 Testing Checklist

### iOS Testing
- [ ] App launches without crashes
- [ ] Camera permission prompt appears
- [ ] Photo library permission prompt appears
- [ ] Camera opens and captures photos
- [ ] Photo selection from gallery works
- [ ] Profile image upload functions
- [ ] No permission-related crashes

### General Testing
- [ ] User registration and login
- [ ] Profile creation and editing
- [ ] Image upload and management
- [ ] Chat functionality
- [ ] Search and filtering
- [ ] Responsive design on different screen sizes

## 🚨 Known Issues

- **iOS Simulator**: Limited camera functionality
- **Permission Denial**: App may crash if permissions are denied and not properly handled
- **Image Upload**: Large images may take time to process

## 📞 Support

For testing issues or questions:
1. Check this README for troubleshooting steps
2. Verify all permissions are properly configured
3. Test on physical iOS device for full camera functionality
4. Check Flutter and iOS logs for error details

## 🔄 Updates

- Keep Flutter SDK updated
- Regularly update iOS deployment target
- Monitor permission changes in iOS updates
- Test camera functionality after major updates

---

**Note**: This app requires camera and photo library access to function properly. Ensure all permissions are granted during testing to avoid crashes.
